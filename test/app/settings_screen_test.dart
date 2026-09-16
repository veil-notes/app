import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:veil/app/locale/app_locale_provider.dart';
import 'package:veil/app/locale/app_locale_service.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:veil/features/notes/application/notes_file_service.dart';
import 'package:veil/features/notes/application/notes_transfer_service.dart';
import 'package:veil/features/notes/domain/notes_import_file.dart';
import 'package:veil/features/notes/domain/notes_transfer_result.dart';
import 'package:veil/features/notes/providers/notes_provider.dart';
import 'package:veil/features/veil/application/veil_controller.dart';
import 'package:veil/features/settings/presentation/screens/change_password_screen.dart';
import 'package:veil/features/settings/presentation/screens/export_notes_screen.dart';
import 'package:veil/features/settings/presentation/screens/import_file_selector.dart';
import 'package:veil/features/settings/presentation/screens/import_notes_screen.dart';
import 'package:veil/features/settings/presentation/screens/settings_screen.dart';
import 'package:veil/features/settings/presentation/screens/settings_feature_scaffold.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/application/veil_session_controller.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/unlocked_state.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';
import 'package:veil/i18n/translations.g.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap({
    required _FakeVeilService service,
    _FakeVeilSessionController? sessionController,
    AsyncValue<bool>? biometricEnabledValue,
    AsyncValue<bool>? canUseBiometricsValue,
    AsyncValue<AutoLockOption>? autoLockOptionValue,
    _FakeVeilController? controller,
    AppLocale initialLocale = AppLocale.en,
    AppLocaleService? localeService,
    NotesTransferService? notesTransferService,
    NotesFileService? notesFileService,
  }) {
    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        GoRoute(
          path: '/settings/change-password',
          builder: (_, _) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '/settings/export-notes',
          builder: (_, _) => const ExportNotesScreen(),
        ),
        GoRoute(
          path: '/settings/import-notes',
          builder: (_, _) => const ImportNotesScreen(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        veilServiceProvider.overrideWithValue(service),
        if (biometricEnabledValue != null)
          isBiometricEnabledProvider.overrideWithValue(biometricEnabledValue)
        else
          isBiometricEnabledProvider.overrideWith(
            (ref) async => service.isBiometricEnabled(),
          ),
        if (canUseBiometricsValue != null)
          canUseBiometricUnlockProvider.overrideWithValue(canUseBiometricsValue)
        else
          canUseBiometricUnlockProvider.overrideWith(
            (ref) async => service.canUseBiometricUnlock(),
          ),
        if (autoLockOptionValue != null)
          autoLockOptionProvider.overrideWithValue(autoLockOptionValue)
        else
          autoLockOptionProvider.overrideWith(
            (ref) async => service.getAutoLockOption(),
          ),
        initialAppLocaleProvider.overrideWithValue(initialLocale),
        appLocaleServiceProvider.overrideWithValue(
          localeService ?? AppLocaleService(_FakeSecureStorageService()),
        ),
        veilSessionControllerProvider.overrideWithValue(
          sessionController ??
              _FakeVeilSessionController(timeout: const Duration(minutes: 5)),
        ),
        veilControllerProvider.overrideWith(
          () => controller ?? _FakeVeilController(service),
        ),
        if (notesTransferService != null)
          notesTransferServiceProvider.overrideWithValue(notesTransferService),
        if (notesFileService != null)
          notesFileServiceProvider.overrideWithValue(notesFileService),
      ],
      child: buildLocalizedRouterApp(
        theme: AppTheme.darkTheme,
        locale: initialLocale,
        routerConfig: router,
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('renders biometrics and auto-lock state from providers', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Biometrics'), findsOneWidget);
      expect(find.text('Enable biometrics for faster unlock.'), findsOneWidget);
      expect(find.text('Auto-lock'), findsOneWidget);
      expect(find.text('Locks the app after 5 minutes.'), findsOneWidget);
    });

    testWidgets('shows the change password option', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Change password'), findsOneWidget);
      expect(
        find.text('Replace the password used to protect your vault.'),
        findsOneWidget,
      );
    });

    testWidgets('shows the about option', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      expect(find.text('About'), findsOneWidget);
      expect(
        find.text('App information and open-source licenses.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'opens each feature as a dedicated screen with back navigation',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );

        await tester.pumpWidget(
          wrap(
            service: service,
            notesFileService: _FakeNotesFileService(importPayload: 'payload'),
          ),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Change password'));
        await tester.pumpAndSettle();
        expect(find.byType(ChangePasswordScreen), findsOneWidget);
        expect(find.byType(BottomSheet), findsNothing);
        _expectFeatureTitleBelowBackButton(tester, 'Change vault password');

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);

        await tester.tap(find.text('Export notes'));
        await tester.pumpAndSettle();
        expect(find.byType(ExportNotesScreen), findsOneWidget);
        expect(find.byType(BottomSheet), findsNothing);
        _expectFeatureTitleBelowBackButton(tester, 'Export notes');

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);

        await tester.tap(find.text('Import notes'));
        await tester.pumpAndSettle();
        expect(find.byType(ImportNotesScreen), findsOneWidget);
        expect(find.byType(ImportFileSelector), findsOneWidget);
        expect(find.byType(BottomSheet), findsNothing);
        _expectFeatureTitleBelowBackButton(tester, 'Import notes');

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
      },
    );

    testWidgets('keeps feature actions reachable in a reduced viewport', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();

      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 400);
      await tester.pump();

      final lastField = find.byType(TextField).at(2);
      await tester.ensureVisible(lastField);
      await tester.tap(lastField);
      await tester.pump();

      final actions = find.byType(SettingsFeatureActionButtons);
      final featureList = find.descendant(
        of: find.byType(SettingsFeatureScaffold),
        matching: find.byType(ListView),
      );
      final featureScrollable = find
          .descendant(of: featureList, matching: find.byType(Scrollable))
          .first;
      expect(featureScrollable, findsOneWidget);
      await tester.drag(featureList, const Offset(0, -260));
      await tester.pump();

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(tester.getRect(actions).bottom, lessThanOrEqualTo(screenHeight));
      expect(tester.takeException(), isNull);
    });

    testWidgets('exports notes with a separate password', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final transferService = _FakeNotesTransferService(
        exportResult: const NotesExport(
          encryptedPayload: 'pgp-payload',
          noteCount: 2,
        ),
      );
      final fileService = _FakeNotesFileService();

      await tester.pumpWidget(
        wrap(
          service: service,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Export notes'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'ExportPass1!');
      await tester.enterText(fields.at(1), 'ExportPass1!');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(transferService.exportPassword, 'ExportPass1!');
      expect(fileService.savedPayload, 'pgp-payload');
      expect(find.text('Exported 2 notes.'), findsOneWidget);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(ExportNotesScreen), findsNothing);
    });

    testWidgets('shows export password validation inline', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Export notes'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'weak');
      await tester.enterText(fields.at(1), 'weak');
      await tester.tap(find.text('Confirm').last);
      await tester.pump();

      expect(
        find.text('Password must have at least 10 characters.'),
        findsOneWidget,
      );
      expect(find.text('Export notes'), findsWidgets);
    });

    testWidgets('does not show success when export saving is cancelled', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final transferService = _FakeNotesTransferService(
        exportResult: const NotesExport(
          encryptedPayload: 'pgp-payload',
          noteCount: 1,
        ),
      );
      final fileService = _FakeNotesFileService(saveResult: false);

      await tester.pumpWidget(
        wrap(
          service: service,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Export notes'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'ExportPass1!');
      await tester.enterText(fields.at(1), 'ExportPass1!');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('imports notes and shows only the imported count', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final transferService = _FakeNotesTransferService(
        importResult: const NotesImportResult(
          importedCount: 3,
          conflictCount: 1,
        ),
      );
      final fileService = _FakeNotesFileService(
        importPayload: 'pgp-payload',
        importFileName: 'notes.pgp',
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Import notes'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();
      expect(find.text('notes.pgp'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'FilePass1!');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(transferService.importPayload, 'pgp-payload');
      expect(transferService.importPassword, 'FilePass1!');
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('3 notes imported.'), findsOneWidget);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(ImportNotesScreen), findsNothing);
      expect(find.text('1 existing IDs received new IDs.'), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets(
      'shows zero in the import success toast when no notes are imported',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );
        final transferService = _FakeNotesTransferService(
          importResult: const NotesImportResult(
            importedCount: 0,
            conflictCount: 0,
          ),
        );
        final fileService = _FakeNotesFileService(importPayload: 'pgp-payload');

        await tester.pumpWidget(
          wrap(
            service: service,
            notesTransferService: transferService,
            notesFileService: fileService,
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.tap(find.text('Import notes'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ImportFileSelector));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'FilePass1!');
        await tester.tap(find.text('Confirm').last);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('0 notes imported.'), findsOneWidget);
        expect(find.byType(SettingsScreen), findsOneWidget);
        expect(find.byType(ImportNotesScreen), findsNothing);
        expect(find.byType(AlertDialog), findsNothing);
      },
    );

    testWidgets('does nothing when importing is cancelled at file selection', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final transferService = _FakeNotesTransferService();
      final fileService = _FakeNotesFileService();

      await tester.pumpWidget(
        wrap(
          service: service,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Import notes'));
      await tester.pumpAndSettle();

      expect(fileService.pickImportFileCalls, 0);
      expect(find.byType(ImportFileSelector), findsOneWidget);
      expect(transferService.importPassword, isNull);
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();
      expect(fileService.pickImportFileCalls, 1);
      expect(find.byType(ImportNotesScreen), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows the selected filename and permits replacing the file', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final fileService = _FakeNotesFileService(
        importFiles: [
          const NotesImportFile(
            encryptedPayload: 'first-payload',
            fileName: 'first-backup.pgp',
          ),
          const NotesImportFile(
            encryptedPayload: 'second-payload',
            fileName: 'second-backup.pgp',
          ),
        ],
      );

      await tester.pumpWidget(
        wrap(service: service, notesFileService: fileService),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Import notes'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();
      expect(find.text('first-backup.pgp'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'FilePass1!');
      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();

      expect(find.text('second-backup.pgp'), findsOneWidget);
      expect(find.text('FilePass1!'), findsNothing);
    });

    testWidgets('does not continue importing after the veil auto-locks', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final controller = _FakeVeilController(service);
      final transferService = _FakeNotesTransferService(
        importResult: const NotesImportResult(
          importedCount: 1,
          conflictCount: 0,
        ),
      );
      final fileService = _FakeNotesFileService(
        importPayload: 'pgp-payload',
        onPickImportFile: controller.lock,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          controller: controller,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Import notes'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();

      expect(controller.lockCalls, 1);
      expect(transferService.importPayload, isNull);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows an error when importing an invalid file', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final transferService = _FakeNotesTransferService(
        importException: const NotesTransferException(
          NotesTransferExceptionCode.invalidFileOrPassword,
        ),
      );
      final fileService = _FakeNotesFileService(importPayload: 'bad-file');

      await tester.pumpWidget(
        wrap(
          service: service,
          notesTransferService: transferService,
          notesFileService: fileService,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Import notes'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ImportFileSelector));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'FilePass1!');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(
        find.text('The file is invalid or the password is incorrect.'),
        findsOneWidget,
      );
    });

    testWidgets('submits the change password form and shows success', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();

      expect(find.text('Change vault password'), findsOneWidget);
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'CurrentPassword1!');
      await tester.enterText(fields.at(1), 'NewPassword2@');
      await tester.enterText(fields.at(2), 'NewPassword2@');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(service.currentPassword, 'CurrentPassword1!');
      expect(service.newPassword, 'NewPassword2@');
      expect(find.text('Password changed successfully.'), findsOneWidget);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(ChangePasswordScreen), findsNothing);
    });

    testWidgets('keeps settings available when changing password fails', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        changePasswordException: const VeilException(
          VeilExceptionCode.invalidPassword,
        ),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'wrong');
      await tester.enterText(fields.at(1), 'NewPassword2@');
      await tester.enterText(fields.at(2), 'NewPassword2@');
      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      expect(find.text('Invalid password.'), findsOneWidget);
      expect(find.byType(ChangePasswordScreen), findsOneWidget);
    });

    testWidgets('does not submit when password confirmation differs', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), 'NewPassword2@');
      await tester.enterText(fields.at(2), 'DifferentPassword3#');
      await tester.tap(find.text('Confirm').last);
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
      expect(service.newPassword, isNull);
    });

    testWidgets('enables biometrics after password confirmation', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Confirm password'), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(service.enabledPassword, '');
      expect(service.biometricEnabled, isTrue);
    });

    testWidgets('shows loading and error states for async settings', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncLoading<bool>(),
          canUseBiometricsValue: AsyncError<bool>(
            Exception('Biometrics unavailable'),
            StackTrace.empty,
          ),
          autoLockOptionValue: AsyncError<AutoLockOption>(
            Exception('Auto-lock failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading biometric settings...'), findsOneWidget);
      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('shows loading state while checking biometric availability', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncData<bool>(true),
          canUseBiometricsValue: const AsyncLoading<bool>(),
        ),
      );
      await tester.pump();

      expect(find.text('Checking biometric availability...'), findsOneWidget);
    });

    testWidgets('shows error state while checking biometric availability', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncData<bool>(true),
          canUseBiometricsValue: AsyncError<bool>(
            Exception('Sensor error'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('shows error state while loading biometric settings', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: AsyncError<bool>(
            Exception('Biometrics failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('disables biometrics through the switch', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: true,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(service.disableBiometricsCalls, 1);
      expect(service.biometricEnabled, isFalse);
    });

    testWidgets('shows error snackbar when enabling biometrics fails', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        enableException: const VeilException(VeilExceptionCode.invalidPassword),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Invalid password.'), findsOneWidget);
    });

    testWidgets(
      'does not enable biometrics when password dialog is cancelled',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );

        await tester.pumpWidget(wrap(service: service));
        await tester.pump();
        await tester.pump();

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(service.enabledPassword, isNull);
        expect(service.biometricEnabled, isFalse);
      },
    );

    testWidgets('shows snackbar when disabling biometrics fails', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: true,
        autoLockOption: AutoLockOption.fiveMinutes,
        disableException: Exception('Disable failed'),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('An unexpected error occurred.'), findsOneWidget);
    });

    testWidgets(
      'selects a new auto-lock option and updates the session timer',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );
        final sessionController = _FakeVeilSessionController(
          timeout: const Duration(minutes: 5),
        );

        await tester.pumpWidget(
          wrap(service: service, sessionController: sessionController),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Auto-lock'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('15 minutes').last);
        await tester.pumpAndSettle();

        expect(service.autoLockOption, AutoLockOption.fifteenMinutes);
        expect(
          sessionController.lastTimeout,
          AutoLockOption.fifteenMinutes.duration,
        );
      },
    );

    testWidgets('shows snackbar when changing auto-lock fails', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        autoLockException: Exception('Could not update auto-lock'),
      );
      final sessionController = _FakeVeilSessionController(
        timeout: const Duration(minutes: 5),
      );

      await tester.pumpWidget(
        wrap(service: service, sessionController: sessionController),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Auto-lock'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15 minutes').last);
      await tester.pumpAndSettle();

      expect(find.text('An unexpected error occurred.'), findsOneWidget);
      expect(sessionController.lastTimeout, isNull);
    });

    testWidgets('locks the app when tapping the lock tile', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final controller = _FakeVeilController(service);

      await tester.pumpWidget(wrap(service: service, controller: controller));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Lock'));
      await tester.pump();

      expect(controller.lockCalls, 1);
    });

    testWidgets('cancels biometric enable silently on biometric cancel', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        enableException: const BiometricCanceledException(),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('changes the app language from the settings bottom sheet', (
      tester,
    ) async {
      final storage = _FakeSecureStorageService();
      final localeService = AppLocaleService(storage);
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          initialLocale: AppLocale.en,
          localeService: localeService,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Current language: English.'), findsOneWidget);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('Portuguese (Brazil)'));
      await tester.pumpAndSettle();

      expect(find.text('Idioma'), findsOneWidget);
      expect(find.text('Idioma atual: Português (Brasil).'), findsOneWidget);
      expect(storage.values[AppLocaleService.localeStorageKey], 'pt-BR');
    });
  });
}

void _expectFeatureTitleBelowBackButton(WidgetTester tester, String title) {
  final featureScaffold = find.byType(SettingsFeatureScaffold);
  final titleFinder = find.descendant(
    of: featureScaffold,
    matching: find.text(title),
  );
  final backButton = find.descendant(
    of: featureScaffold,
    matching: find.byType(BackButton),
  );

  expect(titleFinder, findsOneWidget);
  expect(backButton, findsOneWidget);
  expect(
    tester.getTopLeft(titleFinder).dy,
    greaterThan(tester.getBottomLeft(backButton).dy),
  );
}

class _FakeNotesTransferService implements NotesTransferService {
  final NotesExport? exportResult;
  final NotesImportResult? importResult;
  final Object? importException;

  String? exportPassword;
  String? importPayload;
  String? importPassword;

  _FakeNotesTransferService({
    this.exportResult,
    this.importResult,
    this.importException,
  });

  @override
  Future<NotesExport> exportNotes(String password) async {
    exportPassword = password;
    return exportResult!;
  }

  @override
  Future<NotesImportResult> importNotes({
    required String encryptedPayload,
    required String password,
  }) async {
    importPayload = encryptedPayload;
    importPassword = password;
    if (importException != null) {
      throw importException!;
    }
    return importResult!;
  }
}

class _FakeNotesFileService implements NotesFileService {
  final String? importPayload;
  final String importFileName;
  final List<NotesImportFile?>? importFiles;
  final bool saveResult;
  final void Function()? onPickImportFile;

  String? savedPayload;
  int pickImportFileCalls = 0;

  _FakeNotesFileService({
    this.importPayload,
    this.importFileName = 'notes-backup.pgp',
    this.importFiles,
    this.saveResult = true,
    this.onPickImportFile,
  });

  @override
  Future<NotesImportFile?> pickImportFile() async {
    pickImportFileCalls++;
    onPickImportFile?.call();
    if (importFiles != null && importFiles!.isNotEmpty) {
      return importFiles!.removeAt(0);
    }
    return importPayload == null
        ? null
        : NotesImportFile(
            encryptedPayload: importPayload!,
            fileName: importFileName,
          );
  }

  @override
  Future<bool> saveExportFile(String encryptedPayload) async {
    savedPayload = encryptedPayload;
    return saveResult;
  }
}

class _FakeVeilService implements VeilService {
  bool biometricEnabled;
  bool canUseBiometrics;
  AutoLockOption autoLockOption;
  final Object? enableException;
  final Object? disableException;
  final Object? autoLockException;
  final Object? changePasswordException;

  String? enabledPassword;
  String? currentPassword;
  String? newPassword;
  int disableBiometricsCalls = 0;

  _FakeVeilService({
    required this.biometricEnabled,
    required this.canUseBiometrics,
    required this.autoLockOption,
    this.enableException,
    this.disableException,
    this.autoLockException,
    this.changePasswordException,
  });

  @override
  Future<bool> canUseBiometricUnlock() async => canUseBiometrics;

  @override
  Future<void> create(String password) async {}

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    this.currentPassword = currentPassword;
    this.newPassword = newPassword;
    if (changePasswordException != null) {
      throw changePasswordException!;
    }
  }

  @override
  Future<void> disableBiometricUnlock() async {
    if (disableException != null) {
      throw disableException!;
    }
    disableBiometricsCalls++;
    biometricEnabled = false;
    canUseBiometrics = false;
  }

  @override
  Future<void> enableBiometricUnlock(String password) async {
    enabledPassword = password;
    if (enableException != null) {
      throw enableException!;
    }
    biometricEnabled = true;
    canUseBiometrics = true;
  }

  @override
  Future<AutoLockOption> getAutoLockOption() async => autoLockOption;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<bool> isConfigured() async => true;

  @override
  void lock() {}

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {
    if (autoLockException != null) {
      throw autoLockException!;
    }
    autoLockOption = option;
  }

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => true;
}

class _FakeVeilSessionController extends VeilSessionController {
  Duration? lastTimeout;
  int refreshCalls = 0;

  _FakeVeilSessionController({required super.timeout})
    : super(onTimeout: () {});

  @override
  void refresh() {
    refreshCalls++;
  }

  @override
  void updateTimeout(Duration timeout) {
    lastTimeout = timeout;
  }
}

class _FakeVeilController extends VeilController {
  final _FakeVeilService service;
  int lockCalls = 0;

  _FakeVeilController(this.service);

  @override
  UnlockedState build() => UnlockedState(service);

  @override
  void lock() {
    lockCalls++;
    state = state.onTimeout();
  }
}

class _FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
