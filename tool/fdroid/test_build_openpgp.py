import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from build_openpgp import GO_VERSION, NDK_VERSION, build, build_command, build_environment


class OpenPGPBuildTest(unittest.TestCase):
    def test_host_configuration_does_not_change_toolchain_or_flags(self):
        with patch.dict("os.environ", {"GOTOOLCHAIN": "auto", "GOFLAGS": "-race",
                                       "CGO_CFLAGS": "-march=native", "GOARM": "6"}):
            env = build_environment(Path("/ndk"), "armeabi-v7a")
        self.assertEqual(env["GOTOOLCHAIN"], GO_VERSION)
        self.assertEqual(env["GOFLAGS"], "")
        self.assertEqual(env["CGO_CFLAGS"], "")
        self.assertEqual(env["GOARM"], "7")
        self.assertEqual(env["GOARCH"], "arm")
        self.assertTrue(env["CC"].endswith("armv7a-linux-androideabi28-clang"))

    def test_flags_are_passed_directly_without_makefile_substitution(self):
        command = build_command(Path("/output/libopenpgp_bridge.so"))
        self.assertIn("-trimpath", command)
        self.assertIn("-buildvcs=false", command)
        self.assertIn("-mod=readonly", command)
        flags = next(arg for arg in command if arg.startswith("-ldflags="))
        self.assertIn("-buildid= ", flags)
        self.assertIn("--build-id=none", flags)

    def test_wrong_ndk_fails_before_compilation(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "source.properties").write_text("Pkg.Revision = 28.0.0\n")
            with patch("build_openpgp.subprocess.run") as run:
                with self.assertRaisesRegex(ValueError, NDK_VERSION):
                    build(root, root, root / "output", ["armeabi-v7a"])
                run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
