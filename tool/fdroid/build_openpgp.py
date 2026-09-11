#!/usr/bin/env python3
"""Build the OpenPGP Android bridge identically in GitHub and F-Droid."""

import argparse
import hashlib
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

GO_VERSION = "go1.24.1"
NDK_VERSION = "28.2.13676358"
LIBRARY = "libopenpgp_bridge.so"
LD_FLAGS = f"-w -s -buildid= -extldflags=-Wl,--build-id=none,-soname,{LIBRARY}"
TARGETS = {
    "armeabi-v7a": ("arm", "armv7a-linux-androideabi28-clang"),
    "arm64-v8a": ("arm64", "aarch64-linux-android28-clang"),
    "x86": ("386", "i686-linux-android28-clang"),
    "x86_64": ("amd64", "x86_64-linux-android28-clang"),
}


def build_environment(ndk, abi):
    arch, compiler = TARGETS[abi]
    env = dict(os.environ)
    env.update({
        "GOTOOLCHAIN": GO_VERSION, "GOENV": "off", "GOWORK": "off",
        "GOFLAGS": "", "GOEXPERIMENT": "", "GOOS": "android", "GOARCH": arch,
        "GOARM": "7", "GOAMD64": "v1", "GO386": "sse2", "CGO_ENABLED": "1",
        "CGO_CFLAGS": "", "CGO_CPPFLAGS": "", "CGO_CXXFLAGS": "", "CGO_LDFLAGS": "",
        "CC": str(ndk / "toolchains/llvm/prebuilt/linux-x86_64/bin" / compiler),
    })
    return env


def build_command(output):
    return [
        "go", "build", "-mod=readonly", "-trimpath", "-buildvcs=false",
        f"-ldflags={LD_FLAGS}",
        "-buildmode=c-shared", "-o", str(output), "binding/main.go",
    ]


def build(source, ndk, output, abis):
    properties = (ndk / "source.properties").read_text()
    revision = re.search(r"(?m)^Pkg.Revision\s*=\s*(\S+)", properties)
    if not revision or revision[1] != NDK_VERSION:
        raise ValueError(f"OpenPGP requires Android NDK {NDK_VERSION}")
    for abi in abis:
        env = build_environment(ndk, abi)
        if not Path(env["CC"]).is_file():
            raise ValueError(f"Android compiler not found: {env['CC']}")
        version = subprocess.check_output(["go", "env", "GOVERSION"], cwd=source, env=env, text=True).strip()
        if version != GO_VERSION:
            raise ValueError(f"expected {GO_VERSION}, got {version}")
        library = output / abi / LIBRARY
        library.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(build_command(library), cwd=source, env=env, check=True)
        print(f"{abi}: {hashlib.sha256(library.read_bytes()).hexdigest()}", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--ndk", type=Path, required=True)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--abi", choices=TARGETS, action="append")
    parser.add_argument("--verify-reproducible", action="store_true",
                        help="rebuild in another source directory and compare every library")
    args = parser.parse_args()
    source = args.source.resolve()
    output = args.output.resolve() if args.output else source / "output/binding/android/jniLibs"
    abis = args.abi or list(TARGETS)
    build(source, args.ndk.resolve(), output, abis)
    if args.verify_reproducible:
        with tempfile.TemporaryDirectory(prefix="veil-openpgp-") as directory:
            second_source = Path(directory) / "source"
            shutil.copytree(source, second_source, ignore=shutil.ignore_patterns(".git", "output"))
            second_output = Path(directory) / "libraries"
            build(second_source, args.ndk.resolve(), second_output, abis)
            for abi in abis:
                if (output / abi / LIBRARY).read_bytes() != (second_output / abi / LIBRARY).read_bytes():
                    raise ValueError(f"OpenPGP build is not reproducible for {abi}")
            print("OpenPGP reproducibility check passed for all requested ABIs", flush=True)


if __name__ == "__main__":
    main()
