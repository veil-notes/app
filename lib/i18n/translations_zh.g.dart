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
class TranslationsZh extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZh({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zh,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsZh _root = this; // ignore: unused_field

	@override 
	TranslationsZh $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZh(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppZh app = _TranslationsAppZh._(_root);
	@override late final _TranslationsCommonZh common = _TranslationsCommonZh._(_root);
	@override late final _TranslationsNotesZh notes = _TranslationsNotesZh._(_root);
	@override late final _TranslationsSettingsZh settings = _TranslationsSettingsZh._(_root);
	@override late final _TranslationsVeilZh veil = _TranslationsVeilZh._(_root);
}

// Path: app
class _TranslationsAppZh extends TranslationsAppEn {
	_TranslationsAppZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonZh extends TranslationsCommonEn {
	_TranslationsCommonZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get loading => '加载中...';
	@override late final _TranslationsCommonActionsZh actions = _TranslationsCommonActionsZh._(_root);
	@override late final _TranslationsCommonLanguageNamesZh languageNames = _TranslationsCommonLanguageNamesZh._(_root);
	@override late final _TranslationsCommonErrorsZh errors = _TranslationsCommonErrorsZh._(_root);
}

// Path: notes
class _TranslationsNotesZh extends TranslationsNotesEn {
	_TranslationsNotesZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get empty => '还没有笔记。';
	@override late final _TranslationsNotesDeleteZh delete = _TranslationsNotesDeleteZh._(_root);
	@override late final _TranslationsNotesEditorZh editor = _TranslationsNotesEditorZh._(_root);
}

// Path: settings
class _TranslationsSettingsZh extends TranslationsSettingsEn {
	_TranslationsSettingsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsZh biometrics = _TranslationsSettingsBiometricsZh._(_root);
	@override late final _TranslationsSettingsAutoLockZh autoLock = _TranslationsSettingsAutoLockZh._(_root);
	@override late final _TranslationsSettingsLanguageZh language = _TranslationsSettingsLanguageZh._(_root);
	@override late final _TranslationsSettingsLockZh lock = _TranslationsSettingsLockZh._(_root);
	@override late final _TranslationsSettingsConfirmPasswordZh confirmPassword = _TranslationsSettingsConfirmPasswordZh._(_root);
}

// Path: veil
class _TranslationsVeilZh extends TranslationsVeilEn {
	_TranslationsVeilZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupZh setup = _TranslationsVeilSetupZh._(_root);
	@override late final _TranslationsVeilUnlockZh unlock = _TranslationsVeilUnlockZh._(_root);
	@override late final _TranslationsVeilSplashZh splash = _TranslationsVeilSplashZh._(_root);
	@override late final _TranslationsVeilErrorsZh errors = _TranslationsVeilErrorsZh._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsZh extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get confirm => '确认';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesZh extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get ptBr => '葡萄牙语（巴西）';
	@override String get en => '英语';
	@override String get es => '西班牙语';
	@override String get de => '德语';
	@override String get ru => '俄语';
	@override String get ko => '韩语';
	@override String get zh => '简体中文';
	@override String get fr => '法语';
	@override String get ja => '日语';
}

// Path: common.errors
class _TranslationsCommonErrorsZh extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get unexpected => '发生了意外错误。';
	@override String get loadFailed => '无法加载信息。';
}

// Path: notes.delete
class _TranslationsNotesDeleteZh extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '要永久删除这条笔记吗？';
	@override String get confirm => '是的，删除';
	@override String get cancel => '不，保留';
}

// Path: notes.editor
class _TranslationsNotesEditorZh extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => '标题 ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsZh extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '生物识别';
	@override String get subtitleAvailable => '使用生物识别可更快解锁应用。';
	@override String get subtitleEnabledUnavailable => '生物识别已启用，但此设备上不可用。';
	@override String get subtitleDisabledUnavailable => '启用生物识别以更快解锁。';
	@override String get checkingAvailability => '正在检查生物识别可用性...';
	@override String get loading => '正在加载生物识别设置...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockZh extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '自动锁定';
	@override String subtitle({required Object duration}) => '应用将在 ${duration} 后锁定。';
	@override late final _TranslationsSettingsAutoLockOptionsZh options = _TranslationsSettingsAutoLockOptionsZh._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageZh extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '语言';
	@override String subtitle({required Object language}) => '当前语言：${language}。';
}

// Path: settings.lock
class _TranslationsSettingsLockZh extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '锁定';
	@override String get subtitle => '清除当前会话。你需要重新解锁。';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordZh extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '确认密码';
	@override String get hint => '输入你的密码...';
}

// Path: veil.setup
class _TranslationsVeilSetupZh extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => '输入密码以开始...';
	@override String get cta => '开始吧！';
	@override String get biometricsOptInTitle => '启用生物识别技术';
	@override String get confirmPasswordHint => '请再次输入密码...';
	@override String get passwordRulesCta => '密码规则';
	@override String get passwordRulesTitle => '你的密码必须包含：';
	@override String get passwordRuleMinLength => '至少 10 个字符';
	@override String get passwordRuleUppercase => '至少 1 个大写字母';
	@override String get passwordRuleLowercase => '至少 1 个小写字母';
	@override String get passwordRuleNumber => '至少 1 个数字';
	@override String get passwordRuleSpecialChar => '至少 1 个特殊字符';
	@override String get passwordsDoNotMatch => '两次输入的密码不一致。';
}

// Path: veil.unlock
class _TranslationsVeilUnlockZh extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => '输入你的密码...';
	@override String get cta => '解锁';
	@override String get biometricTooltip => '生物识别';
}

// Path: veil.splash
class _TranslationsVeilSplashZh extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get loading => '加载中...';
}

// Path: veil.errors
class _TranslationsVeilErrorsZh extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => '密码是必填项。';
	@override String get passwordMissingLetter => '密码必须至少包含一个字母。';
	@override String get passwordMissingNumber => '密码必须至少包含一个数字。';
	@override String get invalidPassword => '密码无效。';
	@override String get biometricUnavailable => '生物识别认证不可用。';
	@override String get biometricFailed => '生物识别认证失败。';
	@override String get biometricLockedOut => '生物识别认证已被暂时锁定。';
	@override String get vaultNotConfigured => '保险库尚未配置。';
	@override String get encryptedPrivateKeyNotFound => '未找到加密私钥。';
	@override String get publicKeyNotFound => '未找到公钥。';
	@override String get vaultLocked => '保险库已锁定。';
	@override String get passwordMinLength => '密码至少需要 10 个字符。';
	@override String get passwordMissingUppercase => '密码必须至少包含一个大写字母。';
	@override String get passwordMissingLowercase => '密码必须至少包含一个小写字母。';
	@override String get passwordMissingSpecialChar => '密码必须至少包含一个特殊字符。';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsZh extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsZh._(TranslationsZh root) : this._root = root, super.internal(root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 分钟';
	@override String get fiveMinutes => '5 分钟';
	@override String get fifteenMinutes => '15 分钟';
	@override String get thirtyMinutes => '30 分钟';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZh {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => '加载中...',
			'common.actions.cancel' => '取消',
			'common.actions.confirm' => '确认',
			'common.languageNames.ptBr' => '葡萄牙语（巴西）',
			'common.languageNames.en' => '英语',
			'common.languageNames.es' => '西班牙语',
			'common.languageNames.de' => '德语',
			'common.languageNames.ru' => '俄语',
			'common.languageNames.ko' => '韩语',
			'common.languageNames.zh' => '简体中文',
			'common.languageNames.fr' => '法语',
			'common.languageNames.ja' => '日语',
			'common.errors.unexpected' => '发生了意外错误。',
			'common.errors.loadFailed' => '无法加载信息。',
			'notes.empty' => '还没有笔记。',
			'notes.delete.title' => '要永久删除这条笔记吗？',
			'notes.delete.confirm' => '是的，删除',
			'notes.delete.cancel' => '不，保留',
			'notes.editor.heading' => ({required Object level}) => '标题 ${level}',
			'settings.biometrics.title' => '生物识别',
			'settings.biometrics.subtitleAvailable' => '使用生物识别可更快解锁应用。',
			'settings.biometrics.subtitleEnabledUnavailable' => '生物识别已启用，但此设备上不可用。',
			'settings.biometrics.subtitleDisabledUnavailable' => '启用生物识别以更快解锁。',
			'settings.biometrics.checkingAvailability' => '正在检查生物识别可用性...',
			'settings.biometrics.loading' => '正在加载生物识别设置...',
			'settings.autoLock.title' => '自动锁定',
			'settings.autoLock.subtitle' => ({required Object duration}) => '应用将在 ${duration} 后锁定。',
			'settings.autoLock.options.oneMinute' => '1 分钟',
			'settings.autoLock.options.fiveMinutes' => '5 分钟',
			'settings.autoLock.options.fifteenMinutes' => '15 分钟',
			'settings.autoLock.options.thirtyMinutes' => '30 分钟',
			'settings.language.title' => '语言',
			'settings.language.subtitle' => ({required Object language}) => '当前语言：${language}。',
			'settings.lock.title' => '锁定',
			'settings.lock.subtitle' => '清除当前会话。你需要重新解锁。',
			'settings.confirmPassword.title' => '确认密码',
			'settings.confirmPassword.hint' => '输入你的密码...',
			'veil.setup.passwordHint' => '输入密码以开始...',
			'veil.setup.cta' => '开始吧！',
			'veil.setup.biometricsOptInTitle' => '启用生物识别技术',
			'veil.setup.confirmPasswordHint' => '请再次输入密码...',
			'veil.setup.passwordRulesCta' => '密码规则',
			'veil.setup.passwordRulesTitle' => '你的密码必须包含：',
			'veil.setup.passwordRuleMinLength' => '至少 10 个字符',
			'veil.setup.passwordRuleUppercase' => '至少 1 个大写字母',
			'veil.setup.passwordRuleLowercase' => '至少 1 个小写字母',
			'veil.setup.passwordRuleNumber' => '至少 1 个数字',
			'veil.setup.passwordRuleSpecialChar' => '至少 1 个特殊字符',
			'veil.setup.passwordsDoNotMatch' => '两次输入的密码不一致。',
			'veil.unlock.passwordHint' => '输入你的密码...',
			'veil.unlock.cta' => '解锁',
			'veil.unlock.biometricTooltip' => '生物识别',
			'veil.splash.loading' => '加载中...',
			'veil.errors.passwordRequired' => '密码是必填项。',
			'veil.errors.passwordMissingLetter' => '密码必须至少包含一个字母。',
			'veil.errors.passwordMissingNumber' => '密码必须至少包含一个数字。',
			'veil.errors.invalidPassword' => '密码无效。',
			'veil.errors.biometricUnavailable' => '生物识别认证不可用。',
			'veil.errors.biometricFailed' => '生物识别认证失败。',
			'veil.errors.biometricLockedOut' => '生物识别认证已被暂时锁定。',
			'veil.errors.vaultNotConfigured' => '保险库尚未配置。',
			'veil.errors.encryptedPrivateKeyNotFound' => '未找到加密私钥。',
			'veil.errors.publicKeyNotFound' => '未找到公钥。',
			'veil.errors.vaultLocked' => '保险库已锁定。',
			'veil.errors.passwordMinLength' => '密码至少需要 10 个字符。',
			'veil.errors.passwordMissingUppercase' => '密码必须至少包含一个大写字母。',
			'veil.errors.passwordMissingLowercase' => '密码必须至少包含一个小写字母。',
			'veil.errors.passwordMissingSpecialChar' => '密码必须至少包含一个特殊字符。',
			_ => null,
		};
	}
}
