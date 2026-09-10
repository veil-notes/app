#!/usr/bin/env python3
"""Prepare disposable Flutter/Android inputs for path-independent APK builds."""

from __future__ import annotations

import json
import re
import shutil
import sys
from pathlib import Path
from urllib.parse import unquote, urljoin, urlparse


def replace_once(path: Path, old: str, new: str) -> None:
    text = path.read_text()
    if new in text:
        return
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"unexpected patch shape in {path}: found {count} matches")
    path.write_text(text.replace(old, new))


def patch_flutter(flutter_root: Path) -> None:
    helper_file = (
        flutter_root
        / "packages/flutter_tools/gradle/src/main/kotlin/tasks/BaseFlutterTaskHelper.kt"
    )
    replace_once(
        helper_file,
        """            baseFlutterTask.extraFrontEndOptions?.let {
                args("--ExtraFrontEndOptions=$it")
            }

""",
        """            baseFlutterTask.extraFrontEndOptions?.let {
                args("--ExtraFrontEndOptions=$it")
            }
            baseFlutterTask.fileSystemRoots?.takeIf { it.isNotEmpty() }?.let {
                args("-dFileSystemRoots=${it.joinToString(",")}")
            }
            baseFlutterTask.fileSystemScheme?.let {
                args("-dFileSystemScheme=$it")
            }

""",
    )

    compile_file = flutter_root / "packages/flutter_tools/lib/src/compile.dart"
    text = compile_file.read_text()
    if "effectiveFileSystemRoots" not in text:
        replace_once(
            compile_file,
            "    String? mainUri;\n    if (mainPath != null) {",
            "    final List<String> effectiveFileSystemRoots = "
            "fileSystemRoots ?? _fileSystemRoots;\n"
            "    final String? effectiveFileSystemScheme = "
            "fileSystemScheme ?? _fileSystemScheme;\n"
            "    String? mainUri;\n    if (mainPath != null) {",
        )
        text = compile_file.read_text()
    old_arguments = r"(?m)^(\s*)_fileSystemScheme,\n\1_fileSystemRoots,"
    argument_matches = len(re.findall(old_arguments, text))
    if argument_matches not in (0, 2):
        raise RuntimeError(
            f"unexpected compile.dart argument shape: "
            f"found {argument_matches} matches"
        )
    if argument_matches == 2:
        compile_file.write_text(
            re.sub(
                old_arguments,
                r"\1effectiveFileSystemScheme,\n\1effectiveFileSystemRoots,",
                text,
            )
        )
    shutil.rmtree(flutter_root / "packages/flutter_tools/gradle/build", ignore_errors=True)


def patch_jni(app_dir: Path) -> None:
    package_config_path = app_dir / ".dart_tool/package_config.json"
    config = json.loads(package_config_path.read_text())
    config_dir_uri = package_config_path.parent.resolve().as_uri() + "/"
    jni_root_uri = next(
        (
            package.get("rootUri")
            for package in config.get("packages", [])
            if package.get("name") == "jni"
        ),
        None,
    )
    if not jni_root_uri:
        raise RuntimeError("package:jni was not found in package_config.json")

    resolved = urljoin(config_dir_uri, jni_root_uri)
    parsed = urlparse(resolved)
    if parsed.scheme != "file":
        raise RuntimeError(f"package:jni rootUri is not a file URI: {jni_root_uri}")

    cmake_file = Path(unquote(parsed.path)) / "src/CMakeLists.txt"
    replace_once(
        cmake_file,
        'target_link_options(jni PRIVATE "-Wl,-z,max-page-size=16384")',
        'target_link_options(jni PRIVATE "-Wl,-z,max-page-size=16384" "-Wl,--build-id=none")',
    )


def main() -> int:
    if len(sys.argv) not in (2, 3):
        print(f"usage: {sys.argv[0]} <app-dir> [flutter-root]", file=sys.stderr)
        return 2

    app_dir = Path(sys.argv[1]).resolve()
    flutter_executable = shutil.which("flutter")
    if len(sys.argv) == 3:
        flutter_root = Path(sys.argv[2]).resolve()
    elif flutter_executable:
        flutter_root = Path(flutter_executable).resolve().parent.parent
    else:
        print("flutter was not found on PATH", file=sys.stderr)
        return 2

    patch_flutter(flutter_root)
    patch_jni(app_dir)
    for stale_snapshot in (
        flutter_root / "bin/cache/flutter_tools.snapshot",
        flutter_root / "bin/cache/flutter_tools.stamp",
    ):
        stale_snapshot.unlink(missing_ok=True)

    print("Prepared Flutter and JNI inputs for a path-independent Android build.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
