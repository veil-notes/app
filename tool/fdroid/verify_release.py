#!/usr/bin/env python3
"""Check release inputs and signed APKs before publishing (Python stdlib only)."""

import argparse
import re
import subprocess
import tempfile
from pathlib import Path
from zipfile import ZipFile

from build_openpgp import GO_VERSION, LIBRARY


ABI_OFFSETS = {"armeabi-v7a": 1000, "arm64-v8a": 2000, "x86_64": 4000}
RELEASE_PATTERN = r"[0-9]+\.[0-9]+\.[0-9]+(?:-beta\.[0-9]+)?"
SIGNING_CERTIFICATE = "600008c667784b0d2b7c224784da2b14f962b9ab8c5c869be476cee813b3f643"


def release_version(pubspec, tag):
    return parse_version(Path(pubspec).read_text(encoding="utf-8"), tag)


def parse_version(text, tag):
    match = re.search(
        rf"^version:\s*({RELEASE_PATTERN})\+([1-9][0-9]*)\s*$",
        text, re.MULTILINE,
    )
    if not match or tag != f"v{match[1]}":
        raise ValueError("release tag must match the stable or beta version in pubspec.yaml")
    version, base = match[1], int(match[2])
    if base + max(ABI_OFFSETS.values()) > 2100000000:
        raise ValueError("version code exceeds Android's maximum")
    return version, base


def check_history(base, tag):
    tags = subprocess.check_output(["git", "tag", "--merged", "HEAD"], text=True).splitlines()
    for previous in tags:
        if previous == tag or not re.fullmatch("v" + RELEASE_PATTERN, previous):
            continue
        text = subprocess.check_output(["git", "show", f"{previous}:pubspec.yaml"], text=True)
        _, previous_base = parse_version(text, previous)
        # fdroidserver sorts builds by code and clones the last three.
        minimum = previous_base + max(ABI_OFFSETS.values()) - min(ABI_OFFSETS.values()) + 1
        if base < minimum:
            raise ValueError(f"base must be at least {minimum} after {previous} "
                             "to keep all three F-Droid ABI recipes together")


def check_badging(badging, version, code, abi):
    package = re.search(r"^package: (.+)$", badging, re.MULTILINE)
    fields = dict(re.findall(r"(\w+)='([^']*)'", package[1])) if package else {}
    expected = {"name": "app.veil.veil", "versionName": version, "versionCode": str(code)}
    for key, value in expected.items():
        if fields.get(key) != value:
            raise ValueError(f"{key}: expected {value!r}, got {fields.get(key)!r}")
    native = re.search(r"^native-code:\s*(.*)$", badging, re.MULTILINE)
    if not native or re.findall(r"'([^']+)'", native[1]) != [abi]:
        raise ValueError(f"APK must target only {abi}")


def check_certificate(output):
    certificates = re.findall(
        r"^Signer #\d+ certificate SHA-256 digest:\s*([0-9a-fA-F]+)\s*$",
        output, re.MULTILINE,
    )
    if [cert.lower() for cert in certificates] != [SIGNING_CERTIFICATE]:
        raise ValueError("APK signing certificate does not match AllowedAPKSigningKeys")


def check_native_build_info(output):
    lines = output.splitlines()
    if not lines or not lines[0].endswith(f": {GO_VERSION}"):
        raise ValueError(f"OpenPGP library must be built with {GO_VERSION}")
    # Go intentionally omits ldflags from build-info when -trimpath is set.
    required = {"\tbuild\t-trimpath=true", "\tbuild\tGOOS=android", "\tbuild\t-buildmode=c-shared"}
    if not required.issubset(lines):
        raise ValueError("OpenPGP library must use -trimpath and Android c-shared mode")


def verify_apk(apk, build_tools, version, code, abi):
    badging = subprocess.check_output(
        [str(build_tools / "aapt"), "dump", "badging", str(apk)], text=True,
    )
    check_badging(badging, version, code, abi)
    with ZipFile(apk) as archive:
        abis = {name.split("/")[1] for name in archive.namelist()
                if name.startswith("lib/") and name.endswith(".so")}
        native_library = archive.read(f"lib/{abi}/{LIBRARY}")
    if abis != {abi}:
        raise ValueError(f"unexpected native library directories: {abis}")
    with tempfile.TemporaryDirectory(prefix="veil-apk-native-") as directory:
        library = Path(directory) / LIBRARY
        library.write_bytes(native_library)
        info = subprocess.check_output(["go", "version", "-m", str(library)], text=True)
        check_native_build_info(info)
    signature = subprocess.check_output(
        [str(build_tools / "apksigner"), "verify", "--verbose", "--print-certs", str(apk)],
        text=True,
    )
    check_certificate(signature)
    print(f"Verified {apk.name}: {version} / {code} / {abi}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pubspec", type=Path, default=Path("pubspec.yaml"))
    parser.add_argument("--tag", required=True)
    parser.add_argument("--assets", type=Path)
    parser.add_argument("--build-tools", type=Path)
    parser.add_argument("--check-history", action="store_true")
    args = parser.parse_args()
    version, base = release_version(args.pubspec, args.tag)
    if args.check_history:
        check_history(base, args.tag)
    if args.assets:
        if not args.build_tools:
            parser.error("--assets requires --build-tools")
        for abi, offset in ABI_OFFSETS.items():
            for prefix in ("app", "app-fdroid"):
                verify_apk(args.assets / f"{prefix}-{abi}-release.apk",
                           args.build_tools, version, base + offset, abi)
    print(f"Release inputs verified: {version}+{base}")


if __name__ == "__main__":
    main()
