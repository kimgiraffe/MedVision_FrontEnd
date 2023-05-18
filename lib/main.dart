import 'package:flutter/material.dart';
import 'MedVision_theme.dart';
import 'package:my_app/pages/LoginPage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  initializeDateFormatting('ko_KR', '').then((_) =>
  runApp(const MedVision()));
}

class MedVision extends StatelessWidget {
  const MedVision({Key? key}) : super (key: key);
  @override
  Widget build(BuildContext context) {
    final theme = MedVisionTheme.light();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: theme,
      title: 'MedVision',
      //home: const Home(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if(settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}