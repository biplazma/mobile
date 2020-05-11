import 'package:biplazma/plasma_requests.dart';
import 'package:biplazma/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/app_constant.dart';
import 'package:biplazma/util/app_routes.dart';
import 'donate_plasma.dart';
import 'home_page.dart';
import 'request_plasma.dart';
import 'package:biplazma/util/localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Hive.initFlutter();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(BiPlazma());
}

class BiPlazma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        title: AppConstant.appName,
        theme: ThemeData(
          primaryColor: AppColors.colorPrimary,

          /// A new feature with Flutter 1.17
          /// Automatically adjusts frequency between user interface elements by platform.
          /// Preparation for desktop and web interfaces
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.pageHome: (context) => HomePage(),
          AppRoutes.pageDonatePlasma: (context) => DonatePlasma(),
          AppRoutes.pageRequestPlasma: (context) => RequestPlasma(),
          AppRoutes.pagePlasmaRequests: (context) => PlasmaRequests(),
        },
        supportedLocales: [const Locale('tr'), const Locale('en')],
        localizationsDelegates: [
          AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            debugPrint("*language locale is null!!!");
            return supportedLocales.first;
          }
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          return supportedLocales.first;
        });
  }
}
