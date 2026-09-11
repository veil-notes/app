# F-Droid releases

Flutter's `--split-per-abi` adds 1000 (armeabi-v7a), 2000 (arm64-v8a),
or 4000 (x86_64) to the **base** build number from `pubspec.yaml`.
Never pass the final APK version code as `--build-number`.
The F-Droid recipe receives a final `$$VERCODE$$`, so each build subtracts
its ABI offset before invoking Flutter. Keep `VercodeOperation` unchanged.

## beta.6 migration

The six published beta.5 APKs were inspected with Android build-tools 35.0.0
`aapt dump badging`. The ordinary and F-Droid APKs have identical hashes per ABI:

| ABI | beta.5 actual code | SHA-256 (both filenames) | beta.6 code |
| --- | ---: | --- | ---: |
| armeabi-v7a | 2008 | 5205d995fa21aa86e8841a65e8bf9df28b7825dfd7f780133b4269b622b4366f | 5009 |
| arm64-v8a | 4008 | 15621738bf9b32a7ca2d4d847723315909b40c17dd60147bb2cb34db10e6bd96 | 6009 |
| x86_64 | 8008 | a45e4fdc7294537a07653255f70c17a103ccc0cc22658aebba146e0375e4867a | 8009 |

Source: https://github.com/veil-notes/app/releases/tag/v1.0.0-beta.5

`1.0.0-beta.6+4009` uses the smallest base greater than 8 satisfying
`base + offset > previous APK code` for all three ABIs. Continue incrementing
from 4009 in future releases; do not reset to 9. Keep the application ID and
signing key so existing installations can update without clearing app data.

F-Droid sorts recipes by code and clones the last three when updating. With
these ABI offsets, every future base must increase by **at least 3001** so
the next ARMv7 code exceeds the previous x86_64 code. Use at least 7010 for
the release after beta.6, then 10011. The workflow checks all preceding stable
and beta tags reachable from the release commit and rejects overlapping ranges.
This preserves the existing offsets without mixing ABI recipes after updates.

## Release validation

The Android workflow accepts stable versions and numbered betas, requires the
tag to match `pubspec.yaml`, preserves ordinary artifacts before rebuilding,
and validates all six signed APKs before hashing or publishing them:

```sh
python3 -m unittest discover -s tool/fdroid -p 'test_*.py'
python3 tool/fdroid/verify_release.py --tag v1.0.0-beta.6 \
  --assets release-assets --build-tools "$ANDROID_HOME/build-tools/35.0.0"
```

The standalone recipe remains in the ignored `.fdroid-staging/metadata/`
directory. Copy it to `metadata/app.veil.veil.yml` in a separate fdroiddata
checkout. It tracks stable and `-beta.N` tags and uses `v%v` binary URLs, so
future builds do not download beta.5 artifacts. Do not commit this staging
directory into the app source distribution.

To lint and simulate the next beta's three generated recipes without changing
fdroiddata, run on Linux with `fdroidserver` and PyYAML installed:

```sh
python3 tool/fdroid/check_metadata.py .fdroid-staging/metadata/app.veil.veil.yml \
  --categories /path/to/fdroiddata/config/categories.yml
```

This uses the real F-Droid parser, lint and update generator in a temporary
checkout; only remote tag discovery is simulated. The official category config
is required because a bare checkout has no category definitions.

After the beta.6 source is committed, tagged and its signed assets are available,
run these commands in the Linux fdroiddata checkout:

```sh
fdroid readmeta
fdroid lint app.veil.veil
fdroid build -v -l app.veil.veil:5009
fdroid build -v -l app.veil.veil:6009
fdroid build -v -l app.veil.veil:8009
```

Keep `AllowedAPKSigningKeys` and binary reproducibility verification enabled.
Passing the APK version check alone does not prove reproducibility or F-Droid
acceptance. Test installation over beta.5 on each supported ABI using a
disposable installation with sample notes; verify the notes remain readable.
Do not uninstall or clear data as part of the upgrade test.

## Validation performed for this change

- Inspected all six downloaded beta.5 APKs: codes, ABIs, SHA-256 hashes and
  signing certificates match the migration evidence above.
- Six Python regression tests passed, including doubled offsets, release tag
  filtering, certificate mismatch and overlapping release ranges.
- Workflow YAML parsing and Bash syntax passed. Executing the two APK build
  steps with a simulated compiler preserved ordinary and F-Droid assets.
- Ubuntu's fdroidserver passed `readmeta` and `lint` using official fdroiddata
  category definitions. Two consecutive simulated updates (beta.7 and beta.8)
  preserved all three ABIs, binary URLs and base-number calculations.
- Full beta.6 builds, signed-binary reproducibility and device upgrade tests
  remain pending: the beta.6 tag/assets do not exist yet, and no Android device
  was connected. No release or F-Droid submission was published by this change.
