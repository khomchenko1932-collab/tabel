import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'core/utils/error_log.dart';
import 'core/widgets/device_frame.dart';
import 'presentation/settings/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Глобальный перехват ошибок: пишем в локальный журнал и не показываем
  // «красный/серый экран» — вместо него аккуратная заглушка.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorLog.record(details.exceptionAsString(), details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorLog.record(error.toString(), stack);
    return true; // ошибка обработана, приложение продолжает работу
  };
  ErrorWidget.builder = (details) => const _FriendlyError();

  await initializeDateFormatting('ru', null);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ProviderScope(child: NarmbApp()));
}

/// Заглушка вместо аварийного экрана Flutter при ошибке отрисовки виджета.
class _FriendlyError extends StatelessWidget {
  const _FriendlyError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.statusSick, size: 40),
          const SizedBox(height: 12),
          Text('Что-то пошло не так на этом экране.\nВернитесь назад и попробуйте снова.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class NarmbApp extends ConsumerStatefulWidget {
  const NarmbApp({super.key});

  @override
  ConsumerState<NarmbApp> createState() => _NarmbAppState();
}

class _NarmbAppState extends ConsumerState<NarmbApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Уходим в фон — блокируем (если блокировка включена).
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      // Не блокируем, если открыт системный выбор файла / шэринг — иначе
      // импорт/экспорт ломается (приложение блокируется под выбором файла).
      if (ref.read(systemPickerActiveProvider)) return;
      final s = ref.read(settingsProvider).value;
      if (s?.lockEnabled ?? false) {
        ref.read(lockedProvider.notifier).lock();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Табель',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => DeviceFrame(child: child ?? const SizedBox()),
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
