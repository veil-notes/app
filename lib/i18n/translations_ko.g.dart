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
class TranslationsKo extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKo({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsKo _root = this; // ignore: unused_field

	@override 
	TranslationsKo $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKo(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppKo app = _TranslationsAppKo._(_root);
	@override late final _TranslationsCommonKo common = _TranslationsCommonKo._(_root);
	@override late final _TranslationsNotesKo notes = _TranslationsNotesKo._(_root);
	@override late final _TranslationsSettingsKo settings = _TranslationsSettingsKo._(_root);
	@override late final _TranslationsVeilKo veil = _TranslationsVeilKo._(_root);
}

// Path: app
class _TranslationsAppKo extends TranslationsAppEn {
	_TranslationsAppKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonKo extends TranslationsCommonEn {
	_TranslationsCommonKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '불러오는 중...';
	@override late final _TranslationsCommonActionsKo actions = _TranslationsCommonActionsKo._(_root);
	@override late final _TranslationsCommonLanguageNamesKo languageNames = _TranslationsCommonLanguageNamesKo._(_root);
	@override late final _TranslationsCommonErrorsKo errors = _TranslationsCommonErrorsKo._(_root);
}

// Path: notes
class _TranslationsNotesKo extends TranslationsNotesEn {
	_TranslationsNotesKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get empty => '아직 노트가 없습니다.';
	@override late final _TranslationsNotesDeleteKo delete = _TranslationsNotesDeleteKo._(_root);
	@override late final _TranslationsNotesEditorKo editor = _TranslationsNotesEditorKo._(_root);
}

// Path: settings
class _TranslationsSettingsKo extends TranslationsSettingsEn {
	_TranslationsSettingsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsKo biometrics = _TranslationsSettingsBiometricsKo._(_root);
	@override late final _TranslationsSettingsAutoLockKo autoLock = _TranslationsSettingsAutoLockKo._(_root);
	@override late final _TranslationsSettingsLanguageKo language = _TranslationsSettingsLanguageKo._(_root);
	@override late final _TranslationsSettingsLockKo lock = _TranslationsSettingsLockKo._(_root);
	@override late final _TranslationsSettingsConfirmPasswordKo confirmPassword = _TranslationsSettingsConfirmPasswordKo._(_root);
}

// Path: veil
class _TranslationsVeilKo extends TranslationsVeilEn {
	_TranslationsVeilKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupKo setup = _TranslationsVeilSetupKo._(_root);
	@override late final _TranslationsVeilUnlockKo unlock = _TranslationsVeilUnlockKo._(_root);
	@override late final _TranslationsVeilSplashKo splash = _TranslationsVeilSplashKo._(_root);
	@override late final _TranslationsVeilErrorsKo errors = _TranslationsVeilErrorsKo._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsKo extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get confirm => '확인';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesKo extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get ptBr => '포르투갈어(브라질)';
	@override String get en => '영어';
	@override String get es => '스페인어';
	@override String get de => '독일어';
	@override String get ru => '러시아어';
	@override String get ko => '한국어';
	@override String get zh => '중국어(간체)';
	@override String get fr => '프랑스어';
	@override String get ja => '일본어';
}

// Path: common.errors
class _TranslationsCommonErrorsKo extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get unexpected => '예기치 않은 오류가 발생했습니다.';
	@override String get loadFailed => '정보를 불러오지 못했습니다.';
}

// Path: notes.delete
class _TranslationsNotesDeleteKo extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '이 노트를 영구적으로 삭제할까요?';
	@override String get confirm => '예, 삭제';
	@override String get cancel => '아니요, 유지';
}

// Path: notes.editor
class _TranslationsNotesEditorKo extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => '제목 ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsKo extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '생체 인증';
	@override String get subtitleAvailable => '생체 인증으로 앱을 더 빠르게 잠금 해제하세요.';
	@override String get subtitleEnabledUnavailable => '생체 인증이 활성화되어 있지만 이 기기에서는 사용할 수 없습니다.';
	@override String get subtitleDisabledUnavailable => '더 빠르게 잠금 해제하려면 생체 인증을 활성화하세요.';
	@override String get checkingAvailability => '생체 인증 사용 가능 여부를 확인하는 중...';
	@override String get loading => '생체 인증 설정을 불러오는 중...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockKo extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '자동 잠금';
	@override String subtitle({required Object duration}) => '${duration} 후 앱을 잠급니다.';
	@override late final _TranslationsSettingsAutoLockOptionsKo options = _TranslationsSettingsAutoLockOptionsKo._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageKo extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '언어';
	@override String subtitle({required Object language}) => '현재 언어: ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockKo extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '잠그기';
	@override String get subtitle => '현재 세션을 지웁니다. 다시 잠금 해제해야 합니다.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordKo extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '비밀번호 확인';
	@override String get hint => '비밀번호를 입력하세요...';
}

// Path: veil.setup
class _TranslationsVeilSetupKo extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => '시작하려면 비밀번호를 입력하세요...';
	@override String get cta => '시작하기!';
	@override String get biometricsOptInTitle => '생체인식 활성화';
}

// Path: veil.unlock
class _TranslationsVeilUnlockKo extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => '비밀번호를 입력하세요...';
	@override String get cta => '잠금 해제';
	@override String get biometricTooltip => '생체 인증';
}

// Path: veil.splash
class _TranslationsVeilSplashKo extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '불러오는 중...';
}

// Path: veil.errors
class _TranslationsVeilErrorsKo extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => '비밀번호가 필요합니다.';
	@override String get passwordMinLength => '비밀번호는 최소 8자여야 합니다.';
	@override String get passwordMissingLetter => '비밀번호에 문자가 하나 이상 포함되어야 합니다.';
	@override String get passwordMissingNumber => '비밀번호에 숫자가 하나 이상 포함되어야 합니다.';
	@override String get invalidPassword => '잘못된 비밀번호입니다.';
	@override String get biometricUnavailable => '생체 인증을 사용할 수 없습니다.';
	@override String get biometricFailed => '생체 인증에 실패했습니다.';
	@override String get biometricLockedOut => '생체 인증이 일시적으로 잠겨 있습니다.';
	@override String get vaultNotConfigured => '볼트가 설정되지 않았습니다.';
	@override String get encryptedPrivateKeyNotFound => '암호화된 개인 키를 찾을 수 없습니다.';
	@override String get publicKeyNotFound => '공개 키를 찾을 수 없습니다.';
	@override String get vaultLocked => '볼트가 잠겨 있습니다.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsKo extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsKo._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1분';
	@override String get fiveMinutes => '5분';
	@override String get fifteenMinutes => '15분';
	@override String get thirtyMinutes => '30분';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => '불러오는 중...',
			'common.actions.cancel' => '취소',
			'common.actions.confirm' => '확인',
			'common.languageNames.ptBr' => '포르투갈어(브라질)',
			'common.languageNames.en' => '영어',
			'common.languageNames.es' => '스페인어',
			'common.languageNames.de' => '독일어',
			'common.languageNames.ru' => '러시아어',
			'common.languageNames.ko' => '한국어',
			'common.languageNames.zh' => '중국어(간체)',
			'common.languageNames.fr' => '프랑스어',
			'common.languageNames.ja' => '일본어',
			'common.errors.unexpected' => '예기치 않은 오류가 발생했습니다.',
			'common.errors.loadFailed' => '정보를 불러오지 못했습니다.',
			'notes.empty' => '아직 노트가 없습니다.',
			'notes.delete.title' => '이 노트를 영구적으로 삭제할까요?',
			'notes.delete.confirm' => '예, 삭제',
			'notes.delete.cancel' => '아니요, 유지',
			'notes.editor.heading' => ({required Object level}) => '제목 ${level}',
			'settings.biometrics.title' => '생체 인증',
			'settings.biometrics.subtitleAvailable' => '생체 인증으로 앱을 더 빠르게 잠금 해제하세요.',
			'settings.biometrics.subtitleEnabledUnavailable' => '생체 인증이 활성화되어 있지만 이 기기에서는 사용할 수 없습니다.',
			'settings.biometrics.subtitleDisabledUnavailable' => '더 빠르게 잠금 해제하려면 생체 인증을 활성화하세요.',
			'settings.biometrics.checkingAvailability' => '생체 인증 사용 가능 여부를 확인하는 중...',
			'settings.biometrics.loading' => '생체 인증 설정을 불러오는 중...',
			'settings.autoLock.title' => '자동 잠금',
			'settings.autoLock.subtitle' => ({required Object duration}) => '${duration} 후 앱을 잠급니다.',
			'settings.autoLock.options.oneMinute' => '1분',
			'settings.autoLock.options.fiveMinutes' => '5분',
			'settings.autoLock.options.fifteenMinutes' => '15분',
			'settings.autoLock.options.thirtyMinutes' => '30분',
			'settings.language.title' => '언어',
			'settings.language.subtitle' => ({required Object language}) => '현재 언어: ${language}.',
			'settings.lock.title' => '잠그기',
			'settings.lock.subtitle' => '현재 세션을 지웁니다. 다시 잠금 해제해야 합니다.',
			'settings.confirmPassword.title' => '비밀번호 확인',
			'settings.confirmPassword.hint' => '비밀번호를 입력하세요...',
			'veil.setup.passwordHint' => '시작하려면 비밀번호를 입력하세요...',
			'veil.setup.cta' => '시작하기!',
			'veil.setup.biometricsOptInTitle' => '생체인식 활성화',
			'veil.unlock.passwordHint' => '비밀번호를 입력하세요...',
			'veil.unlock.cta' => '잠금 해제',
			'veil.unlock.biometricTooltip' => '생체 인증',
			'veil.splash.loading' => '불러오는 중...',
			'veil.errors.passwordRequired' => '비밀번호가 필요합니다.',
			'veil.errors.passwordMinLength' => '비밀번호는 최소 8자여야 합니다.',
			'veil.errors.passwordMissingLetter' => '비밀번호에 문자가 하나 이상 포함되어야 합니다.',
			'veil.errors.passwordMissingNumber' => '비밀번호에 숫자가 하나 이상 포함되어야 합니다.',
			'veil.errors.invalidPassword' => '잘못된 비밀번호입니다.',
			'veil.errors.biometricUnavailable' => '생체 인증을 사용할 수 없습니다.',
			'veil.errors.biometricFailed' => '생체 인증에 실패했습니다.',
			'veil.errors.biometricLockedOut' => '생체 인증이 일시적으로 잠겨 있습니다.',
			'veil.errors.vaultNotConfigured' => '볼트가 설정되지 않았습니다.',
			'veil.errors.encryptedPrivateKeyNotFound' => '암호화된 개인 키를 찾을 수 없습니다.',
			'veil.errors.publicKeyNotFound' => '공개 키를 찾을 수 없습니다.',
			'veil.errors.vaultLocked' => '볼트가 잠겨 있습니다.',
			_ => null,
		};
	}
}
