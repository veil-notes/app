# Veil

Technical README for the private source repository.

This document is intended for maintainers and contributors who need to understand the current architecture, security model, runtime flow, and operational commands of the project.

## Scope

Veil is currently an Android-first encrypted notes app with:

- local encrypted note storage
- OpenPGP-based note encryption
- master password setup and unlock
- optional biometric unlock
- markdown editing with checklist support
- auto-lock session timeout
- multi-language interface

Not implemented today:

- cloud sync
- in-app import/export flow
- password recovery

## Stack

- Flutter `3.41.x`
- Dart `3.11.x`
- Riverpod `3.x`
- GoRouter
- `openpgp`
- `argon2`
- `flutter_secure_storage`
- `local_auth`
- `path_provider`
- `slang` / `slang_flutter`

Primary configuration lives in:

- [`pubspec.yaml`](pubspec.yaml)
- [`analysis_options.yaml`](analysis_options.yaml)
- [`android/app/build.gradle.kts`](android/app/build.gradle.kts)

## Repository Layout

Main source layout:

```text
lib/
  app/
  core/
  features/
    notes/
    settings/
    veil/
  i18n/
  main.dart
test/
docs/
```

Responsibilities by top-level area:

- `lib/app/`: app shell, lifecycle, locale bootstrap, theme, router
- `lib/core/`: shared crypto and storage abstractions/adapters
- `lib/features/notes/`: note entities, repository, encrypted note service, editor UI
- `lib/features/settings/`: settings screen and preference flows
- `lib/features/veil/`: vault lifecycle, state machine, unlock/setup logic, biometrics
- `lib/i18n/`: source locale JSON files plus generated translation output
- `test/`: unit and widget tests
- `docs/`: product/release artifacts used outside the private source repo

## Startup Flow

Entry point:

- [`lib/main.dart`](lib/main.dart)

Current startup sequence:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. build secure storage adapter
3. resolve initial locale
4. initialize `slang` locale settings
5. start `ProviderScope` with boot-time overrides
6. render the root app widget

The root app shell is in:

- [`lib/app/app.dart`](lib/app/app.dart)

Key runtime responsibilities:

- watches app lifecycle
- locks the vault when the app is backgrounded
- does not force-lock while a biometric prompt is in progress
- refreshes the auto-lock timer on pointer interaction
- wires `MaterialApp.router`

## Routing

Router definition:

- [`lib/app/router.dart`](lib/app/router.dart)

Current routes:

```text
/
/setup
/unlock
/list
/settings
/note
/note/:id
```

Routing is state-driven via `veilControllerProvider`.

Redirect behavior:

- `BootstrappingState` -> `/`
- `UninitializedState` -> `/setup`
- `LockedState` -> `/unlock`
- `UnlockedState` -> private routes

## Feature Modules

### Veil

Main responsibility:

- vault lifecycle
- password-based setup
- unlock state machine
- biometric enable/disable
- session timeout management

Important files:

- [`lib/features/veil/providers/veil_provider.dart`](lib/features/veil/providers/veil_provider.dart)
- [`lib/features/veil/application/veil_controller.dart`](lib/features/veil/application/veil_controller.dart)
- [`lib/features/veil/infra/veil_state_service.dart`](lib/features/veil/infra/veil_state_service.dart)
- [`lib/features/veil/application/veil_session_controller.dart`](lib/features/veil/application/veil_session_controller.dart)
- [`lib/features/veil/domain/states`](lib/features/veil/domain/states)

### Notes

Main responsibility:

- encrypted note CRUD
- markdown editor model
- note list and note editor UI

Important files:

- [`lib/features/notes/providers/notes_provider.dart`](lib/features/notes/providers/notes_provider.dart)
- [`lib/features/notes/infra/pgp_notes_service.dart`](lib/features/notes/infra/pgp_notes_service.dart)
- [`lib/features/notes/infra/file_notes_repository.dart`](lib/features/notes/infra/file_notes_repository.dart)
- [`lib/features/notes/presentation/screens/note_list_screen.dart`](lib/features/notes/presentation/screens/note_list_screen.dart)
- [`lib/features/notes/presentation/editor/note_screen.dart`](lib/features/notes/presentation/editor/note_screen.dart)
- [`lib/features/notes/presentation/editor/markdown_block_editor.dart`](lib/features/notes/presentation/editor/markdown_block_editor.dart)

### Settings

Main responsibility:

- language selection
- biometric toggle
- auto-lock selection
- manual lock action

Important file:

- [`lib/features/settings/presentation/screens/settings_screen.dart`](lib/features/settings/presentation/screens/settings_screen.dart)

## Dependency Wiring

Core provider composition happens in:

- [`lib/features/veil/providers/veil_provider.dart`](lib/features/veil/providers/veil_provider.dart)
- [`lib/features/notes/providers/notes_provider.dart`](lib/features/notes/providers/notes_provider.dart)

Current dependency direction:

```text
UI
  -> Riverpod providers
    -> application services/controllers
      -> infra adapters
        -> core abstractions
```

Examples:

- `veilServiceProvider` builds `VeilStateService`
- `cryptoServiceProvider` builds `PgpCryptoService`
- `notesServiceProvider` builds `PgpNotesService`
- `notesRepositoryProvider` builds `FileNotesRepository`
- `localFileStorageServiceProvider` builds `IOLocalFileStorageService`

## Security Model

Core vault implementation:

- [`lib/features/veil/infra/veil_state_service.dart`](lib/features/veil/infra/veil_state_service.dart)

### Setup Flow

Current setup flow:

1. validate master password
2. generate Argon2 KDF params and random salt
3. derive key material from the password
4. convert derived bytes into a passphrase
5. generate an OpenPGP public/private key pair
6. encrypt the private key symmetrically with the derived passphrase
7. persist:
   - KDF params
   - public key
   - encrypted private key
8. keep the decrypted private key in memory for the active session

### Password Unlock Flow

1. read KDF params
2. read encrypted private key
3. derive key material from the password
4. rebuild passphrase
5. decrypt private key
6. cache the private key in memory

### Biometric Enable Flow

1. confirm vault configuration exists
2. confirm encrypted private key exists
3. verify biometric availability
4. authenticate with the OS
5. verify the provided password by decrypting the stored private key
6. persist the derived passphrase for biometric unlock

### Biometric Unlock Flow

1. verify biometrics are available and enabled
2. authenticate with the OS
3. read encrypted private key and stored biometric passphrase
4. decrypt private key
5. cache it in memory

### In-Memory Secret Handling

The unlocked private key is stored only in memory during an active session inside `VeilStateService`.

It is cleared when:

- `lock()` is called
- unlock or decrypt fails
- the app transitions back to a locked state

## Note Encryption and Storage

Note encryption service:

- [`lib/features/notes/infra/pgp_notes_service.dart`](lib/features/notes/infra/pgp_notes_service.dart)

Current write flow:

1. serialize `Note` to JSON
2. read the public key from the vault service
3. encrypt the JSON payload using OpenPGP public-key encryption
4. save the encrypted payload as a `.pgp` file

Current read flow:

1. load encrypted `.pgp` file
2. read unlocked private key from the vault service
3. decrypt payload
4. decode JSON
5. rebuild the `Note` entity

File storage:

- adapter: [`lib/core/storage/infra/io_local_file_storage_service.dart`](lib/core/storage/infra/io_local_file_storage_service.dart)
- repository: [`lib/features/notes/infra/file_notes_repository.dart`](lib/features/notes/infra/file_notes_repository.dart)

Current note storage shape:

- directory: `notes`
- extension: `.pgp`
- file name: `<uuid>.pgp`

On Android, notes are written inside the app-private documents directory, not shared storage. They are normally not visible in the default file manager.

## Secure Storage Keys

Current sensitive keys written through secure storage:

- `veil.kdf_params`
- `veil.public_key`
- `veil.private_key_encrypted`
- `veil.biometric_enabled`
- `veil.biometric_passphrase`
- `veil.auto_lock_option`
- `app.locale`

## Markdown Editor

Editor code is split between:

- [`lib/features/notes/domain/editor`](lib/features/notes/domain/editor)
- [`lib/features/notes/presentation/editor`](lib/features/notes/presentation/editor)

Current editor model includes:

- block-level markdown representation
- parser and serializer
- inline markdown rendering
- checklist behavior
- block split and delete behavior
- toolbar actions

The editor is implemented as a structured block editor, not a single raw markdown textarea.

## Localization

Locale bootstrap:

- [`lib/app/locale/app_locale_service.dart`](lib/app/locale/app_locale_service.dart)
- [`lib/app/locale/app_locale_provider.dart`](lib/app/locale/app_locale_provider.dart)

Translation sources and generated output:

- [`lib/i18n`](lib/i18n)

Current locales exposed in settings:

- `pt-BR`
- `en`
- `es`
- `de`
- `ru`
- `ko`
- `zh`
- `fr`
- `ja`

Generated translation files are committed under `lib/i18n/translations*.g.dart`.

Useful i18n commands:

```bash
dart run slang
dart run slang analyze --full
dart run slang apply
```

Do not edit generated translation files manually unless you have a specific reason to do so.

## Testing

The test suite includes both unit tests and widget tests.

Useful commands:

```bash
flutter analyze
flutter test
flutter test --coverage
```

The repository also contains a committed `coverage/lcov.info` artifact at times, but coverage must always be regenerated from the current branch before making release decisions.

## Development Commands

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Regenerate launcher icons after updating the source icon:

```bash
dart run flutter_launcher_icons
```

## Android Release

Version is defined in:

- [`pubspec.yaml`](pubspec.yaml)

Android signing is configured in:

- [`android/app/build.gradle.kts`](android/app/build.gradle.kts)

Recommended release build:

```bash
flutter build apk --release --split-per-abi
```

Typical output files:

- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

For real Android phones, `arm64-v8a` is the primary target.

## Docs

The `docs/` folder contains artifacts prepared for the public release repository, including:

- public-facing README draft
- release template
- release notes and SHA256 artifacts

These documents are product/distribution artifacts, not the primary technical documentation for the app itself.

## Current Technical Constraints

- Android is the only real target for now
- note files are private to the app sandbox
- there is no sync subsystem
- there is no import/export workflow yet
- cryptography has not been externally audited

## Recommended Onboarding Order

For a quick technical onboarding, read these in order:

1. [`lib/main.dart`](lib/main.dart)
2. [`lib/app/app.dart`](lib/app/app.dart)
3. [`lib/app/router.dart`](lib/app/router.dart)
4. [`lib/features/veil/providers/veil_provider.dart`](lib/features/veil/providers/veil_provider.dart)
5. [`lib/features/veil/infra/veil_state_service.dart`](lib/features/veil/infra/veil_state_service.dart)
6. [`lib/features/notes/providers/notes_provider.dart`](lib/features/notes/providers/notes_provider.dart)
7. [`lib/features/notes/infra/pgp_notes_service.dart`](lib/features/notes/infra/pgp_notes_service.dart)
8. [`lib/features/notes/presentation/editor/note_screen.dart`](lib/features/notes/presentation/editor/note_screen.dart)
