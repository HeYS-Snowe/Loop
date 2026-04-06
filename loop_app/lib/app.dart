import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_app/core/router/app_router.dart';
import 'package:loop_app/core/theme/app_theme.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/settings_provider.dart';

class LoopApp extends ConsumerWidget {
  const LoopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0A0E1A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final settingsState = ref.watch(settingsProvider);
    final locale = settingsState.whenOrNull<Locale?>(
          data: (s) => s.locale,
        ) ??
        const Locale('zh');

    return MaterialApp.router(
      title: 'Loop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      locale: locale,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
    );
  }
}
