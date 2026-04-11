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
class TranslationsPtBr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPtBr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ptBr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt-BR>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsPtBr _root = this; // ignore: unused_field

	@override 
	TranslationsPtBr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPtBr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppPtBr app = _TranslationsAppPtBr._(_root);
	@override late final _TranslationsCommonPtBr common = _TranslationsCommonPtBr._(_root);
	@override late final _TranslationsNotesPtBr notes = _TranslationsNotesPtBr._(_root);
	@override late final _TranslationsSettingsPtBr settings = _TranslationsSettingsPtBr._(_root);
	@override late final _TranslationsVeilPtBr veil = _TranslationsVeilPtBr._(_root);
}

// Path: app
class _TranslationsAppPtBr extends TranslationsAppEn {
	_TranslationsAppPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonPtBr extends TranslationsCommonEn {
	_TranslationsCommonPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Carregando...';
	@override late final _TranslationsCommonActionsPtBr actions = _TranslationsCommonActionsPtBr._(_root);
	@override late final _TranslationsCommonLanguageNamesPtBr languageNames = _TranslationsCommonLanguageNamesPtBr._(_root);
	@override late final _TranslationsCommonErrorsPtBr errors = _TranslationsCommonErrorsPtBr._(_root);
}

// Path: notes
class _TranslationsNotesPtBr extends TranslationsNotesEn {
	_TranslationsNotesPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get empty => 'nenhuma nota ainda.';
	@override late final _TranslationsNotesDeletePtBr delete = _TranslationsNotesDeletePtBr._(_root);
	@override late final _TranslationsNotesEditorPtBr editor = _TranslationsNotesEditorPtBr._(_root);
}

// Path: settings
class _TranslationsSettingsPtBr extends TranslationsSettingsEn {
	_TranslationsSettingsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsPtBr biometrics = _TranslationsSettingsBiometricsPtBr._(_root);
	@override late final _TranslationsSettingsAutoLockPtBr autoLock = _TranslationsSettingsAutoLockPtBr._(_root);
	@override late final _TranslationsSettingsLanguagePtBr language = _TranslationsSettingsLanguagePtBr._(_root);
	@override late final _TranslationsSettingsLockPtBr lock = _TranslationsSettingsLockPtBr._(_root);
	@override late final _TranslationsSettingsConfirmPasswordPtBr confirmPassword = _TranslationsSettingsConfirmPasswordPtBr._(_root);
}

// Path: veil
class _TranslationsVeilPtBr extends TranslationsVeilEn {
	_TranslationsVeilPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupPtBr setup = _TranslationsVeilSetupPtBr._(_root);
	@override late final _TranslationsVeilUnlockPtBr unlock = _TranslationsVeilUnlockPtBr._(_root);
	@override late final _TranslationsVeilSplashPtBr splash = _TranslationsVeilSplashPtBr._(_root);
	@override late final _TranslationsVeilErrorsPtBr errors = _TranslationsVeilErrorsPtBr._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsPtBr extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get confirm => 'Confirmar';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesPtBr extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'Português (Brasil)';
	@override String get en => 'Inglês';
	@override String get es => 'Espanhol';
	@override String get de => 'Alemão';
	@override String get ru => 'Russo';
	@override String get ko => 'Coreano';
	@override String get zh => 'Chinês (Simplificado)';
	@override String get fr => 'Francês';
	@override String get ja => 'Japonês';
}

// Path: common.errors
class _TranslationsCommonErrorsPtBr extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'Ocorreu um erro inesperado.';
	@override String get loadFailed => 'Não foi possível carregar as informações.';
}

// Path: notes.delete
class _TranslationsNotesDeletePtBr extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeletePtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Excluir esta nota permanentemente?';
	@override String get confirm => 'Sim, excluir';
	@override String get cancel => 'Não, deixar como está';
}

// Path: notes.editor
class _TranslationsNotesEditorPtBr extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => 'Título ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsPtBr extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Biometria';
	@override String get subtitleAvailable => 'Use biometria para desbloquear o app mais rápido.';
	@override String get subtitleEnabledUnavailable => 'A biometria está ativada, mas não está disponível neste dispositivo.';
	@override String get subtitleDisabledUnavailable => 'Ative a biometria para desbloquear mais rápido.';
	@override String get checkingAvailability => 'Verificando disponibilidade da biometria...';
	@override String get loading => 'Carregando configurações da biometria...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockPtBr extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bloqueio automático';
	@override String subtitle({required Object duration}) => 'Bloqueia o app após ${duration}.';
	@override late final _TranslationsSettingsAutoLockOptionsPtBr options = _TranslationsSettingsAutoLockOptionsPtBr._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguagePtBr extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguagePtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
	@override String subtitle({required Object language}) => 'Idioma atual: ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockPtBr extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bloquear';
	@override String get subtitle => 'Limpa a sessão atual. Você precisará desbloquear novamente.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordPtBr extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirmar senha';
	@override String get hint => 'Digite sua senha...';
}

// Path: veil.setup
class _TranslationsVeilSetupPtBr extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Digite uma senha para começar...';
	@override String get cta => 'Vamos começar!';
}

// Path: veil.unlock
class _TranslationsVeilUnlockPtBr extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Digite sua senha...';
	@override String get cta => 'Desbloquear';
	@override String get biometricTooltip => 'Biometria';
}

// Path: veil.splash
class _TranslationsVeilSplashPtBr extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Carregando...';
}

// Path: veil.errors
class _TranslationsVeilErrorsPtBr extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'A senha é obrigatória.';
	@override String get passwordMinLength => 'A senha deve ter pelo menos 8 caracteres.';
	@override String get passwordMissingLetter => 'A senha deve conter ao menos uma letra.';
	@override String get passwordMissingNumber => 'A senha deve conter ao menos um número.';
	@override String get invalidPassword => 'Senha inválida.';
	@override String get biometricUnavailable => 'A autenticação biométrica não está disponível.';
	@override String get biometricFailed => 'A autenticação biométrica falhou.';
	@override String get biometricLockedOut => 'A autenticação biométrica está temporariamente bloqueada.';
	@override String get vaultNotConfigured => 'O cofre ainda não foi configurado.';
	@override String get encryptedPrivateKeyNotFound => 'A chave privada criptografada não foi encontrada.';
	@override String get publicKeyNotFound => 'A chave pública não foi encontrada.';
	@override String get vaultLocked => 'O cofre está bloqueado.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsPtBr extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 minuto';
	@override String get fiveMinutes => '5 minutos';
	@override String get fifteenMinutes => '15 minutos';
	@override String get thirtyMinutes => '30 minutos';
}

/// The flat map containing all translations for locale <pt-BR>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPtBr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Carregando...',
			'common.actions.cancel' => 'Cancelar',
			'common.actions.confirm' => 'Confirmar',
			'common.languageNames.ptBr' => 'Português (Brasil)',
			'common.languageNames.en' => 'Inglês',
			'common.languageNames.es' => 'Espanhol',
			'common.languageNames.de' => 'Alemão',
			'common.languageNames.ru' => 'Russo',
			'common.languageNames.ko' => 'Coreano',
			'common.languageNames.zh' => 'Chinês (Simplificado)',
			'common.languageNames.fr' => 'Francês',
			'common.languageNames.ja' => 'Japonês',
			'common.errors.unexpected' => 'Ocorreu um erro inesperado.',
			'common.errors.loadFailed' => 'Não foi possível carregar as informações.',
			'notes.empty' => 'nenhuma nota ainda.',
			'notes.delete.title' => 'Excluir esta nota permanentemente?',
			'notes.delete.confirm' => 'Sim, excluir',
			'notes.delete.cancel' => 'Não, deixar como está',
			'notes.editor.heading' => ({required Object level}) => 'Título ${level}',
			'settings.biometrics.title' => 'Biometria',
			'settings.biometrics.subtitleAvailable' => 'Use biometria para desbloquear o app mais rápido.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'A biometria está ativada, mas não está disponível neste dispositivo.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Ative a biometria para desbloquear mais rápido.',
			'settings.biometrics.checkingAvailability' => 'Verificando disponibilidade da biometria...',
			'settings.biometrics.loading' => 'Carregando configurações da biometria...',
			'settings.autoLock.title' => 'Bloqueio automático',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Bloqueia o app após ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 minuto',
			'settings.autoLock.options.fiveMinutes' => '5 minutos',
			'settings.autoLock.options.fifteenMinutes' => '15 minutos',
			'settings.autoLock.options.thirtyMinutes' => '30 minutos',
			'settings.language.title' => 'Idioma',
			'settings.language.subtitle' => ({required Object language}) => 'Idioma atual: ${language}.',
			'settings.lock.title' => 'Bloquear',
			'settings.lock.subtitle' => 'Limpa a sessão atual. Você precisará desbloquear novamente.',
			'settings.confirmPassword.title' => 'Confirmar senha',
			'settings.confirmPassword.hint' => 'Digite sua senha...',
			'veil.setup.passwordHint' => 'Digite uma senha para começar...',
			'veil.setup.cta' => 'Vamos começar!',
			'veil.unlock.passwordHint' => 'Digite sua senha...',
			'veil.unlock.cta' => 'Desbloquear',
			'veil.unlock.biometricTooltip' => 'Biometria',
			'veil.splash.loading' => 'Carregando...',
			'veil.errors.passwordRequired' => 'A senha é obrigatória.',
			'veil.errors.passwordMinLength' => 'A senha deve ter pelo menos 8 caracteres.',
			'veil.errors.passwordMissingLetter' => 'A senha deve conter ao menos uma letra.',
			'veil.errors.passwordMissingNumber' => 'A senha deve conter ao menos um número.',
			'veil.errors.invalidPassword' => 'Senha inválida.',
			'veil.errors.biometricUnavailable' => 'A autenticação biométrica não está disponível.',
			'veil.errors.biometricFailed' => 'A autenticação biométrica falhou.',
			'veil.errors.biometricLockedOut' => 'A autenticação biométrica está temporariamente bloqueada.',
			'veil.errors.vaultNotConfigured' => 'O cofre ainda não foi configurado.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'A chave privada criptografada não foi encontrada.',
			'veil.errors.publicKeyNotFound' => 'A chave pública não foi encontrada.',
			'veil.errors.vaultLocked' => 'O cofre está bloqueado.',
			_ => null,
		};
	}
}
