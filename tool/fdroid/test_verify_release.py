import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from verify_release import (
    ABI_CODES, SIGNING_CERTIFICATE, check_badging, check_certificate, check_history,
    check_native_build_info, release_version,
)
from build_openpgp import GO_VERSION


class ReleaseChecksTest(unittest.TestCase):
    def test_native_library_must_have_pinned_go_and_reproducible_flags(self):
        info = f'library.so: {GO_VERSION}\n\tbuild\t-trimpath=true\n\tbuild\tGOOS=android\n\tbuild\t-buildmode=c-shared\n'
        check_native_build_info(info)
        for wrong in (info.replace(GO_VERSION, "go1.26.0"),
                      info.replace("-trimpath=true", "-trimpath=false"),
                      info.replace("GOOS=android", "GOOS=linux")):
            with self.assertRaises(ValueError):
                check_native_build_info(wrong)

    def test_history_keeps_three_abi_recipes_together(self):
        for base, valid in ((7009, False), (7010, False), (7011, True)):
            with patch("verify_release.subprocess.check_output", side_effect=[
                "v1.0.0-beta.7\nv1.0.0-beta.8\nv1.0.0-rc.1\n",
                "version: 1.0.0-beta.7+7010\n",
            ]):
                if valid:
                    check_history(base, "v1.0.0-beta.8")
                else:
                    with self.assertRaises(ValueError):
                        check_history(base, "v1.0.0-beta.8")

    def test_migration_exceeds_all_published_beta7_codes(self):
        previous = {"armeabi-v7a": 2008, "arm64-v8a": 4008, "x86_64": 8008}
        minimum = 7011
        self.assertGreater(minimum * 10 + 1, 11010)
        self.assertEqual([minimum * 10 + offset for offset in ABI_CODES.values()], [70111, 70112, 70113])

    def test_release_tags(self):
        with tempfile.TemporaryDirectory() as directory:
            pubspec = Path(directory) / "pubspec.yaml"
            for version in ("1.0.0", "1.0.0-beta.6"):
                pubspec.write_text(f"name: veil\nversion: {version}+4009\n")
                self.assertEqual(release_version(pubspec, f"v{version}"), (version, 4009))
                with self.assertRaises(ValueError):
                    release_version(pubspec, "v2.0.0")
            for version in ("1.0.0-alpha.1", "1.0.0-rc.1", "1.0.0-beta", "1.0"):
                pubspec.write_text(f"version: {version}+9\n")
                with self.assertRaises(ValueError):
                    release_version(pubspec, f"v{version}")
            for base in ("0", "-1", "2100000000"):
                pubspec.write_text(f"version: 1.0.0+{base}\n")
                with self.assertRaises(ValueError):
                    release_version(pubspec, "v1.0.0")

    def test_beta5_offset_regression(self):
        for (abi, offset), code in zip(ABI_CODES.items(), (81, 82, 83)):
            badging = (f"package: name='app.veil.veil' versionCode='{code}' "
                       f"versionName='1.0.0-beta.5'\nnative-code: '{abi}'\n")
            check_badging(badging, "1.0.0-beta.5", 8 * 10 + offset, abi)
            with self.assertRaises(ValueError):
                check_badging(badging.replace(f"'{code}'", f"'{code + offset}'"),
                              "1.0.0-beta.5", code, abi)

    def test_wrong_package_version_and_abi(self):
        badging = ("package: name='app.veil.veil' versionCode='1008' "
                   "versionName='1.0.0-beta.5'\nnative-code: 'armeabi-v7a'\n")
        for old, new in (("app.veil.veil", "other.app"), ("beta.5", "beta.4"),
                         ("armeabi-v7a", "arm64-v8a"),
                         ("'armeabi-v7a'", "'armeabi-v7a' 'arm64-v8a'"),
                         ("native-code:", "missing:")):
            with self.subTest(new=new), self.assertRaises(ValueError):
                check_badging(badging.replace(old, new), "1.0.0-beta.5", 1008, "armeabi-v7a")

    def test_certificate(self):
        certificate = f"Signer #1 certificate SHA-256 digest: {SIGNING_CERTIFICATE}\n"
        check_certificate(certificate)
        for wrong in ("", certificate.replace(SIGNING_CERTIFICATE, "0" * 64),
                      certificate + certificate.replace("#1", "#2")):
            with self.assertRaises(ValueError):
                check_certificate(wrong)


if __name__ == "__main__":
    unittest.main()
