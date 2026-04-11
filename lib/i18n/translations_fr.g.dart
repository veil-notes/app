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
class TranslationsFr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppFr app = _TranslationsAppFr._(_root);
	@override late final _TranslationsCommonFr common = _TranslationsCommonFr._(_root);
	@override late final _TranslationsNotesFr notes = _TranslationsNotesFr._(_root);
	@override late final _TranslationsSettingsFr settings = _TranslationsSettingsFr._(_root);
	@override late final _TranslationsVeilFr veil = _TranslationsVeilFr._(_root);
}

// Path: app
class _TranslationsAppFr extends TranslationsAppEn {
	_TranslationsAppFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonFr extends TranslationsCommonEn {
	_TranslationsCommonFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement...';
	@override late final _TranslationsCommonActionsFr actions = _TranslationsCommonActionsFr._(_root);
	@override late final _TranslationsCommonLanguageNamesFr languageNames = _TranslationsCommonLanguageNamesFr._(_root);
	@override late final _TranslationsCommonErrorsFr errors = _TranslationsCommonErrorsFr._(_root);
}

// Path: notes
class _TranslationsNotesFr extends TranslationsNotesEn {
	_TranslationsNotesFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get empty => 'aucune note pour l\'instant.';
	@override late final _TranslationsNotesDeleteFr delete = _TranslationsNotesDeleteFr._(_root);
	@override late final _TranslationsNotesEditorFr editor = _TranslationsNotesEditorFr._(_root);
}

// Path: settings
class _TranslationsSettingsFr extends TranslationsSettingsEn {
	_TranslationsSettingsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsFr biometrics = _TranslationsSettingsBiometricsFr._(_root);
	@override late final _TranslationsSettingsAutoLockFr autoLock = _TranslationsSettingsAutoLockFr._(_root);
	@override late final _TranslationsSettingsLanguageFr language = _TranslationsSettingsLanguageFr._(_root);
	@override late final _TranslationsSettingsLockFr lock = _TranslationsSettingsLockFr._(_root);
	@override late final _TranslationsSettingsConfirmPasswordFr confirmPassword = _TranslationsSettingsConfirmPasswordFr._(_root);
}

// Path: veil
class _TranslationsVeilFr extends TranslationsVeilEn {
	_TranslationsVeilFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupFr setup = _TranslationsVeilSetupFr._(_root);
	@override late final _TranslationsVeilUnlockFr unlock = _TranslationsVeilUnlockFr._(_root);
	@override late final _TranslationsVeilSplashFr splash = _TranslationsVeilSplashFr._(_root);
	@override late final _TranslationsVeilErrorsFr errors = _TranslationsVeilErrorsFr._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsFr extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get confirm => 'Confirmer';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesFr extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'Portugais (Brésil)';
	@override String get en => 'Anglais';
	@override String get es => 'Espagnol';
	@override String get de => 'Allemand';
	@override String get ru => 'Russe';
	@override String get ko => 'Coréen';
	@override String get zh => 'Chinois (simplifié)';
	@override String get fr => 'Français';
	@override String get ja => 'Japonais';
}

// Path: common.errors
class _TranslationsCommonErrorsFr extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'Une erreur inattendue s\'est produite.';
	@override String get loadFailed => 'Impossible de charger les informations.';
}

// Path: notes.delete
class _TranslationsNotesDeleteFr extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Supprimer définitivement cette note ?';
	@override String get confirm => 'Oui, supprimer';
	@override String get cancel => 'Non, conserver';
}

// Path: notes.editor
class _TranslationsNotesEditorFr extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => 'Titre ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsFr extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Biométrie';
	@override String get subtitleAvailable => 'Utilisez la biométrie pour déverrouiller l\'app plus rapidement.';
	@override String get subtitleEnabledUnavailable => 'La biométrie est activée, mais elle n\'est pas disponible sur cet appareil.';
	@override String get subtitleDisabledUnavailable => 'Activez la biométrie pour déverrouiller plus rapidement.';
	@override String get checkingAvailability => 'Vérification de la disponibilité de la biométrie...';
	@override String get loading => 'Chargement des réglages biométriques...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockFr extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verrouillage automatique';
	@override String subtitle({required Object duration}) => 'Verrouille l\'app après ${duration}.';
	@override late final _TranslationsSettingsAutoLockOptionsFr options = _TranslationsSettingsAutoLockOptionsFr._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageFr extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Langue';
	@override String subtitle({required Object language}) => 'Langue actuelle : ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockFr extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verrouiller';
	@override String get subtitle => 'Efface la session actuelle. Vous devrez déverrouiller à nouveau.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordFr extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirmer le mot de passe';
	@override String get hint => 'Saisissez votre mot de passe...';
}

// Path: veil.setup
class _TranslationsVeilSetupFr extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Saisissez un mot de passe pour commencer...';
	@override String get cta => 'C\'est parti !';
}

// Path: veil.unlock
class _TranslationsVeilUnlockFr extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Saisissez votre mot de passe...';
	@override String get cta => 'Déverrouiller';
	@override String get biometricTooltip => 'Biométrie';
}

// Path: veil.splash
class _TranslationsVeilSplashFr extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement...';
}

// Path: veil.errors
class _TranslationsVeilErrorsFr extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'Le mot de passe est requis.';
	@override String get passwordMinLength => 'Le mot de passe doit contenir au moins 8 caractères.';
	@override String get passwordMissingLetter => 'Le mot de passe doit contenir au moins une lettre.';
	@override String get passwordMissingNumber => 'Le mot de passe doit contenir au moins un chiffre.';
	@override String get invalidPassword => 'Mot de passe invalide.';
	@override String get biometricUnavailable => 'L\'authentification biométrique n\'est pas disponible.';
	@override String get biometricFailed => 'L\'authentification biométrique a échoué.';
	@override String get biometricLockedOut => 'L\'authentification biométrique est temporairement verrouillée.';
	@override String get vaultNotConfigured => 'Le coffre n\'est pas configuré.';
	@override String get encryptedPrivateKeyNotFound => 'Clé privée chiffrée introuvable.';
	@override String get publicKeyNotFound => 'Clé publique introuvable.';
	@override String get vaultLocked => 'Le coffre est verrouillé.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsFr extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 minute';
	@override String get fiveMinutes => '5 minutes';
	@override String get fifteenMinutes => '15 minutes';
	@override String get thirtyMinutes => '30 minutes';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Chargement...',
			'common.actions.cancel' => 'Annuler',
			'common.actions.confirm' => 'Confirmer',
			'common.languageNames.ptBr' => 'Portugais (Brésil)',
			'common.languageNames.en' => 'Anglais',
			'common.languageNames.es' => 'Espagnol',
			'common.languageNames.de' => 'Allemand',
			'common.languageNames.ru' => 'Russe',
			'common.languageNames.ko' => 'Coréen',
			'common.languageNames.zh' => 'Chinois (simplifié)',
			'common.languageNames.fr' => 'Français',
			'common.languageNames.ja' => 'Japonais',
			'common.errors.unexpected' => 'Une erreur inattendue s\'est produite.',
			'common.errors.loadFailed' => 'Impossible de charger les informations.',
			'notes.empty' => 'aucune note pour l\'instant.',
			'notes.delete.title' => 'Supprimer définitivement cette note ?',
			'notes.delete.confirm' => 'Oui, supprimer',
			'notes.delete.cancel' => 'Non, conserver',
			'notes.editor.heading' => ({required Object level}) => 'Titre ${level}',
			'settings.biometrics.title' => 'Biométrie',
			'settings.biometrics.subtitleAvailable' => 'Utilisez la biométrie pour déverrouiller l\'app plus rapidement.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'La biométrie est activée, mais elle n\'est pas disponible sur cet appareil.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Activez la biométrie pour déverrouiller plus rapidement.',
			'settings.biometrics.checkingAvailability' => 'Vérification de la disponibilité de la biométrie...',
			'settings.biometrics.loading' => 'Chargement des réglages biométriques...',
			'settings.autoLock.title' => 'Verrouillage automatique',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Verrouille l\'app après ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 minute',
			'settings.autoLock.options.fiveMinutes' => '5 minutes',
			'settings.autoLock.options.fifteenMinutes' => '15 minutes',
			'settings.autoLock.options.thirtyMinutes' => '30 minutes',
			'settings.language.title' => 'Langue',
			'settings.language.subtitle' => ({required Object language}) => 'Langue actuelle : ${language}.',
			'settings.lock.title' => 'Verrouiller',
			'settings.lock.subtitle' => 'Efface la session actuelle. Vous devrez déverrouiller à nouveau.',
			'settings.confirmPassword.title' => 'Confirmer le mot de passe',
			'settings.confirmPassword.hint' => 'Saisissez votre mot de passe...',
			'veil.setup.passwordHint' => 'Saisissez un mot de passe pour commencer...',
			'veil.setup.cta' => 'C\'est parti !',
			'veil.unlock.passwordHint' => 'Saisissez votre mot de passe...',
			'veil.unlock.cta' => 'Déverrouiller',
			'veil.unlock.biometricTooltip' => 'Biométrie',
			'veil.splash.loading' => 'Chargement...',
			'veil.errors.passwordRequired' => 'Le mot de passe est requis.',
			'veil.errors.passwordMinLength' => 'Le mot de passe doit contenir au moins 8 caractères.',
			'veil.errors.passwordMissingLetter' => 'Le mot de passe doit contenir au moins une lettre.',
			'veil.errors.passwordMissingNumber' => 'Le mot de passe doit contenir au moins un chiffre.',
			'veil.errors.invalidPassword' => 'Mot de passe invalide.',
			'veil.errors.biometricUnavailable' => 'L\'authentification biométrique n\'est pas disponible.',
			'veil.errors.biometricFailed' => 'L\'authentification biométrique a échoué.',
			'veil.errors.biometricLockedOut' => 'L\'authentification biométrique est temporairement verrouillée.',
			'veil.errors.vaultNotConfigured' => 'Le coffre n\'est pas configuré.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'Clé privée chiffrée introuvable.',
			'veil.errors.publicKeyNotFound' => 'Clé publique introuvable.',
			'veil.errors.vaultLocked' => 'Le coffre est verrouillé.',
			_ => null,
		};
	}
}
