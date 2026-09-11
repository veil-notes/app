#!/usr/bin/env python3
"""Validate a standalone recipe in a disposable checkout (requires fdroidserver)."""

import argparse
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path
from unittest.mock import patch

import yaml
from fdroidserver import checkupdates, metadata


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("recipe", type=Path)
    parser.add_argument("--categories", type=Path, required=True,
                        help="fdroiddata/config/categories.yml from the target repository")
    args = parser.parse_args()
    source = args.recipe.resolve()
    categories = yaml.safe_load(args.categories.read_text())
    with tempfile.TemporaryDirectory(prefix="veil-fdroid-") as directory:
        original = Path.cwd()
        try:
            os.chdir(directory)
            subprocess.run(["git", "init", "-q"], check=True)
            Path("metadata").mkdir()
            Path("config").mkdir()
            # Category membership comes from fdroiddata, not from this recipe.
            # Icons and translations are irrelevant to this isolated lint run.
            Path("config/categories.yml").write_text(yaml.safe_dump(
                {key: {"name": key} for key in categories},
            ))
            recipe = Path("metadata/app.veil.veil.yml")
            shutil.copyfile(source, recipe)
            subprocess.run(["fdroid", "readmeta"], check=True)
            subprocess.run(["fdroid", "lint", "app.veil.veil"], check=True)
            app = metadata.read_metadata()["app.veil.veil"]
            pattern = app.UpdateCheckMode.removeprefix("Tags ")
            for tag in ("v1.0.0", "v1.0.0-beta.6", "v1.0.0-beta.7"):
                assert re.fullmatch(pattern, tag), tag
            for tag in ("v1.0.0-alpha.1", "v1.0.0-rc.1", "v1.0.0-beta", "v1.0"):
                assert not re.fullmatch(pattern, tag), tag

            # Inject only remote discovery; exercise fdroidserver's actual
            # multi-ABI build generation and serialization offline.
            current_beta = re.fullmatch(r"(.+-beta\.)(\d+)", app.CurrentVersion)
            if not current_beta:
                raise ValueError("This update simulation expects a numbered beta recipe")
            initial_base = app.CurrentVersionCode - 4000
            initial_count = len(app.Builds)
            for increment in (1, 2):
                version = current_beta[1] + str(int(current_beta[2]) + increment)
                next_base = initial_base + 3001 * increment
                count = initial_count + 3 * increment
                with patch.object(checkupdates, "check_tags", return_value=(
                    version, next_base, f"v{version}",
                )), patch.object(checkupdates, "fetch_autoname", return_value=None):
                    checkupdates.checkupdates_app(app, auto=True)
                app = metadata.read_metadata()["app.veil.veil"]
                assert len(app.Builds) == count
                for build, offset, abi in zip(app.Builds[-3:], (1000, 2000, 4000),
                                              ("armeabi-v7a", "arm64-v8a", "x86_64")):
                    assert build.versionCode == next_base + offset
                    assert build.versionName == version
                    assert build.commit == f"v{version}"
                    url = build.binary.replace("%v", build.versionName).replace("%c", str(build.versionCode))
                    assert url.endswith(f"/v{version}/{build.versionCode}.apk")
                    command = next(line for line in build.build if "--build-number=" in line)
                    expression = re.search(r"--build-number=(\$\(\(.*?\)\))", command)[1]
                    base = subprocess.check_output(
                        ["bash", "-c", "echo " + expression.replace("$$VERCODE$$", str(build.versionCode))],
                        text=True,
                    ).strip()
                    assert base == str(next_base), base
            print("F-Droid readmeta/lint and two consecutive three-ABI beta updates passed")
        finally:
            os.chdir(original)


if __name__ == "__main__":
    main()
