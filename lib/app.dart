import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_gallery/screens/first_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unsplash_gallery/themes.dart';

import 'generated/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.light,
      light: kLightTheme,
      dark: kDarkTheme,
      builder:(theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: const LogIn(),
      ),
    );
  }
}
