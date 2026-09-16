///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsDe extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppDe app = _TranslationsAppDe._(_root);
	@override late final _TranslationsCommonDe common = _TranslationsCommonDe._(_root);
	@override late final _TranslationsNotesDe notes = _TranslationsNotesDe._(_root);
	@override late final _TranslationsSettingsDe settings = _TranslationsSettingsDe._(_root);
	@override late final _TranslationsVeilDe veil = _TranslationsVeilDe._(_root);
}

// Path: app
class _TranslationsAppDe extends TranslationsAppEn {
	_TranslationsAppDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonDe extends TranslationsCommonEn {
	_TranslationsCommonDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Wird geladen...';
	@override late final _TranslationsCommonActionsDe actions = _TranslationsCommonActionsDe._(_root);
	@override late final _TranslationsCommonLanguageNamesDe languageNames = _TranslationsCommonLanguageNamesDe._(_root);
	@override late final _TranslationsCommonErrorsDe errors = _TranslationsCommonErrorsDe._(_root);
}

// Path: notes
class _TranslationsNotesDe extends TranslationsNotesEn {
	_TranslationsNotesDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get empty => 'noch keine notizen.';
	@override late final _TranslationsNotesDeleteDe delete = _TranslationsNotesDeleteDe._(_root);
	@override late final _TranslationsNotesEditorDe editor = _TranslationsNotesEditorDe._(_root);
}

// Path: settings
class _TranslationsSettingsDe extends TranslationsSettingsEn {
	_TranslationsSettingsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsDe biometrics = _TranslationsSettingsBiometricsDe._(_root);
	@override late final _TranslationsSettingsAutoLockDe autoLock = _TranslationsSettingsAutoLockDe._(_root);
	@override late final _TranslationsSettingsLanguageDe language = _TranslationsSettingsLanguageDe._(_root);
	@override late final _TranslationsSettingsLockDe lock = _TranslationsSettingsLockDe._(_root);
	@override late final _TranslationsSettingsConfirmPasswordDe confirmPassword = _TranslationsSettingsConfirmPasswordDe._(_root);
	@override late final _TranslationsSettingsChangePasswordDe changePassword = _TranslationsSettingsChangePasswordDe._(_root);
	@override late final _TranslationsSettingsNotesTransferDe notesTransfer = _TranslationsSettingsNotesTransferDe._(_root);
	@override late final _TranslationsSettingsAboutDe about = _TranslationsSettingsAboutDe._(_root);
}

// Path: veil
class _TranslationsVeilDe extends TranslationsVeilEn {
	_TranslationsVeilDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupDe setup = _TranslationsVeilSetupDe._(_root);
	@override late final _TranslationsVeilUnlockDe unlock = _TranslationsVeilUnlockDe._(_root);
	@override late final _TranslationsVeilSplashDe splash = _TranslationsVeilSplashDe._(_root);
	@override late final _TranslationsVeilErrorsDe errors = _TranslationsVeilErrorsDe._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsDe extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get confirm => 'Bestätigen';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesDe extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'Portugiesisch (Brasilien)';
	@override String get en => 'Englisch';
	@override String get es => 'Spanisch';
	@override String get de => 'Deutsch';
	@override String get ru => 'Russisch';
	@override String get ko => 'Koreanisch';
	@override String get zh => 'Chinesisch (vereinfacht)';
	@override String get fr => 'Französisch';
	@override String get ja => 'Japanisch';
}

// Path: common.errors
class _TranslationsCommonErrorsDe extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'Ein unerwarteter Fehler ist aufgetreten.';
	@override String get loadFailed => 'Die Informationen konnten nicht geladen werden.';
}

// Path: notes.delete
class _TranslationsNotesDeleteDe extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Diese Notiz dauerhaft löschen?';
	@override String get confirm => 'Ja, löschen';
	@override String get cancel => 'Nein, behalten';
}

// Path: notes.editor
class _TranslationsNotesEditorDe extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => 'Überschrift ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsDe extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Biometrie';
	@override String get subtitleAvailable => 'Nutze Biometrie, um die App schneller zu entsperren.';
	@override String get subtitleEnabledUnavailable => 'Biometrie ist aktiviert, aber auf diesem Gerät nicht verfügbar.';
	@override String get subtitleDisabledUnavailable => 'Aktiviere Biometrie für schnelleres Entsperren.';
	@override String get checkingAvailability => 'Biometrieverfügbarkeit wird geprüft...';
	@override String get loading => 'Biometrie-Einstellungen werden geladen...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockDe extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Automatische Sperre';
	@override String subtitle({required Object duration}) => 'Sperrt die App nach ${duration}.';
	@override late final _TranslationsSettingsAutoLockOptionsDe options = _TranslationsSettingsAutoLockOptionsDe._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageDe extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sprache';
	@override String subtitle({required Object language}) => 'Aktuelle Sprache: ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockDe extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sperren';
	@override String get subtitle => 'Löscht die aktuelle Sitzung. Du musst erneut entsperren.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordDe extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Passwort bestätigen';
	@override String get hint => 'Gib dein Passwort ein...';
}

// Path: settings.changePassword
class _TranslationsSettingsChangePasswordDe extends TranslationsSettingsChangePasswordEn {
	_TranslationsSettingsChangePasswordDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Passwort ändern';
	@override String get subtitle => 'Ändere das Passwort zum Schutz deines Tresors.';
	@override String get sheetTitle => 'Tresor-Passwort ändern';
	@override String get currentPasswordHint => 'Aktuelles Passwort...';
	@override String get newPasswordHint => 'Neues Passwort...';
	@override String get confirmPasswordHint => 'Neues Passwort bestätigen...';
	@override String get success => 'Passwort erfolgreich geändert.';
}

// Path: settings.notesTransfer
class _TranslationsSettingsNotesTransferDe extends TranslationsSettingsNotesTransferEn {
	_TranslationsSettingsNotesTransferDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get exportTitle => 'Notizen exportieren';
	@override String get exportSubtitle => 'Eine verschlüsselte Kopie mit einem separaten Passwort speichern.';
	@override String get importTitle => 'Notizen importieren';
	@override String get importSubtitle => 'Notizen aus einer verschlüsselten PGP-Datei wiederherstellen.';
	@override late final _TranslationsSettingsNotesTransferFilePickerDe filePicker = _TranslationsSettingsNotesTransferFilePickerDe._(_root);
	@override late final _TranslationsSettingsNotesTransferExportPasswordDe exportPassword = _TranslationsSettingsNotesTransferExportPasswordDe._(_root);
	@override late final _TranslationsSettingsNotesTransferImportPasswordDe importPassword = _TranslationsSettingsNotesTransferImportPasswordDe._(_root);
	@override String importSuccess({required Object count}) => '${count} Notizen importiert.';
	@override String exportSuccess({required Object count}) => '${count} Notizen exportiert.';
	@override late final _TranslationsSettingsNotesTransferErrorsDe errors = _TranslationsSettingsNotesTransferErrorsDe._(_root);
}

// Path: settings.about
class _TranslationsSettingsAboutDe extends TranslationsSettingsAboutEn {
	_TranslationsSettingsAboutDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Über Veil';
	@override String get subtitle => 'App-Informationen und Open-Source-Lizenzen.';
	@override String version({required Object version}) => 'Version ${version}';
	@override String get versionLoading => 'Version wird geladen...';
	@override String get versionUnavailable => 'Version nicht verfügbar';
	@override String get repositoryTitle => 'Quellcode';
	@override String get repositorySubtitle => 'Den Veil-Quellcode auf GitHub ansehen.';
	@override String get repositoryError => 'Das Repository konnte nicht geöffnet werden.';
	@override String get licensesTitle => 'Open-Source-Lizenzen';
	@override String get licensesSubtitle => 'Lizenzen für Veil und seine Abhängigkeiten anzeigen.';
	@override String get licensesHeading => 'Open-Source-Lizenzen';
	@override String get licensesIntro => 'Veil ist unter der GNU General Public License v3.0 lizenziert.\n\nDiese App enthält Open-Source-Software und -Ressourcen von Drittanbietern. Die zugehörigen Lizenzen und Hinweise sind unten aufgeführt.';
	@override String get fullLicenseText => 'Vollständiger Lizenztext';
	@override String get licensesLoading => 'Lizenzen werden geladen...';
	@override String get licensesError => 'Die Lizenzen konnten nicht geladen werden.';
}

// Path: veil.setup
class _TranslationsVeilSetupDe extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Gib ein Passwort ein, um zu starten...';
	@override String get cta => 'Los geht\'s!';
	@override String get biometricsOptInTitle => 'Biometrie aktivieren';
	@override String get confirmPasswordHint => 'Bestätige dein Passwort...';
	@override String get passwordRulesCta => 'Passwortregeln';
	@override String get passwordRulesTitle => 'Dein Passwort muss enthalten:';
	@override String get passwordRuleMinLength => 'Mindestens 10 Zeichen';
	@override String get passwordRuleUppercase => 'Mindestens 1 Großbuchstabe';
	@override String get passwordRuleLowercase => 'Mindestens 1 Kleinbuchstabe';
	@override String get passwordRuleNumber => 'Mindestens 1 Zahl';
	@override String get passwordRuleSpecialChar => 'Mindestens 1 Sonderzeichen';
	@override String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein.';
}

// Path: veil.unlock
class _TranslationsVeilUnlockDe extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Gib dein Passwort ein...';
	@override String get cta => 'Entsperren';
	@override String get biometricTooltip => 'Biometrie';
}

// Path: veil.splash
class _TranslationsVeilSplashDe extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Wird geladen...';
}

// Path: veil.errors
class _TranslationsVeilErrorsDe extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'Passwort ist erforderlich.';
	@override String get passwordMissingLetter => 'Das Passwort muss mindestens einen Buchstaben enthalten.';
	@override String get passwordMissingNumber => 'Das Passwort muss mindestens eine Zahl enthalten.';
	@override String get invalidPassword => 'Ungültiges Passwort.';
	@override String get biometricUnavailable => 'Biometrische Authentifizierung ist nicht verfügbar.';
	@override String get biometricFailed => 'Biometrische Authentifizierung ist fehlgeschlagen.';
	@override String get biometricLockedOut => 'Biometrische Authentifizierung ist vorübergehend gesperrt.';
	@override String get vaultNotConfigured => 'Tresor ist nicht konfiguriert.';
	@override String get encryptedPrivateKeyNotFound => 'Verschlüsselter privater Schlüssel wurde nicht gefunden.';
	@override String get publicKeyNotFound => 'Öffentlicher Schlüssel wurde nicht gefunden.';
	@override String get vaultLocked => 'Tresor ist gesperrt.';
	@override String get passwordMinLength => 'Das Passwort muss mindestens 10 Zeichen lang sein.';
	@override String get passwordMissingUppercase => 'Das Passwort muss mindestens einen Großbuchstaben enthalten.';
	@override String get passwordMissingLowercase => 'Das Passwort muss mindestens einen Kleinbuchstaben enthalten.';
	@override String get passwordMissingSpecialChar => 'Das Passwort muss mindestens ein Sonderzeichen enthalten.';
	@override String get passwordChangeFailed => 'Das Passwort konnte nicht geändert werden. Dein Tresor ist unverändert.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsDe extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 Minute';
	@override String get fiveMinutes => '5 Minuten';
	@override String get fifteenMinutes => '15 Minuten';
	@override String get thirtyMinutes => '30 Minuten';
}

// Path: settings.notesTransfer.filePicker
class _TranslationsSettingsNotesTransferFilePickerDe extends TranslationsSettingsNotesTransferFilePickerEn {
	_TranslationsSettingsNotesTransferFilePickerDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get selectTitle => 'Importdatei auswählen';
	@override String get selectSubtitle => 'Wählen Sie eine verschlüsselte PGP-Datei zum Importieren.';
	@override String get changeSubtitle => 'Tippen Sie, um eine andere Datei auszuwählen.';
}

// Path: settings.notesTransfer.exportPassword
class _TranslationsSettingsNotesTransferExportPasswordDe extends TranslationsSettingsNotesTransferExportPasswordEn {
	_TranslationsSettingsNotesTransferExportPasswordDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notizen exportieren';
	@override String get passwordHint => 'Export-Passwort...';
	@override String get confirmPasswordHint => 'Export-Passwort bestätigen...';
}

// Path: settings.notesTransfer.importPassword
class _TranslationsSettingsNotesTransferImportPasswordDe extends TranslationsSettingsNotesTransferImportPasswordEn {
	_TranslationsSettingsNotesTransferImportPasswordDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notizen importieren';
	@override String get hint => 'Datei-Passwort eingeben...';
}

// Path: settings.notesTransfer.errors
class _TranslationsSettingsNotesTransferErrorsDe extends TranslationsSettingsNotesTransferErrorsEn {
	_TranslationsSettingsNotesTransferErrorsDe._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get invalidFileOrPassword => 'Die Datei ist ungültig oder das Passwort ist falsch.';
	@override String get unsupportedFormatVersion => 'Diese Exportformat-Version wird nicht unterstützt.';
	@override String get invalidPayload => 'Die Exportdatei enthält ungültige Notizen.';
	@override String get fileOperationFailed => 'Auf die Datei konnte nicht zugegriffen werden.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Wird geladen...',
			'common.actions.cancel' => 'Abbrechen',
			'common.actions.confirm' => 'Bestätigen',
			'common.languageNames.ptBr' => 'Portugiesisch (Brasilien)',
			'common.languageNames.en' => 'Englisch',
			'common.languageNames.es' => 'Spanisch',
			'common.languageNames.de' => 'Deutsch',
			'common.languageNames.ru' => 'Russisch',
			'common.languageNames.ko' => 'Koreanisch',
			'common.languageNames.zh' => 'Chinesisch (vereinfacht)',
			'common.languageNames.fr' => 'Französisch',
			'common.languageNames.ja' => 'Japanisch',
			'common.errors.unexpected' => 'Ein unerwarteter Fehler ist aufgetreten.',
			'common.errors.loadFailed' => 'Die Informationen konnten nicht geladen werden.',
			'notes.empty' => 'noch keine notizen.',
			'notes.delete.title' => 'Diese Notiz dauerhaft löschen?',
			'notes.delete.confirm' => 'Ja, löschen',
			'notes.delete.cancel' => 'Nein, behalten',
			'notes.editor.heading' => ({required Object level}) => 'Überschrift ${level}',
			'settings.biometrics.title' => 'Biometrie',
			'settings.biometrics.subtitleAvailable' => 'Nutze Biometrie, um die App schneller zu entsperren.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'Biometrie ist aktiviert, aber auf diesem Gerät nicht verfügbar.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Aktiviere Biometrie für schnelleres Entsperren.',
			'settings.biometrics.checkingAvailability' => 'Biometrieverfügbarkeit wird geprüft...',
			'settings.biometrics.loading' => 'Biometrie-Einstellungen werden geladen...',
			'settings.autoLock.title' => 'Automatische Sperre',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Sperrt die App nach ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 Minute',
			'settings.autoLock.options.fiveMinutes' => '5 Minuten',
			'settings.autoLock.options.fifteenMinutes' => '15 Minuten',
			'settings.autoLock.options.thirtyMinutes' => '30 Minuten',
			'settings.language.title' => 'Sprache',
			'settings.language.subtitle' => ({required Object language}) => 'Aktuelle Sprache: ${language}.',
			'settings.lock.title' => 'Sperren',
			'settings.lock.subtitle' => 'Löscht die aktuelle Sitzung. Du musst erneut entsperren.',
			'settings.confirmPassword.title' => 'Passwort bestätigen',
			'settings.confirmPassword.hint' => 'Gib dein Passwort ein...',
			'settings.changePassword.title' => 'Passwort ändern',
			'settings.changePassword.subtitle' => 'Ändere das Passwort zum Schutz deines Tresors.',
			'settings.changePassword.sheetTitle' => 'Tresor-Passwort ändern',
			'settings.changePassword.currentPasswordHint' => 'Aktuelles Passwort...',
			'settings.changePassword.newPasswordHint' => 'Neues Passwort...',
			'settings.changePassword.confirmPasswordHint' => 'Neues Passwort bestätigen...',
			'settings.changePassword.success' => 'Passwort erfolgreich geändert.',
			'settings.notesTransfer.exportTitle' => 'Notizen exportieren',
			'settings.notesTransfer.exportSubtitle' => 'Eine verschlüsselte Kopie mit einem separaten Passwort speichern.',
			'settings.notesTransfer.importTitle' => 'Notizen importieren',
			'settings.notesTransfer.importSubtitle' => 'Notizen aus einer verschlüsselten PGP-Datei wiederherstellen.',
			'settings.notesTransfer.filePicker.selectTitle' => 'Importdatei auswählen',
			'settings.notesTransfer.filePicker.selectSubtitle' => 'Wählen Sie eine verschlüsselte PGP-Datei zum Importieren.',
			'settings.notesTransfer.filePicker.changeSubtitle' => 'Tippen Sie, um eine andere Datei auszuwählen.',
			'settings.notesTransfer.exportPassword.title' => 'Notizen exportieren',
			'settings.notesTransfer.exportPassword.passwordHint' => 'Export-Passwort...',
			'settings.notesTransfer.exportPassword.confirmPasswordHint' => 'Export-Passwort bestätigen...',
			'settings.notesTransfer.importPassword.title' => 'Notizen importieren',
			'settings.notesTransfer.importPassword.hint' => 'Datei-Passwort eingeben...',
			'settings.notesTransfer.importSuccess' => ({required Object count}) => '${count} Notizen importiert.',
			'settings.notesTransfer.exportSuccess' => ({required Object count}) => '${count} Notizen exportiert.',
			'settings.notesTransfer.errors.invalidFileOrPassword' => 'Die Datei ist ungültig oder das Passwort ist falsch.',
			'settings.notesTransfer.errors.unsupportedFormatVersion' => 'Diese Exportformat-Version wird nicht unterstützt.',
			'settings.notesTransfer.errors.invalidPayload' => 'Die Exportdatei enthält ungültige Notizen.',
			'settings.notesTransfer.errors.fileOperationFailed' => 'Auf die Datei konnte nicht zugegriffen werden.',
			'settings.about.title' => 'Über Veil',
			'settings.about.subtitle' => 'App-Informationen und Open-Source-Lizenzen.',
			'settings.about.version' => ({required Object version}) => 'Version ${version}',
			'settings.about.versionLoading' => 'Version wird geladen...',
			'settings.about.versionUnavailable' => 'Version nicht verfügbar',
			'settings.about.repositoryTitle' => 'Quellcode',
			'settings.about.repositorySubtitle' => 'Den Veil-Quellcode auf GitHub ansehen.',
			'settings.about.repositoryError' => 'Das Repository konnte nicht geöffnet werden.',
			'settings.about.licensesTitle' => 'Open-Source-Lizenzen',
			'settings.about.licensesSubtitle' => 'Lizenzen für Veil und seine Abhängigkeiten anzeigen.',
			'settings.about.licensesHeading' => 'Open-Source-Lizenzen',
			'settings.about.licensesIntro' => 'Veil ist unter der GNU General Public License v3.0 lizenziert.\n\nDiese App enthält Open-Source-Software und -Ressourcen von Drittanbietern. Die zugehörigen Lizenzen und Hinweise sind unten aufgeführt.',
			'settings.about.fullLicenseText' => 'Vollständiger Lizenztext',
			'settings.about.licensesLoading' => 'Lizenzen werden geladen...',
			'settings.about.licensesError' => 'Die Lizenzen konnten nicht geladen werden.',
			'veil.setup.passwordHint' => 'Gib ein Passwort ein, um zu starten...',
			'veil.setup.cta' => 'Los geht\'s!',
			'veil.setup.biometricsOptInTitle' => 'Biometrie aktivieren',
			'veil.setup.confirmPasswordHint' => 'Bestätige dein Passwort...',
			'veil.setup.passwordRulesCta' => 'Passwortregeln',
			'veil.setup.passwordRulesTitle' => 'Dein Passwort muss enthalten:',
			'veil.setup.passwordRuleMinLength' => 'Mindestens 10 Zeichen',
			'veil.setup.passwordRuleUppercase' => 'Mindestens 1 Großbuchstabe',
			'veil.setup.passwordRuleLowercase' => 'Mindestens 1 Kleinbuchstabe',
			'veil.setup.passwordRuleNumber' => 'Mindestens 1 Zahl',
			'veil.setup.passwordRuleSpecialChar' => 'Mindestens 1 Sonderzeichen',
			'veil.setup.passwordsDoNotMatch' => 'Passwörter stimmen nicht überein.',
			'veil.unlock.passwordHint' => 'Gib dein Passwort ein...',
			'veil.unlock.cta' => 'Entsperren',
			'veil.unlock.biometricTooltip' => 'Biometrie',
			'veil.splash.loading' => 'Wird geladen...',
			'veil.errors.passwordRequired' => 'Passwort ist erforderlich.',
			'veil.errors.passwordMissingLetter' => 'Das Passwort muss mindestens einen Buchstaben enthalten.',
			'veil.errors.passwordMissingNumber' => 'Das Passwort muss mindestens eine Zahl enthalten.',
			'veil.errors.invalidPassword' => 'Ungültiges Passwort.',
			'veil.errors.biometricUnavailable' => 'Biometrische Authentifizierung ist nicht verfügbar.',
			'veil.errors.biometricFailed' => 'Biometrische Authentifizierung ist fehlgeschlagen.',
			'veil.errors.biometricLockedOut' => 'Biometrische Authentifizierung ist vorübergehend gesperrt.',
			'veil.errors.vaultNotConfigured' => 'Tresor ist nicht konfiguriert.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'Verschlüsselter privater Schlüssel wurde nicht gefunden.',
			'veil.errors.publicKeyNotFound' => 'Öffentlicher Schlüssel wurde nicht gefunden.',
			'veil.errors.vaultLocked' => 'Tresor ist gesperrt.',
			'veil.errors.passwordMinLength' => 'Das Passwort muss mindestens 10 Zeichen lang sein.',
			'veil.errors.passwordMissingUppercase' => 'Das Passwort muss mindestens einen Großbuchstaben enthalten.',
			'veil.errors.passwordMissingLowercase' => 'Das Passwort muss mindestens einen Kleinbuchstaben enthalten.',
			'veil.errors.passwordMissingSpecialChar' => 'Das Passwort muss mindestens ein Sonderzeichen enthalten.',
			'veil.errors.passwordChangeFailed' => 'Das Passwort konnte nicht geändert werden. Dein Tresor ist unverändert.',
			_ => null,
		};
	}
}
