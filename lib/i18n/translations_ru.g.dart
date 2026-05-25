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
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppRu app = _TranslationsAppRu._(_root);
	@override late final _TranslationsCommonRu common = _TranslationsCommonRu._(_root);
	@override late final _TranslationsNotesRu notes = _TranslationsNotesRu._(_root);
	@override late final _TranslationsSettingsRu settings = _TranslationsSettingsRu._(_root);
	@override late final _TranslationsVeilRu veil = _TranslationsVeilRu._(_root);
}

// Path: app
class _TranslationsAppRu extends TranslationsAppEn {
	_TranslationsAppRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Veil';
}

// Path: common
class _TranslationsCommonRu extends TranslationsCommonEn {
	_TranslationsCommonRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка...';
	@override late final _TranslationsCommonActionsRu actions = _TranslationsCommonActionsRu._(_root);
	@override late final _TranslationsCommonLanguageNamesRu languageNames = _TranslationsCommonLanguageNamesRu._(_root);
	@override late final _TranslationsCommonErrorsRu errors = _TranslationsCommonErrorsRu._(_root);
}

// Path: notes
class _TranslationsNotesRu extends TranslationsNotesEn {
	_TranslationsNotesRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get empty => 'заметок пока нет.';
	@override late final _TranslationsNotesDeleteRu delete = _TranslationsNotesDeleteRu._(_root);
	@override late final _TranslationsNotesEditorRu editor = _TranslationsNotesEditorRu._(_root);
}

// Path: settings
class _TranslationsSettingsRu extends TranslationsSettingsEn {
	_TranslationsSettingsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsBiometricsRu biometrics = _TranslationsSettingsBiometricsRu._(_root);
	@override late final _TranslationsSettingsAutoLockRu autoLock = _TranslationsSettingsAutoLockRu._(_root);
	@override late final _TranslationsSettingsLanguageRu language = _TranslationsSettingsLanguageRu._(_root);
	@override late final _TranslationsSettingsLockRu lock = _TranslationsSettingsLockRu._(_root);
	@override late final _TranslationsSettingsConfirmPasswordRu confirmPassword = _TranslationsSettingsConfirmPasswordRu._(_root);
}

// Path: veil
class _TranslationsVeilRu extends TranslationsVeilEn {
	_TranslationsVeilRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVeilSetupRu setup = _TranslationsVeilSetupRu._(_root);
	@override late final _TranslationsVeilUnlockRu unlock = _TranslationsVeilUnlockRu._(_root);
	@override late final _TranslationsVeilSplashRu splash = _TranslationsVeilSplashRu._(_root);
	@override late final _TranslationsVeilErrorsRu errors = _TranslationsVeilErrorsRu._(_root);
}

// Path: common.actions
class _TranslationsCommonActionsRu extends TranslationsCommonActionsEn {
	_TranslationsCommonActionsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get confirm => 'Подтвердить';
}

// Path: common.languageNames
class _TranslationsCommonLanguageNamesRu extends TranslationsCommonLanguageNamesEn {
	_TranslationsCommonLanguageNamesRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ptBr => 'Португальский (Бразилия)';
	@override String get en => 'Английский';
	@override String get es => 'Испанский';
	@override String get de => 'Немецкий';
	@override String get ru => 'Русский';
	@override String get ko => 'Корейский';
	@override String get zh => 'Китайский (упрощенный)';
	@override String get fr => 'Французский';
	@override String get ja => 'Японский';
}

// Path: common.errors
class _TranslationsCommonErrorsRu extends TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'Произошла непредвиденная ошибка.';
	@override String get loadFailed => 'Не удалось загрузить информацию.';
}

// Path: notes.delete
class _TranslationsNotesDeleteRu extends TranslationsNotesDeleteEn {
	_TranslationsNotesDeleteRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Удалить эту заметку навсегда?';
	@override String get confirm => 'Да, удалить';
	@override String get cancel => 'Нет, оставить';
}

// Path: notes.editor
class _TranslationsNotesEditorRu extends TranslationsNotesEditorEn {
	_TranslationsNotesEditorRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String heading({required Object level}) => 'Заголовок ${level}';
}

// Path: settings.biometrics
class _TranslationsSettingsBiometricsRu extends TranslationsSettingsBiometricsEn {
	_TranslationsSettingsBiometricsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Биометрия';
	@override String get subtitleAvailable => 'Используйте биометрию, чтобы быстрее разблокировать приложение.';
	@override String get subtitleEnabledUnavailable => 'Биометрия включена, но недоступна на этом устройстве.';
	@override String get subtitleDisabledUnavailable => 'Включите биометрию для более быстрой разблокировки.';
	@override String get checkingAvailability => 'Проверка доступности биометрии...';
	@override String get loading => 'Загрузка настроек биометрии...';
}

// Path: settings.autoLock
class _TranslationsSettingsAutoLockRu extends TranslationsSettingsAutoLockEn {
	_TranslationsSettingsAutoLockRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Автоблокировка';
	@override String subtitle({required Object duration}) => 'Блокирует приложение через ${duration}.';
	@override late final _TranslationsSettingsAutoLockOptionsRu options = _TranslationsSettingsAutoLockOptionsRu._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageRu extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Язык';
	@override String subtitle({required Object language}) => 'Текущий язык: ${language}.';
}

// Path: settings.lock
class _TranslationsSettingsLockRu extends TranslationsSettingsLockEn {
	_TranslationsSettingsLockRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Заблокировать';
	@override String get subtitle => 'Сбрасывает текущую сессию. Нужно будет разблокировать снова.';
}

// Path: settings.confirmPassword
class _TranslationsSettingsConfirmPasswordRu extends TranslationsSettingsConfirmPasswordEn {
	_TranslationsSettingsConfirmPasswordRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Подтвердите пароль';
	@override String get hint => 'Введите пароль...';
}

// Path: veil.setup
class _TranslationsVeilSetupRu extends TranslationsVeilSetupEn {
	_TranslationsVeilSetupRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Введите пароль, чтобы начать...';
	@override String get cta => 'Начать!';
	@override String get biometricsOptInTitle => 'Включить биометрию';
	@override String get confirmPasswordHint => 'Подтвердите пароль...';
	@override String get passwordRulesCta => 'Правила пароля';
	@override String get passwordRulesTitle => 'Ваш пароль должен содержать:';
	@override String get passwordRuleMinLength => 'Минимум 10 символов';
	@override String get passwordRuleUppercase => 'Хотя бы 1 заглавную букву';
	@override String get passwordRuleLowercase => 'Хотя бы 1 строчную букву';
	@override String get passwordRuleNumber => 'Хотя бы 1 цифру';
	@override String get passwordRuleSpecialChar => 'Хотя бы 1 специальный символ';
	@override String get passwordsDoNotMatch => 'Пароли не совпадают.';
}

// Path: veil.unlock
class _TranslationsVeilUnlockRu extends TranslationsVeilUnlockEn {
	_TranslationsVeilUnlockRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passwordHint => 'Введите пароль...';
	@override String get cta => 'Разблокировать';
	@override String get biometricTooltip => 'Биометрия';
}

// Path: veil.splash
class _TranslationsVeilSplashRu extends TranslationsVeilSplashEn {
	_TranslationsVeilSplashRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка...';
}

// Path: veil.errors
class _TranslationsVeilErrorsRu extends TranslationsVeilErrorsEn {
	_TranslationsVeilErrorsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passwordRequired => 'Требуется пароль.';
	@override String get passwordMissingLetter => 'Пароль должен содержать хотя бы одну букву.';
	@override String get passwordMissingNumber => 'Пароль должен содержать хотя бы одну цифру.';
	@override String get invalidPassword => 'Неверный пароль.';
	@override String get biometricUnavailable => 'Биометрическая аутентификация недоступна.';
	@override String get biometricFailed => 'Ошибка биометрической аутентификации.';
	@override String get biometricLockedOut => 'Биометрическая аутентификация временно заблокирована.';
	@override String get vaultNotConfigured => 'Хранилище не настроено.';
	@override String get encryptedPrivateKeyNotFound => 'Зашифрованный приватный ключ не найден.';
	@override String get publicKeyNotFound => 'Публичный ключ не найден.';
	@override String get vaultLocked => 'Хранилище заблокировано.';
	@override String get passwordMinLength => 'Пароль должен содержать не менее 10 символов.';
	@override String get passwordMissingUppercase => 'Пароль должен содержать хотя бы одну заглавную букву.';
	@override String get passwordMissingLowercase => 'Пароль должен содержать хотя бы одну строчную букву.';
	@override String get passwordMissingSpecialChar => 'Пароль должен содержать хотя бы один специальный символ.';
}

// Path: settings.autoLock.options
class _TranslationsSettingsAutoLockOptionsRu extends TranslationsSettingsAutoLockOptionsEn {
	_TranslationsSettingsAutoLockOptionsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get oneMinute => '1 минута';
	@override String get fiveMinutes => '5 минут';
	@override String get fifteenMinutes => '15 минут';
	@override String get thirtyMinutes => '30 минут';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Veil',
			'common.loading' => 'Загрузка...',
			'common.actions.cancel' => 'Отмена',
			'common.actions.confirm' => 'Подтвердить',
			'common.languageNames.ptBr' => 'Португальский (Бразилия)',
			'common.languageNames.en' => 'Английский',
			'common.languageNames.es' => 'Испанский',
			'common.languageNames.de' => 'Немецкий',
			'common.languageNames.ru' => 'Русский',
			'common.languageNames.ko' => 'Корейский',
			'common.languageNames.zh' => 'Китайский (упрощенный)',
			'common.languageNames.fr' => 'Французский',
			'common.languageNames.ja' => 'Японский',
			'common.errors.unexpected' => 'Произошла непредвиденная ошибка.',
			'common.errors.loadFailed' => 'Не удалось загрузить информацию.',
			'notes.empty' => 'заметок пока нет.',
			'notes.delete.title' => 'Удалить эту заметку навсегда?',
			'notes.delete.confirm' => 'Да, удалить',
			'notes.delete.cancel' => 'Нет, оставить',
			'notes.editor.heading' => ({required Object level}) => 'Заголовок ${level}',
			'settings.biometrics.title' => 'Биометрия',
			'settings.biometrics.subtitleAvailable' => 'Используйте биометрию, чтобы быстрее разблокировать приложение.',
			'settings.biometrics.subtitleEnabledUnavailable' => 'Биометрия включена, но недоступна на этом устройстве.',
			'settings.biometrics.subtitleDisabledUnavailable' => 'Включите биометрию для более быстрой разблокировки.',
			'settings.biometrics.checkingAvailability' => 'Проверка доступности биометрии...',
			'settings.biometrics.loading' => 'Загрузка настроек биометрии...',
			'settings.autoLock.title' => 'Автоблокировка',
			'settings.autoLock.subtitle' => ({required Object duration}) => 'Блокирует приложение через ${duration}.',
			'settings.autoLock.options.oneMinute' => '1 минута',
			'settings.autoLock.options.fiveMinutes' => '5 минут',
			'settings.autoLock.options.fifteenMinutes' => '15 минут',
			'settings.autoLock.options.thirtyMinutes' => '30 минут',
			'settings.language.title' => 'Язык',
			'settings.language.subtitle' => ({required Object language}) => 'Текущий язык: ${language}.',
			'settings.lock.title' => 'Заблокировать',
			'settings.lock.subtitle' => 'Сбрасывает текущую сессию. Нужно будет разблокировать снова.',
			'settings.confirmPassword.title' => 'Подтвердите пароль',
			'settings.confirmPassword.hint' => 'Введите пароль...',
			'veil.setup.passwordHint' => 'Введите пароль, чтобы начать...',
			'veil.setup.cta' => 'Начать!',
			'veil.setup.biometricsOptInTitle' => 'Включить биометрию',
			'veil.setup.confirmPasswordHint' => 'Подтвердите пароль...',
			'veil.setup.passwordRulesCta' => 'Правила пароля',
			'veil.setup.passwordRulesTitle' => 'Ваш пароль должен содержать:',
			'veil.setup.passwordRuleMinLength' => 'Минимум 10 символов',
			'veil.setup.passwordRuleUppercase' => 'Хотя бы 1 заглавную букву',
			'veil.setup.passwordRuleLowercase' => 'Хотя бы 1 строчную букву',
			'veil.setup.passwordRuleNumber' => 'Хотя бы 1 цифру',
			'veil.setup.passwordRuleSpecialChar' => 'Хотя бы 1 специальный символ',
			'veil.setup.passwordsDoNotMatch' => 'Пароли не совпадают.',
			'veil.unlock.passwordHint' => 'Введите пароль...',
			'veil.unlock.cta' => 'Разблокировать',
			'veil.unlock.biometricTooltip' => 'Биометрия',
			'veil.splash.loading' => 'Загрузка...',
			'veil.errors.passwordRequired' => 'Требуется пароль.',
			'veil.errors.passwordMissingLetter' => 'Пароль должен содержать хотя бы одну букву.',
			'veil.errors.passwordMissingNumber' => 'Пароль должен содержать хотя бы одну цифру.',
			'veil.errors.invalidPassword' => 'Неверный пароль.',
			'veil.errors.biometricUnavailable' => 'Биометрическая аутентификация недоступна.',
			'veil.errors.biometricFailed' => 'Ошибка биометрической аутентификации.',
			'veil.errors.biometricLockedOut' => 'Биометрическая аутентификация временно заблокирована.',
			'veil.errors.vaultNotConfigured' => 'Хранилище не настроено.',
			'veil.errors.encryptedPrivateKeyNotFound' => 'Зашифрованный приватный ключ не найден.',
			'veil.errors.publicKeyNotFound' => 'Публичный ключ не найден.',
			'veil.errors.vaultLocked' => 'Хранилище заблокировано.',
			'veil.errors.passwordMinLength' => 'Пароль должен содержать не менее 10 символов.',
			'veil.errors.passwordMissingUppercase' => 'Пароль должен содержать хотя бы одну заглавную букву.',
			'veil.errors.passwordMissingLowercase' => 'Пароль должен содержать хотя бы одну строчную букву.',
			'veil.errors.passwordMissingSpecialChar' => 'Пароль должен содержать хотя бы один специальный символ.',
			_ => null,
		};
	}
}
