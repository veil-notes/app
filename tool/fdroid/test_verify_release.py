import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from verify_release import (
    ABI_OFFSETS, SIGNING_CERTIFICATE, check_badging, check_certificate, check_history, release_version,
)


class ReleaseChecksTest(unittest.TestCase):
    def test_history_keeps_three_abi_recipes_together(self):
        for base, valid in ((4010, False), (7009, False), (7010, True)):
            with patch("verify_release.subprocess.check_output", side_effect=[
                "v1.0.0-beta.6\nv1.0.0-beta.7\nv1.0.0-rc.1\n",
                "version: 1.0.0-beta.6+4009\n",
            ]):
                if valid:
                    check_history(base, "v1.0.0-beta.7")
                else:
                    with self.assertRaises(ValueError):
                        check_history(base, "v1.0.0-beta.7")

    def test_beta6_is_smallest_compatible_base(self):
        previous = {"armeabi-v7a": 2008, "arm64-v8a": 4008, "x86_64": 8008}
        minimum = max(code - ABI_OFFSETS[abi] + 1 for abi, code in previous.items())
        self.assertEqual(minimum, 4009)
        self.assertEqual([minimum + offset for offset in ABI_OFFSETS.values()], [5009, 6009, 8009])

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
        for (abi, offset), code in zip(ABI_OFFSETS.items(), (1008, 2008, 4008)):
            badging = (f"package: name='app.veil.veil' versionCode='{code}' "
                       f"versionName='1.0.0-beta.5'\nnative-code: '{abi}'\n")
            check_badging(badging, "1.0.0-beta.5", 8 + offset, abi)
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
