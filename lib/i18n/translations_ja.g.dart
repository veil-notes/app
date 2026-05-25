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
class TranslationsJa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppJa app = _TranslationsAppJa._(_root);
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsNotesJa notes = _TranslationsNotesJa._(_root);
	@override late final _TranslationsSettingsJa settings = _TranslationsSettingsJa._(_root);
	@override late final _TranslationsVeilJa veil = _TranslationsVeilJa._(_root);
}

// Path: app
class _TranslationsAppJa extends TranslationsAppEn {
	_TranslationsAppJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonJa extends TranslationsCommonEn {
	_TranslationsCommonJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => '読み込み中...';
	@override late final _TranslationsCommonActionsJa actions = _TranslationsCommonActionsJa._(_root);
	@override late final _TranslationsCommonLanguageNamesJa languageNames = _TranslationsCommonLanguageNamesJa._(_root);
	@override late final _TranslationsCommonErrorsJa errors = _TranslationsCommonErrorsJa._(_root);
}

// Path: notes
class _TranslationsNotesJa extends TranslationsNotesEn {
	_TranslationsNotesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get empty => 'まだノートがありません。';
	@override late final _TranslationsNotesDeleteJa delete = _TranslationsNotesDeleteJa._(_root);
	@override late final _TranslationsNotesEditorJa editor = _TranslationsNotesEditorJa._(_root);
}

// Path: settings
class _TranslationsSettingsJa extends TranslationsSettingsEn {
	_TranslationsSettingsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsJa biometrics = _TranslationsSettingsBiometricsJa._(_root);
	@override late final _TranslationsSettingsAutoLockJa autoLock = _TranslationsSettingsAutoLockJa._(_root);
	@override late final _TranslationsSettingsLanguageJa language = _TranslationsSettingsLanguageJa._(_root);
	@override late final _TranslationsSettingsLockJa lock = _TranslationsSettingsLockJa._(_root);
	@override late final _TranslationsSettingsConfirmPasswordJa confirmPassword = _TranslationsSettingsConfirmPasswordJa._(_root);
}

// Path: veil
class _TranslationsVeilJa extends TranslationsVeilEn {
	_TranslationsVeilJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupJa setup = _TranslationsVeilSetupJa._(_root);
	@override late final _TranslationsVeilUnlockJa unlock = _TranslationsVeilUnlockJa._(_root);
	@override late final _TranslationsVeilSplashJa splash = _TranslationsVeilSplashJa._(_root);
	@override late final _TranslationsVeilErrorsJa errors = _TranslationsVeilErrorsJa._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsJa extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get confirm => '確認';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesJa extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'ポルトガル語（ブラジル）';
	@override String get en => '英語';
	@override String get es => 'スペイン語';
	@override String get de => 'ドイツ語';
	@override String get ru => 'ロシア語';
	@override String get ko => '韓国語';
	@override String get zh => '中国語（簡体字）';
	@override String get fr => 'フランス語';
	@override String get ja => '日本語';
}

// Path: common.errors
class _TranslationsCommonErrorsJa extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get unexpected => '予期しないエラーが発生しました。';
	@override String get loadFailed => '情報を読み込めませんでした。';
}

// Path: notes.delete
class _TranslationsNotesDeleteJa extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'このノートを完全に削除しますか？';
	@override String get confirm => 'はい、削除';
	@override String get cancel => 'いいえ、そのままにする';
}

// Path: notes.editor
class _TranslationsNotesEditorJa extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => '見出し ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsJa extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '生体認証';
	@override String get subtitleAvailable => '生体認証を使うと、よりすばやくアプリのロックを解除できます。';
	@override String get subtitleEnabledUnavailable => '生体認証は有効ですが、このデバイスでは利用できません。';
	@override String get subtitleDisabledUnavailable => 'よりすばやく解除するには生体認証を有効にしてください。';
	@override String get checkingAvailability => '生体認証の利用可否を確認中...';
	@override String get loading => '生体認証の設定を読み込み中...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockJa extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '自動ロック';
	@override String subtitle({required Object duration}) => '${duration}後にアプリをロックします。';
	@override late final _TranslationsSettingsAutoLockOptionsJa options = _TranslationsSettingsAutoLockOptionsJa._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageJa extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '言語';
	@override String subtitle({required Object language}) => '現在の言語: ${language}。';
}

// Path: settings.lock
class _TranslationsSettingsLockJa extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ロック';
	@override String get subtitle => '現在のセッションを消去します。再度ロック解除が必要です。';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordJa extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'パスワードを確認';
	@override String get hint => 'パスワードを入力...';
}

// Path: veil.setup
class _TranslationsVeilSetupJa extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => '開始するにはパスワードを入力してください...';
	@override String get cta => '始めましょう！';
	@override String get biometricsOptInTitle => '生体認証を有効にする';
	@override String get confirmPasswordHint => 'パスワードを確認してください...';
	@override String get passwordRulesCta => 'パスワードルール';
	@override String get passwordRulesTitle => 'パスワードは次を満たす必要があります:';
	@override String get passwordRuleMinLength => '10文字以上';
	@override String get passwordRuleUppercase => '英大文字を1文字以上';
	@override String get passwordRuleLowercase => '英小文字を1文字以上';
	@override String get passwordRuleNumber => '数字を1文字以上';
	@override String get passwordRuleSpecialChar => '記号を1文字以上';
	@override String get passwordsDoNotMatch => 'パスワードが一致しません。';
}

// Path: veil.unlock
class _TranslationsVeilUnlockJa extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'パスワードを入力してください...';
	@override String get cta => 'ロック解除';
	@override String get biometricTooltip => '生体認証';
}

// Path: veil.splash
class _TranslationsVeilSplashJa extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => '読み込み中...';
}

// Path: veil.errors
class _TranslationsVeilErrorsJa extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'パスワードは必須です。';
	@override String get passwordMissingLetter => 'パスワードには少なくとも1文字の文字が必要です。';
	@override String get passwordMissingNumber => 'パスワードには少なくとも1つの数字が必要です。';
	@override String get invalidPassword => '無効なパスワードです。';
	@override String get biometricUnavailable => '生体認証は利用できません。';
	@override String get biometricFailed => '生体認証に失敗しました。';
	@override String get biometricLockedOut => '生体認証は一時的にロックされています。';
	@override String get vaultNotConfigured => '保管庫は設定されていません。';
	@override String get encryptedPrivateKeyNotFound => '暗号化された秘密鍵が見つかりません。';
	@override String get publicKeyNotFound => '公開鍵が見つかりません。';
	@override String get vaultLocked => '保管庫はロックされています。';
	@override String get passwordMinLength => 'パスワードは10文字以上である必要があります。';
	@override String get passwordMissingUppercase => 'パスワードには少なくとも1文字の英大文字が必要です。';
	@override String get passwordMissingLowercase => 'パスワードには少なくとも1文字の英小文字が必要です。';
	@override String get passwordMissingSpecialChar => 'パスワードには少なくとも1文字の記号が必要です。';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsJa extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1分';
	@override String get fiveMinutes => '5分';
	@override String get fifteenMinutes => '15分';
	@override String get thirtyMinutes => '30分';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => '読み込み中...',
			'common.actions.cancel' => 'キャンセル',
			'common.actions.confirm' => '確認',
			'common.languageNames.ptBr' => 'ポルトガル語（ブラジル）',
			'common.languageNames.en' => '英語',
			'common.languageNames.es' => 'スペイン語',
			'common.languageNames.de' => 'ドイツ語',
			'common.languageNames.ru' => 'ロシア語',
			'common.languageNames.ko' => '韓国語',
			'common.languageNames.zh' => '中国語（簡体字）',
			'common.languageNames.fr' => 'フランス語',
			'common.languageNames.ja' => '日本語',
			'common.errors.unexpected' => '予期しないエラーが発生しました。',
			'common.errors.loadFailed' => '情報を読み込めませんでした。',
			'notes.empty' => 'まだノートがありません。',
			'notes.delete.title' => 'このノートを完全に削除しますか？',
			'notes.delete.confirm' => 'はい、削除',
			'notes.delete.cancel' => 'いいえ、そのままにする',
			'notes.editor.heading' => ({required Object level}) => '見出し ${level}',
			'settings.biometrics.title' => '生体認証',
			'settings.biometrics.subtitleAvailable' => '生体認証を使うと、よりすばやくアプリのロックを解除できます。',
			'settings.biometrics.subtitleEnabledUnavailable' => '生体認証は有効ですが、このデバイスでは利用できません。',
			'settings.biometrics.subtitleDisabledUnavailable' => 'よりすばやく解除するには生体認証を有効にしてください。',
			'settings.biometrics.checkingAvailability' => '生体認証の利用可否を確認中...',
			'settings.biometrics.loading' => '生体認証の設定を読み込み中...',
			'settings.autoLock.title' => '自動ロック',
			'settings.autoLock.subtitle' => ({required Object duration}) => '${duration}後にアプリをロックします。',
			'settings.autoLock.options.oneMinute' => '1分',
			'settings.autoLock.options.fiveMinutes' => '5分',
			'settings.autoLock.options.fifteenMinutes' => '15分',
			'settings.autoLock.options.thirtyMinutes' => '30分',
			'settings.language.title' => '言語',
			'settings.language.subtitle' => ({required Object language}) => '現在の言語: ${language}。',
			'settings.lock.title' => 'ロック',
			'settings.lock.subtitle' => '現在のセッションを消去します。再度ロック解除が必要です。',
			'settings.confirmPassword.title' => 'パスワードを確認',
			'settings.confirmPassword.hint' => 'パスワードを入力...',
			'veil.setup.passwordHint' => '開始するにはパスワードを入力してください...',
			'veil.setup.cta' => '始めましょう！',
			'veil.setup.biometricsOptInTitle' => '生体認証を有効にする',
			'veil.setup.confirmPasswordHint' => 'パスワードを確認してください...',
			'veil.setup.passwordRulesCta' => 'パスワードルール',
			'veil.setup.passwordRulesTitle' => 'パスワードは次を満たす必要があります:',
			'veil.setup.passwordRuleMinLength' => '10文字以上',
			'veil.setup.passwordRuleUppercase' => '英大文字を1文字以上',
			'veil.setup.passwordRuleLowercase' => '英小文字を1文字以上',
			'veil.setup.passwordRuleNumber' => '数字を1文字以上',
			'veil.setup.passwordRuleSpecialChar' => '記号を1文字以上',
			'veil.setup.passwordsDoNotMatch' => 'パスワードが一致しません。',
			'veil.unlock.passwordHint' => 'パスワードを入力してください...',
			'veil.unlock.cta' => 'ロック解除',
			'veil.unlock.biometricTooltip' => '生体認証',
			'veil.splash.loading' => '読み込み中...',
			'veil.errors.passwordRequired' => 'パスワードは必須です。',
			'veil.errors.passwordMissingLetter' => 'パスワードには少なくとも1文字の文字が必要です。',
			'veil.errors.passwordMissingNumber' => 'パスワードには少なくとも1つの数字が必要です。',
			'veil.errors.invalidPassword' => '無効なパスワードです。',
			'veil.errors.biometricUnavailable' => '生体認証は利用できません。',
			'veil.errors.biometricFailed' => '生体認証に失敗しました。',
			'veil.errors.biometricLockedOut' => '生体認証は一時的にロックされています。',
			'veil.errors.vaultNotConfigured' => '保管庫は設定されていません。',
			'veil.errors.encryptedPrivateKeyNotFound' => '暗号化された秘密鍵が見つかりません。',
			'veil.errors.publicKeyNotFound' => '公開鍵が見つかりません。',
			'veil.errors.vaultLocked' => '保管庫はロックされています。',
			'veil.errors.passwordMinLength' => 'パスワードは10文字以上である必要があります。',
			'veil.errors.passwordMissingUppercase' => 'パスワードには少なくとも1文字の英大文字が必要です。',
			'veil.errors.passwordMissingLowercase' => 'パスワードには少なくとも1文字の英小文字が必要です。',
			'veil.errors.passwordMissingSpecialChar' => 'パスワードには少なくとも1文字の記号が必要です。',
			_ => null,
		};
	}
}
