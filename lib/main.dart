import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:zeffa/Bindings/Initialbindings.dart';
import 'package:zeffa/core/localizations/ChengeLocal.dart';
import 'package:zeffa/core/localizations/Translation.dart';
import 'package:zeffa/core/services/Services.dart';
import 'package:zeffa/core/constant/AppTheme.dart';
import 'package:zeffa/routes.dart';
import 'core/functions/callback.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialServices();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  final syncForeground = SyncForegroundService();
  await syncForeground.start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    Myservices myservices = Get.find<Myservices>();
    Get.put(RefreshService());
    
    bool isDarkMode = myservices.sharedPreferences!.getBool("isDarkMode") ?? false;

    return GetMaterialApp(
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      navigatorObservers: [routeObserver],
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Zeffa',
      theme: controller.themeData,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: controller.language,
      initialBinding: Initialbindings(),
      getPages: routes,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
