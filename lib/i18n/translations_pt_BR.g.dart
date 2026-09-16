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
	@override late final _TranslationsSettingsChangePasswordPtBr changePassword = _TranslationsSettingsChangePasswordPtBr._(_root);
	@override late final _TranslationsSettingsNotesTransferPtBr notesTransfer = _TranslationsSettingsNotesTransferPtBr._(_root);
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

// Path: settings.changePassword
class _TranslationsSettingsChangePasswordPtBr extends TranslationsSettingsChangePasswordEn {
	_TranslationsSettingsChangePasswordPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Alterar senha';
	@override String get subtitle => 'Substitua a senha usada para proteger seu cofre.';
	@override String get sheetTitle => 'Alterar senha do cofre';
	@override String get currentPasswordHint => 'Senha atual...';
	@override String get newPasswordHint => 'Nova senha...';
	@override String get confirmPasswordHint => 'Confirme a nova senha...';
	@override String get success => 'Senha alterada com sucesso.';
}

// Path: settings.notesTransfer
class _TranslationsSettingsNotesTransferPtBr extends TranslationsSettingsNotesTransferEn {
	_TranslationsSettingsNotesTransferPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get exportTitle => 'Exportar notas';
	@override String get exportSubtitle => 'Salvar uma cópia criptografada protegida por uma senha separada.';
	@override String get importTitle => 'Importar notas';
	@override String get importSubtitle => 'Restaurar notas de um arquivo PGP criptografado.';
	@override late final _TranslationsSettingsNotesTransferFilePickerPtBr filePicker = _TranslationsSettingsNotesTransferFilePickerPtBr._(_root);
	@override late final _TranslationsSettingsNotesTransferExportPasswordPtBr exportPassword = _TranslationsSettingsNotesTransferExportPasswordPtBr._(_root);
	@override late final _TranslationsSettingsNotesTransferImportPasswordPtBr importPassword = _TranslationsSettingsNotesTransferImportPasswordPtBr._(_root);
	@override String importSuccess({required Object count}) => '${count} notas importadas.';
	@override String exportSuccess({required Object count}) => '${count} notas exportadas.';
	@override late final _TranslationsSettingsNotesTransferErrorsPtBr errors = _TranslationsSettingsNotesTransferErrorsPtBr._(_root);
}

// Path: veil.setup
class _TranslationsVeilSetupPtBr extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Digite uma senha para começar...';
	@override String get cta => 'Vamos começar!';
	@override String get biometricsOptInTitle => 'Ativar biometria';
	@override String get confirmPasswordHint => 'Confirme sua senha...';
	@override String get passwordRulesCta => 'Regras da senha';
	@override String get passwordRulesTitle => 'Sua senha deve conter:';
	@override String get passwordRuleMinLength => 'Pelo menos 10 caracteres';
	@override String get passwordRuleUppercase => 'Pelo menos 1 letra maiúscula';
	@override String get passwordRuleLowercase => 'Pelo menos 1 letra minúscula';
	@override String get passwordRuleNumber => 'Pelo menos 1 número';
	@override String get passwordRuleSpecialChar => 'Pelo menos 1 caractere especial';
	@override String get passwordsDoNotMatch => 'As senhas não coincidem.';
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
	@override String get passwordMinLength => 'A senha deve ter pelo menos 10 caracteres.';
	@override String get passwordMissingUppercase => 'A senha deve conter ao menos uma letra maiúscula.';
	@override String get passwordMissingLowercase => 'A senha deve conter ao menos uma letra minúscula.';
	@override String get passwordMissingSpecialChar => 'A senha deve conter ao menos um caractere especial.';
	@override String get passwordChangeFailed => 'Não foi possível alterar a senha. Seu cofre não foi alterado.';
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

// Path: settings.notesTransfer.filePicker
class _TranslationsSettingsNotesTransferFilePickerPtBr extends TranslationsSettingsNotesTransferFilePickerEn {
	_TranslationsSettingsNotesTransferFilePickerPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get selectTitle => 'Selecione um arquivo para importar';
	@override String get selectSubtitle => 'Escolha um arquivo PGP criptografado para importar.';
	@override String get changeSubtitle => 'Toque para selecionar outro arquivo.';
}

// Path: settings.notesTransfer.exportPassword
class _TranslationsSettingsNotesTransferExportPasswordPtBr extends TranslationsSettingsNotesTransferExportPasswordEn {
	_TranslationsSettingsNotesTransferExportPasswordPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exportar notas';
	@override String get passwordHint => 'Senha da exportação...';
	@override String get confirmPasswordHint => 'Confirme a senha da exportação...';
}

// Path: settings.notesTransfer.importPassword
class _TranslationsSettingsNotesTransferImportPasswordPtBr extends TranslationsSettingsNotesTransferImportPasswordEn {
	_TranslationsSettingsNotesTransferImportPasswordPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Importar notas';
	@override String get hint => 'Digite a senha do arquivo...';
}

// Path: settings.notesTransfer.errors
class _TranslationsSettingsNotesTransferErrorsPtBr extends TranslationsSettingsNotesTransferErrorsEn {
	_TranslationsSettingsNotesTransferErrorsPtBr._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get invalidFileOrPassword => 'O arquivo é inválido ou a senha está incorreta.';
	@override String get unsupportedFormatVersion => 'Esta versão do formato de exportação não é suportada.';
	@override String get invalidPayload => 'O arquivo de exportação contém notas inválidas.';
	@override String get fileOperationFailed => 'Não foi possível acessar o arquivo.';
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
			'settings.changePassword.title' => 'Alterar senha',
			'settings.changePassword.subtitle' => 'Substitua a senha usada para proteger seu cofre.',
			'settings.changePassword.sheetTitle' => 'Alterar senha do cofre',
			'settings.changePassword.currentPasswordHint' => 'Senha atual...',
			'settings.changePassword.newPasswordHint' => 'Nova senha...',
			'settings.changePassword.confirmPasswordHint' => 'Confirme a nova senha...',
			'settings.changePassword.success' => 'Senha alterada com sucesso.',
			'settings.notesTransfer.exportTitle' => 'Exportar notas',
			'settings.notesTransfer.exportSubtitle' => 'Salvar uma cópia criptografada protegida por uma senha separada.',
			'settings.notesTransfer.importTitle' => 'Importar notas',
			'settings.notesTransfer.importSubtitle' => 'Restaurar notas de um arquivo PGP criptografado.',
			'settings.notesTransfer.filePicker.selectTitle' => 'Selecione um arquivo para importar',
			'settings.notesTransfer.filePicker.selectSubtitle' => 'Escolha um arquivo PGP criptografado para importar.',
			'settings.notesTransfer.filePicker.changeSubtitle' => 'Toque para selecionar outro arquivo.',
			'settings.notesTransfer.exportPassword.title' => 'Exportar notas',
			'settings.notesTransfer.exportPassword.passwordHint' => 'Senha da exportação...',
			'settings.notesTransfer.exportPassword.confirmPasswordHint' => 'Confirme a senha da exportação...',
			'settings.notesTransfer.importPassword.title' => 'Importar notas',
			'settings.notesTransfer.importPassword.hint' => 'Digite a senha do arquivo...',
			'settings.notesTransfer.importSuccess' => ({required Object count}) => '${count} notas importadas.',
			'settings.notesTransfer.exportSuccess' => ({required Object count}) => '${count} notas exportadas.',
			'settings.notesTransfer.errors.invalidFileOrPassword' => 'O arquivo é inválido ou a senha está incorreta.',
			'settings.notesTransfer.errors.unsupportedFormatVersion' => 'Esta versão do formato de exportação não é suportada.',
			'settings.notesTransfer.errors.invalidPayload' => 'O arquivo de exportação contém notas inválidas.',
			'settings.notesTransfer.errors.fileOperationFailed' => 'Não foi possível acessar o arquivo.',
			'veil.setup.passwordHint' => 'Digite uma senha para começar...',
			'veil.setup.cta' => 'Vamos começar!',
			'veil.setup.biometricsOptInTitle' => 'Ativar biometria',
			'veil.setup.confirmPasswordHint' => 'Confirme sua senha...',
			'veil.setup.passwordRulesCta' => 'Regras da senha',
			'veil.setup.passwordRulesTitle' => 'Sua senha deve conter:',
			'veil.setup.passwordRuleMinLength' => 'Pelo menos 10 caracteres',
			'veil.setup.passwordRuleUppercase' => 'Pelo menos 1 letra maiúscula',
			'veil.setup.passwordRuleLowercase' => 'Pelo menos 1 letra minúscula',
			'veil.setup.passwordRuleNumber' => 'Pelo menos 1 número',
			'veil.setup.passwordRuleSpecialChar' => 'Pelo menos 1 caractere especial',
			'veil.setup.passwordsDoNotMatch' => 'As senhas não coincidem.',
			'veil.unlock.passwordHint' => 'Digite sua senha...',
			'veil.unlock.cta' => 'Desbloquear',
			'veil.unlock.biometricTooltip' => 'Biometria',
			'veil.splash.loading' => 'Carregando...',
			'veil.errors.passwordRequired' => 'A senha é obrigatória.',
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
			'veil.errors.passwordMinLength' => 'A senha deve ter pelo menos 10 caracteres.',
			'veil.errors.passwordMissingUppercase' => 'A senha deve conter ao menos uma letra maiúscula.',
			'veil.errors.passwordMissingLowercase' => 'A senha deve conter ao menos uma letra minúscula.',
			'veil.errors.passwordMissingSpecialChar' => 'A senha deve conter ao menos um caractere especial.',
			'veil.errors.passwordChangeFailed' => 'Não foi possível alterar a senha. Seu cofre não foi alterado.',
			_ => null,
		};
	}
}
