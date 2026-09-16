///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsNotesEn notes = TranslationsNotesEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
	late final TranslationsVeilEn veil = TranslationsVeilEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Veil'
	String get title => 'Veil';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';

	late final TranslationsCommonActionsEn actions = TranslationsCommonActionsEn.internal(_root);
	late final TranslationsCommonLanguageNamesEn languageNames = TranslationsCommonLanguageNamesEn.internal(_root);
	late final TranslationsCommonErrorsEn errors = TranslationsCommonErrorsEn.internal(_root);
}

// Path: notes
class TranslationsNotesEn {
	TranslationsNotesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'no notes yet.'
	String get empty => 'no notes yet.';

	late final TranslationsNotesDeleteEn delete = TranslationsNotesDeleteEn.internal(_root);
	late final TranslationsNotesEditorEn editor = TranslationsNotesEditorEn.internal(_root);
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSettingsBiometricsEn biometrics = TranslationsSettingsBiometricsEn.internal(_root);
	late final TranslationsSettingsAutoLockEn autoLock = TranslationsSettingsAutoLockEn.internal(_root);
	late final TranslationsSettingsLanguageEn language = TranslationsSettingsLanguageEn.internal(_root);
	late final TranslationsSettingsLockEn lock = TranslationsSettingsLockEn.internal(_root);
	late final TranslationsSettingsConfirmPasswordEn confirmPassword = TranslationsSettingsConfirmPasswordEn.internal(_root);
	late final TranslationsSettingsChangePasswordEn changePassword = TranslationsSettingsChangePasswordEn.internal(_root);
	late final TranslationsSettingsNotesTransferEn notesTransfer = TranslationsSettingsNotesTransferEn.internal(_root);
	late final TranslationsSettingsAboutEn about = TranslationsSettingsAboutEn.internal(_root);
}

// Path: veil
class TranslationsVeilEn {
	TranslationsVeilEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsVeilSetupEn setup = TranslationsVeilSetupEn.internal(_root);
	late final TranslationsVeilUnlockEn unlock = TranslationsVeilUnlockEn.internal(_root);
	late final TranslationsVeilSplashEn splash = TranslationsVeilSplashEn.internal(_root);
	late final TranslationsVeilErrorsEn errors = TranslationsVeilErrorsEn.internal(_root);
}

// Path: common.actions
class TranslationsCommonActionsEn {
	TranslationsCommonActionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';
}

// Path: common.languageNames
class TranslationsCommonLanguageNamesEn {
	TranslationsCommonLanguageNamesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Portuguese (Brazil)'
	String get ptBr => 'Portuguese (Brazil)';

	/// en: 'English'
	String get en => 'English';

	/// en: 'Spanish'
	String get es => 'Spanish';

	/// en: 'German'
	String get de => 'German';

	/// en: 'Russian'
	String get ru => 'Russian';

	/// en: 'Korean'
	String get ko => 'Korean';

	/// en: 'Chinese (Simplified)'
	String get zh => 'Chinese (Simplified)';

	/// en: 'French'
	String get fr => 'French';

	/// en: 'Japanese'
	String get ja => 'Japanese';
}

// Path: common.errors
class TranslationsCommonErrorsEn {
	TranslationsCommonErrorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'An unexpected error occurred.'
	String get unexpected => 'An unexpected error occurred.';

	/// en: 'Could not load the information.'
	String get loadFailed => 'Could not load the information.';
}

// Path: notes.delete
class TranslationsNotesDeleteEn {
	TranslationsNotesDeleteEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete this note permanently?'
	String get title => 'Delete this note permanently?';

	/// en: 'Yes, delete'
	String get confirm => 'Yes, delete';

	/// en: 'No, keep it'
	String get cancel => 'No, keep it';
}

// Path: notes.editor
class TranslationsNotesEditorEn {
	TranslationsNotesEditorEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Heading {{level}}'
	String heading({required Object level}) => 'Heading ${level}';
}

// Path: settings.biometrics
class TranslationsSettingsBiometricsEn {
	TranslationsSettingsBiometricsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Biometrics'
	String get title => 'Biometrics';

	/// en: 'Use biometrics to unlock the app faster.'
	String get subtitleAvailable => 'Use biometrics to unlock the app faster.';

	/// en: 'Biometrics is enabled, but is not available on this device.'
	String get subtitleEnabledUnavailable => 'Biometrics is enabled, but is not available on this device.';

	/// en: 'Enable biometrics for faster unlock.'
	String get subtitleDisabledUnavailable => 'Enable biometrics for faster unlock.';

	/// en: 'Checking biometric availability...'
	String get checkingAvailability => 'Checking biometric availability...';

	/// en: 'Loading biometric settings...'
	String get loading => 'Loading biometric settings...';
}

// Path: settings.autoLock
class TranslationsSettingsAutoLockEn {
	TranslationsSettingsAutoLockEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Auto-lock'
	String get title => 'Auto-lock';

	/// en: 'Locks the app after {{duration}}.'
	String subtitle({required Object duration}) => 'Locks the app after ${duration}.';

	late final TranslationsSettingsAutoLockOptionsEn options = TranslationsSettingsAutoLockOptionsEn.internal(_root);
}

// Path: settings.language
class TranslationsSettingsLanguageEn {
	TranslationsSettingsLanguageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';

	/// en: 'Current language: {{language}}.'
	String subtitle({required Object language}) => 'Current language: ${language}.';
}

// Path: settings.lock
class TranslationsSettingsLockEn {
	TranslationsSettingsLockEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Lock'
	String get title => 'Lock';

	/// en: 'Clears the current session. You will need to unlock again.'
	String get subtitle => 'Clears the current session. You will need to unlock again.';
}

// Path: settings.confirmPassword
class TranslationsSettingsConfirmPasswordEn {
	TranslationsSettingsConfirmPasswordEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Confirm password'
	String get title => 'Confirm password';

	/// en: 'Type your password...'
	String get hint => 'Type your password...';
}

// Path: settings.changePassword
class TranslationsSettingsChangePasswordEn {
	TranslationsSettingsChangePasswordEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Change password'
	String get title => 'Change password';

	/// en: 'Replace the password used to protect your vault.'
	String get subtitle => 'Replace the password used to protect your vault.';

	/// en: 'Change vault password'
	String get sheetTitle => 'Change vault password';

	/// en: 'Current password...'
	String get currentPasswordHint => 'Current password...';

	/// en: 'New password...'
	String get newPasswordHint => 'New password...';

	/// en: 'Confirm new password...'
	String get confirmPasswordHint => 'Confirm new password...';

	/// en: 'Password changed successfully.'
	String get success => 'Password changed successfully.';
}

// Path: settings.notesTransfer
class TranslationsSettingsNotesTransferEn {
	TranslationsSettingsNotesTransferEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export notes'
	String get exportTitle => 'Export notes';

	/// en: 'Save an encrypted copy protected by a separate password.'
	String get exportSubtitle => 'Save an encrypted copy protected by a separate password.';

	/// en: 'Import notes'
	String get importTitle => 'Import notes';

	/// en: 'Restore notes from an encrypted PGP file.'
	String get importSubtitle => 'Restore notes from an encrypted PGP file.';

	late final TranslationsSettingsNotesTransferFilePickerEn filePicker = TranslationsSettingsNotesTransferFilePickerEn.internal(_root);
	late final TranslationsSettingsNotesTransferExportPasswordEn exportPassword = TranslationsSettingsNotesTransferExportPasswordEn.internal(_root);
	late final TranslationsSettingsNotesTransferImportPasswordEn importPassword = TranslationsSettingsNotesTransferImportPasswordEn.internal(_root);

	/// en: '{{count}} notes imported.'
	String importSuccess({required Object count}) => '${count} notes imported.';

	/// en: 'Exported {{count}} notes.'
	String exportSuccess({required Object count}) => 'Exported ${count} notes.';

	late final TranslationsSettingsNotesTransferErrorsEn errors = TranslationsSettingsNotesTransferErrorsEn.internal(_root);
}

// Path: settings.about
class TranslationsSettingsAboutEn {
	TranslationsSettingsAboutEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About'
	String get title => 'About';

	/// en: 'App information and open-source licenses.'
	String get subtitle => 'App information and open-source licenses.';

	/// en: 'Version {{version}}'
	String version({required Object version}) => 'Version ${version}';

	/// en: 'Loading version...'
	String get versionLoading => 'Loading version...';

	/// en: 'Version unavailable'
	String get versionUnavailable => 'Version unavailable';

	/// en: 'Source code'
	String get repositoryTitle => 'Source code';

	/// en: 'View the Veil source code on GitHub.'
	String get repositorySubtitle => 'View the Veil source code on GitHub.';

	/// en: 'Could not open the repository.'
	String get repositoryError => 'Could not open the repository.';

	/// en: 'Open source licenses'
	String get licensesTitle => 'Open source licenses';

	/// en: 'View licenses for Veil and its dependencies.'
	String get licensesSubtitle => 'View licenses for Veil and its dependencies.';

	/// en: 'Open Source Licenses'
	String get licensesHeading => 'Open Source Licenses';

	/// en: 'Veil is licensed under the GNU General Public License v3.0. This app includes third-party open-source software and assets. Their licenses and attributions are listed below.'
	String get licensesIntro => 'Veil is licensed under the GNU General Public License v3.0.\n\nThis app includes third-party open-source software and assets. Their licenses and attributions are listed below.';

	/// en: 'Full license text'
	String get fullLicenseText => 'Full license text';

	/// en: 'Loading licenses...'
	String get licensesLoading => 'Loading licenses...';

	/// en: 'Could not load the licenses.'
	String get licensesError => 'Could not load the licenses.';
}

// Path: veil.setup
class TranslationsVeilSetupEn {
	TranslationsVeilSetupEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Type a password to start...'
	String get passwordHint => 'Type a password to start...';

	/// en: 'Let's start!'
	String get cta => 'Let\'s start!';

	/// en: 'Enable biometrics'
	String get biometricsOptInTitle => 'Enable biometrics';

	/// en: 'Confirm your password...'
	String get confirmPasswordHint => 'Confirm your password...';

	/// en: 'Password rules'
	String get passwordRulesCta => 'Password rules';

	/// en: 'Your password must contain:'
	String get passwordRulesTitle => 'Your password must contain:';

	/// en: 'At least 10 characters'
	String get passwordRuleMinLength => 'At least 10 characters';

	/// en: 'At least 1 uppercase letter'
	String get passwordRuleUppercase => 'At least 1 uppercase letter';

	/// en: 'At least 1 lowercase letter'
	String get passwordRuleLowercase => 'At least 1 lowercase letter';

	/// en: 'At least 1 number'
	String get passwordRuleNumber => 'At least 1 number';

	/// en: 'At least 1 special character'
	String get passwordRuleSpecialChar => 'At least 1 special character';

	/// en: 'Passwords do not match.'
	String get passwordsDoNotMatch => 'Passwords do not match.';
}

// Path: veil.unlock
class TranslationsVeilUnlockEn {
	TranslationsVeilUnlockEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Type your password...'
	String get passwordHint => 'Type your password...';

	/// en: 'Unlock'
	String get cta => 'Unlock';

	/// en: 'Biometrics'
	String get biometricTooltip => 'Biometrics';
}

// Path: veil.splash
class TranslationsVeilSplashEn {
	TranslationsVeilSplashEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';
}

// Path: veil.errors
class TranslationsVeilErrorsEn {
	TranslationsVeilErrorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Password is required.'
	String get passwordRequired => 'Password is required.';

	/// en: 'Password must have at least 10 characters.'
	String get passwordMinLength => 'Password must have at least 10 characters.';

	/// en: 'Password must contain at least one letter.'
	String get passwordMissingLetter => 'Password must contain at least one letter.';

	/// en: 'Password must contain at least one number.'
	String get passwordMissingNumber => 'Password must contain at least one number.';

	/// en: 'Invalid password.'
	String get invalidPassword => 'Invalid password.';

	/// en: 'Biometric authentication is not available.'
	String get biometricUnavailable => 'Biometric authentication is not available.';

	/// en: 'Biometric authentication failed.'
	String get biometricFailed => 'Biometric authentication failed.';

	/// en: 'Biometric authentication is temporarily locked.'
	String get biometricLockedOut => 'Biometric authentication is temporarily locked.';

	/// en: 'Vault is not configured.'
	String get vaultNotConfigured => 'Vault is not configured.';

	/// en: 'Encrypted private key not found.'
	String get encryptedPrivateKeyNotFound => 'Encrypted private key not found.';

	/// en: 'Public key not found.'
	String get publicKeyNotFound => 'Public key not found.';

	/// en: 'Vault is locked.'
	String get vaultLocked => 'Vault is locked.';

	/// en: 'Password must contain at least one uppercase letter.'
	String get passwordMissingUppercase => 'Password must contain at least one uppercase letter.';

	/// en: 'Password must contain at least one lowercase letter.'
	String get passwordMissingLowercase => 'Password must contain at least one lowercase letter.';

	/// en: 'Password must contain at least one special character.'
	String get passwordMissingSpecialChar => 'Password must contain at least one special character.';

	/// en: 'Could not change the password. Your vault is unchanged.'
	String get passwordChangeFailed => 'Could not change the password. Your vault is unchanged.';
}

// Path: settings.autoLock.options
class TranslationsSettingsAutoLockOptionsEn {
	TranslationsSettingsAutoLockOptionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '1 minute'
	String get oneMinute => '1 minute';

	/// en: '5 minutes'
	String get fiveMinutes => '5 minutes';

	/// en: '15 minutes'
	String get fifteenMinutes => '15 minutes';

	/// en: '30 minutes'
	String get thirtyMinutes => '30 minutes';
}

// Path: settings.notesTransfer.filePicker
class TranslationsSettingsNotesTransferFilePickerEn {
	TranslationsSettingsNotesTransferFilePickerEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select an import file'
	String get selectTitle => 'Select an import file';

	/// en: 'Choose an encrypted PGP file to import.'
	String get selectSubtitle => 'Choose an encrypted PGP file to import.';

	/// en: 'Tap to select a different file.'
	String get changeSubtitle => 'Tap to select a different file.';
}

// Path: settings.notesTransfer.exportPassword
class TranslationsSettingsNotesTransferExportPasswordEn {
	TranslationsSettingsNotesTransferExportPasswordEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export notes'
	String get title => 'Export notes';

	/// en: 'Export password...'
	String get passwordHint => 'Export password...';

	/// en: 'Confirm export password...'
	String get confirmPasswordHint => 'Confirm export password...';
}

// Path: settings.notesTransfer.importPassword
class TranslationsSettingsNotesTransferImportPasswordEn {
	TranslationsSettingsNotesTransferImportPasswordEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Import notes'
	String get title => 'Import notes';

	/// en: 'Type the file password...'
	String get hint => 'Type the file password...';
}

// Path: settings.notesTransfer.errors
class TranslationsSettingsNotesTransferErrorsEn {
	TranslationsSettingsNotesTransferErrorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'The file is invalid or the password is incorrect.'
	String get invalidFileOrPassword => 'The file is invalid or the password is incorrect.';

	/// en: 'This export format is not supported.'
	String get unsupportedFormatVersion => 'This export format is not supported.';

	/// en: 'The export file contains invalid notes.'
	String get invalidPayload => 'The export file contains invalid notes.';

	/// en: 'The file could not be accessed.'
	String get fileOperationFailed => 'The file could not be accessed.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Loading...',
			'common.actions.cancel' => 'Cancel',
			'common.actions.confirm' => 'Confirm',
			'common.languageNames.ptBr' => 'Portuguese (Brazil)',
			'common.languageNames.en' => 'English',
			'common.languageNames.es' => 'Spanish',
			'common.languageNames.de' => 'German',
			'common.languageNames.ru' => 'Russian',
			'common.languageNames.ko' => 'Korean',
			'common.languageNames.zh' => 'Chinese (Simplified)',
			'common.languageNames.fr' => 'French',
			'common.languageNames.ja' => 'Japanese',
			'common.errors.unexpected' => 'An unexpected error occurred.',
			'common.errors.loadFailed' => 'Could not load the information.',
			'notes.empty' => 'no notes yet.',
			'notes.delete.title' => 'Delete this note permanently?',
			'notes.delete.confirm' => 'Yes, delete',
			'notes.delete.cancel' => 'No, keep it',
			'notes.editor.heading' => ({required Object level}) => 'Heading ${level}',
			'settings.biometrics.title' => 'Biometrics',
			'settings.biometrics.subtitleAvailable' => 'Use biometrics to unlock the app faster.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'Biometrics is enabled, but is not available on this device.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Enable biometrics for faster unlock.',
			'settings.biometrics.checkingAvailability' => 'Checking biometric availability...',
			'settings.biometrics.loading' => 'Loading biometric settings...',
			'settings.autoLock.title' => 'Auto-lock',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Locks the app after ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 minute',
			'settings.autoLock.options.fiveMinutes' => '5 minutes',
			'settings.autoLock.options.fifteenMinutes' => '15 minutes',
			'settings.autoLock.options.thirtyMinutes' => '30 minutes',
			'settings.language.title' => 'Language',
			'settings.language.subtitle' => ({required Object language}) => 'Current language: ${language}.',
			'settings.lock.title' => 'Lock',
			'settings.lock.subtitle' => 'Clears the current session. You will need to unlock again.',
			'settings.confirmPassword.title' => 'Confirm password',
			'settings.confirmPassword.hint' => 'Type your password...',
			'settings.changePassword.title' => 'Change password',
			'settings.changePassword.subtitle' => 'Replace the password used to protect your vault.',
			'settings.changePassword.sheetTitle' => 'Change vault password',
			'settings.changePassword.currentPasswordHint' => 'Current password...',
			'settings.changePassword.newPasswordHint' => 'New password...',
			'settings.changePassword.confirmPasswordHint' => 'Confirm new password...',
			'settings.changePassword.success' => 'Password changed successfully.',
			'settings.notesTransfer.exportTitle' => 'Export notes',
			'settings.notesTransfer.exportSubtitle' => 'Save an encrypted copy protected by a separate password.',
			'settings.notesTransfer.importTitle' => 'Import notes',
			'settings.notesTransfer.importSubtitle' => 'Restore notes from an encrypted PGP file.',
			'settings.notesTransfer.filePicker.selectTitle' => 'Select an import file',
			'settings.notesTransfer.filePicker.selectSubtitle' => 'Choose an encrypted PGP file to import.',
			'settings.notesTransfer.filePicker.changeSubtitle' => 'Tap to select a different file.',
			'settings.notesTransfer.exportPassword.title' => 'Export notes',
			'settings.notesTransfer.exportPassword.passwordHint' => 'Export password...',
			'settings.notesTransfer.exportPassword.confirmPasswordHint' => 'Confirm export password...',
			'settings.notesTransfer.importPassword.title' => 'Import notes',
			'settings.notesTransfer.importPassword.hint' => 'Type the file password...',
			'settings.notesTransfer.importSuccess' => ({required Object count}) => '${count} notes imported.',
			'settings.notesTransfer.exportSuccess' => ({required Object count}) => 'Exported ${count} notes.',
			'settings.notesTransfer.errors.invalidFileOrPassword' => 'The file is invalid or the password is incorrect.',
			'settings.notesTransfer.errors.unsupportedFormatVersion' => 'This export format is not supported.',
			'settings.notesTransfer.errors.invalidPayload' => 'The export file contains invalid notes.',
			'settings.notesTransfer.errors.fileOperationFailed' => 'The file could not be accessed.',
			'settings.about.title' => 'About',
			'settings.about.subtitle' => 'App information and open-source licenses.',
			'settings.about.version' => ({required Object version}) => 'Version ${version}',
			'settings.about.versionLoading' => 'Loading version...',
			'settings.about.versionUnavailable' => 'Version unavailable',
			'settings.about.repositoryTitle' => 'Source code',
			'settings.about.repositorySubtitle' => 'View the Veil source code on GitHub.',
			'settings.about.repositoryError' => 'Could not open the repository.',
			'settings.about.licensesTitle' => 'Open source licenses',
			'settings.about.licensesSubtitle' => 'View licenses for Veil and its dependencies.',
			'settings.about.licensesHeading' => 'Open Source Licenses',
			'settings.about.licensesIntro' => 'Veil is licensed under the GNU General Public License v3.0.\n\nThis app includes third-party open-source software and assets. Their licenses and attributions are listed below.',
			'settings.about.fullLicenseText' => 'Full license text',
			'settings.about.licensesLoading' => 'Loading licenses...',
			'settings.about.licensesError' => 'Could not load the licenses.',
			'veil.setup.passwordHint' => 'Type a password to start...',
			'veil.setup.cta' => 'Let\'s start!',
			'veil.setup.biometricsOptInTitle' => 'Enable biometrics',
			'veil.setup.confirmPasswordHint' => 'Confirm your password...',
			'veil.setup.passwordRulesCta' => 'Password rules',
			'veil.setup.passwordRulesTitle' => 'Your password must contain:',
			'veil.setup.passwordRuleMinLength' => 'At least 10 characters',
			'veil.setup.passwordRuleUppercase' => 'At least 1 uppercase letter',
			'veil.setup.passwordRuleLowercase' => 'At least 1 lowercase letter',
			'veil.setup.passwordRuleNumber' => 'At least 1 number',
			'veil.setup.passwordRuleSpecialChar' => 'At least 1 special character',
			'veil.setup.passwordsDoNotMatch' => 'Passwords do not match.',
			'veil.unlock.passwordHint' => 'Type your password...',
			'veil.unlock.cta' => 'Unlock',
			'veil.unlock.biometricTooltip' => 'Biometrics',
			'veil.splash.loading' => 'Loading...',
			'veil.errors.passwordRequired' => 'Password is required.',
			'veil.errors.passwordMinLength' => 'Password must have at least 10 characters.',
			'veil.errors.passwordMissingLetter' => 'Password must contain at least one letter.',
			'veil.errors.passwordMissingNumber' => 'Password must contain at least one number.',
			'veil.errors.invalidPassword' => 'Invalid password.',
			'veil.errors.biometricUnavailable' => 'Biometric authentication is not available.',
			'veil.errors.biometricFailed' => 'Biometric authentication failed.',
			'veil.errors.biometricLockedOut' => 'Biometric authentication is temporarily locked.',
			'veil.errors.vaultNotConfigured' => 'Vault is not configured.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'Encrypted private key not found.',
			'veil.errors.publicKeyNotFound' => 'Public key not found.',
			'veil.errors.vaultLocked' => 'Vault is locked.',
			'veil.errors.passwordMissingUppercase' => 'Password must contain at least one uppercase letter.',
			'veil.errors.passwordMissingLowercase' => 'Password must contain at least one lowercase letter.',
			'veil.errors.passwordMissingSpecialChar' => 'Password must contain at least one special character.',
			'veil.errors.passwordChangeFailed' => 'Could not change the password. Your vault is unchanged.',
			_ => null,
		};
	}
}
