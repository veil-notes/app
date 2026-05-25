enum AppShortcutAction { newNote }

extension AppShortcutActionParsing on AppShortcutAction {
  static AppShortcutAction? fromRaw(String? raw) {
    switch (raw) {
      case 'new_note':
        return AppShortcutAction.newNote;
      default:
        return null;
    }
  }

  String toRaw() {
    switch (this) {
      case AppShortcutAction.newNote:
        return 'new_note';
    }
  }
}