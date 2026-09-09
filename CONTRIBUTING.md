# Contributing to Veil

Thanks for helping make Veil more private, usable, and reliable.

## Before you start

- Search existing [Issues](https://github.com/veil-notes/app/issues) before opening a duplicate.
- Use [Discussions](https://github.com/veil-notes/app/discussions) for questions, early ideas, and design conversations.
- Keep security vulnerabilities out of public issues. Follow [SECURITY.md](SECURITY.md).
- For large or behavior-changing work, open an issue or discussion before implementing it.

## Development setup

Veil currently targets Android and uses:

- Flutter 3.41.x
- Dart 3.11.x
- Java 17 for Android builds

Install dependencies and run the app:

    flutter pub get
    flutter run

Before submitting a pull request, run:

    flutter analyze
    flutter test

For Android release validation:

    flutter build apk --release --split-per-abi

## Project shape

Start with [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the current module layout, startup flow, vault lifecycle, encryption model, storage model, and test commands.

The main implementation areas are:

- lib/app/: application shell, routing, theme, lifecycle, and locale bootstrap.
- lib/core/: shared crypto and storage abstractions.
- lib/features/veil/: vault setup, unlock, biometrics, and session state.
- lib/features/notes/: notes, encrypted persistence, and the editor.
- test/: unit and widget tests.

## Code and pull requests

- Keep changes focused and explain the user or security problem being solved.
- Add or update tests for behavior changes.
- Preserve the existing architecture and dependency direction unless the pull request explains why a change is necessary.
- Do not commit credentials, keystores, private keys, local data, or generated build artifacts.
- Update user-facing documentation when behavior or limitations change.
- Keep generated localization output consistent with its source files.

Pull requests should include:

- a concise summary of the change;
- the relevant issue or discussion, when one exists;
- test commands and results;
- screenshots or a short recording for visible UI changes;
- security and data-loss considerations for changes involving the vault or note storage.

## Localization

Translation sources live under lib/i18n. Generated Dart files are committed, but should normally be regenerated from the source translation files rather than edited manually.

## License

By contributing to Veil, you agree that your contribution is provided under the [GNU General Public License v3.0](LICENSE).
