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
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppEs app = _TranslationsAppEs._(_root);
	@override late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
	@override late final _TranslationsNotesEs notes = _TranslationsNotesEs._(_root);
	@override late final _TranslationsSettingsEs settings = _TranslationsSettingsEs._(_root);
	@override late final _TranslationsVeilEs veil = _TranslationsVeilEs._(_root);
}

// Path: app
class _TranslationsAppEs extends TranslationsAppEn {
	_TranslationsAppEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonEs extends TranslationsCommonEn {
	_TranslationsCommonEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando...';
	@override late final _TranslationsCommonActionsEs actions = _TranslationsCommonActionsEs._(_root);
	@override late final _TranslationsCommonLanguageNamesEs languageNames = _TranslationsCommonLanguageNamesEs._(_root);
	@override late final _TranslationsCommonErrorsEs errors = _TranslationsCommonErrorsEs._(_root);
}

// Path: notes
class _TranslationsNotesEs extends TranslationsNotesEn {
	_TranslationsNotesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get empty => 'todavía no hay notas.';
	@override late final _TranslationsNotesDeleteEs delete = _TranslationsNotesDeleteEs._(_root);
	@override late final _TranslationsNotesEditorEs editor = _TranslationsNotesEditorEs._(_root);
}

// Path: settings
class _TranslationsSettingsEs extends TranslationsSettingsEn {
	_TranslationsSettingsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsEs biometrics = _TranslationsSettingsBiometricsEs._(_root);
	@override late final _TranslationsSettingsAutoLockEs autoLock = _TranslationsSettingsAutoLockEs._(_root);
	@override late final _TranslationsSettingsLanguageEs language = _TranslationsSettingsLanguageEs._(_root);
	@override late final _TranslationsSettingsLockEs lock = _TranslationsSettingsLockEs._(_root);
	@override late final _TranslationsSettingsConfirmPasswordEs confirmPassword = _TranslationsSettingsConfirmPasswordEs._(_root);
}

// Path: veil
class _TranslationsVeilEs extends TranslationsVeilEn {
	_TranslationsVeilEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupEs setup = _TranslationsVeilSetupEs._(_root);
	@override late final _TranslationsVeilUnlockEs unlock = _TranslationsVeilUnlockEs._(_root);
	@override late final _TranslationsVeilSplashEs splash = _TranslationsVeilSplashEs._(_root);
	@override late final _TranslationsVeilErrorsEs errors = _TranslationsVeilErrorsEs._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsEs extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get confirm => 'Confirmar';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesEs extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'Portugués (Brasil)';
	@override String get en => 'Inglés';
	@override String get es => 'Español';
	@override String get de => 'Alemán';
	@override String get ru => 'Ruso';
	@override String get ko => 'Coreano';
	@override String get zh => 'Chino (simplificado)';
	@override String get fr => 'Francés';
	@override String get ja => 'Japonés';
}

// Path: common.errors
class _TranslationsCommonErrorsEs extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'Ocurrió un error inesperado.';
	@override String get loadFailed => 'No se pudo cargar la información.';
}

// Path: notes.delete
class _TranslationsNotesDeleteEs extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Eliminar esta nota de forma permanente?';
	@override String get confirm => 'Sí, eliminar';
	@override String get cancel => 'No, conservar';
}

// Path: notes.editor
class _TranslationsNotesEditorEs extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => 'Encabezado ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsEs extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Biometría';
	@override String get subtitleAvailable => 'Usa la biometría para desbloquear la app más rápido.';
	@override String get subtitleEnabledUnavailable => 'La biometría está activada, pero no está disponible en este dispositivo.';
	@override String get subtitleDisabledUnavailable => 'Activa la biometría para desbloquear más rápido.';
	@override String get checkingAvailability => 'Comprobando disponibilidad de la biometría...';
	@override String get loading => 'Cargando ajustes de biometría...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockEs extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bloqueo automático';
	@override String subtitle({required Object duration}) => 'Bloquea la app después de ${duration}.';
	@override late final _TranslationsSettingsAutoLockOptionsEs options = _TranslationsSettingsAutoLockOptionsEs._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageEs extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
	@override String subtitle({required Object language}) => 'Idioma actual: ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockEs extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bloquear';
	@override String get subtitle => 'Borra la sesión actual. Tendrás que desbloquear de nuevo.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordEs extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirmar contraseña';
	@override String get hint => 'Escribe tu contraseña...';
}

// Path: veil.setup
class _TranslationsVeilSetupEs extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Escribe una contraseña para empezar...';
	@override String get cta => '¡Empecemos!';
	@override String get biometricsOptInTitle => 'Habilitar la biometría';
}

// Path: veil.unlock
class _TranslationsVeilUnlockEs extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Escribe tu contraseña...';
	@override String get cta => 'Desbloquear';
	@override String get biometricTooltip => 'Biometría';
}

// Path: veil.splash
class _TranslationsVeilSplashEs extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando...';
}

// Path: veil.errors
class _TranslationsVeilErrorsEs extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'La contraseña es obligatoria.';
	@override String get passwordMinLength => 'La contraseña debe tener al menos 8 caracteres.';
	@override String get passwordMissingLetter => 'La contraseña debe contener al menos una letra.';
	@override String get passwordMissingNumber => 'La contraseña debe contener al menos un número.';
	@override String get invalidPassword => 'Contraseña inválida.';
	@override String get biometricUnavailable => 'La autenticación biométrica no está disponible.';
	@override String get biometricFailed => 'La autenticación biométrica falló.';
	@override String get biometricLockedOut => 'La autenticación biométrica está bloqueada temporalmente.';
	@override String get vaultNotConfigured => 'La bóveda no está configurada.';
	@override String get encryptedPrivateKeyNotFound => 'No se encontró la clave privada cifrada.';
	@override String get publicKeyNotFound => 'No se encontró la clave pública.';
	@override String get vaultLocked => 'La bóveda está bloqueada.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsEs extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 minuto';
	@override String get fiveMinutes => '5 minutos';
	@override String get fifteenMinutes => '15 minutos';
	@override String get thirtyMinutes => '30 minutos';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Cargando...',
			'common.actions.cancel' => 'Cancelar',
			'common.actions.confirm' => 'Confirmar',
			'common.languageNames.ptBr' => 'Portugués (Brasil)',
			'common.languageNames.en' => 'Inglés',
			'common.languageNames.es' => 'Español',
			'common.languageNames.de' => 'Alemán',
			'common.languageNames.ru' => 'Ruso',
			'common.languageNames.ko' => 'Coreano',
			'common.languageNames.zh' => 'Chino (simplificado)',
			'common.languageNames.fr' => 'Francés',
			'common.languageNames.ja' => 'Japonés',
			'common.errors.unexpected' => 'Ocurrió un error inesperado.',
			'common.errors.loadFailed' => 'No se pudo cargar la información.',
			'notes.empty' => 'todavía no hay notas.',
			'notes.delete.title' => '¿Eliminar esta nota de forma permanente?',
			'notes.delete.confirm' => 'Sí, eliminar',
			'notes.delete.cancel' => 'No, conservar',
			'notes.editor.heading' => ({required Object level}) => 'Encabezado ${level}',
			'settings.biometrics.title' => 'Biometría',
			'settings.biometrics.subtitleAvailable' => 'Usa la biometría para desbloquear la app más rápido.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'La biometría está activada, pero no está disponible en este dispositivo.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Activa la biometría para desbloquear más rápido.',
			'settings.biometrics.checkingAvailability' => 'Comprobando disponibilidad de la biometría...',
			'settings.biometrics.loading' => 'Cargando ajustes de biometría...',
			'settings.autoLock.title' => 'Bloqueo automático',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Bloquea la app después de ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 minuto',
			'settings.autoLock.options.fiveMinutes' => '5 minutos',
			'settings.autoLock.options.fifteenMinutes' => '15 minutos',
			'settings.autoLock.options.thirtyMinutes' => '30 minutos',
			'settings.language.title' => 'Idioma',
			'settings.language.subtitle' => ({required Object language}) => 'Idioma actual: ${language}.',
			'settings.lock.title' => 'Bloquear',
			'settings.lock.subtitle' => 'Borra la sesión actual. Tendrás que desbloquear de nuevo.',
			'settings.confirmPassword.title' => 'Confirmar contraseña',
			'settings.confirmPassword.hint' => 'Escribe tu contraseña...',
			'veil.setup.passwordHint' => 'Escribe una contraseña para empezar...',
			'veil.setup.cta' => '¡Empecemos!',
			'veil.setup.biometricsOptInTitle' => 'Habilitar la biometría',
			'veil.unlock.passwordHint' => 'Escribe tu contraseña...',
			'veil.unlock.cta' => 'Desbloquear',
			'veil.unlock.biometricTooltip' => 'Biometría',
			'veil.splash.loading' => 'Cargando...',
			'veil.errors.passwordRequired' => 'La contraseña es obligatoria.',
			'veil.errors.passwordMinLength' => 'La contraseña debe tener al menos 8 caracteres.',
			'veil.errors.passwordMissingLetter' => 'La contraseña debe contener al menos una letra.',
			'veil.errors.passwordMissingNumber' => 'La contraseña debe contener al menos un número.',
			'veil.errors.invalidPassword' => 'Contraseña inválida.',
			'veil.errors.biometricUnavailable' => 'La autenticación biométrica no está disponible.',
			'veil.errors.biometricFailed' => 'La autenticación biométrica falló.',
			'veil.errors.biometricLockedOut' => 'La autenticación biométrica está bloqueada temporalmente.',
			'veil.errors.vaultNotConfigured' => 'La bóveda no está configurada.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'No se encontró la clave privada cifrada.',
			'veil.errors.publicKeyNotFound' => 'No se encontró la clave pública.',
			'veil.errors.vaultLocked' => 'La bóveda está bloqueada.',
			_ => null,
		};
	}
}
