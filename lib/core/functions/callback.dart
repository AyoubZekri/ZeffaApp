import '../../controller/SiedBarController.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../class/SyncServer.dart';
import '../services/Services.dart';
import 'CheckInternat.dart';

class SyncForegroundService {
  final SyncService syncService = SyncService();
  Timer? _timer;

  Future<void> start() async {
    syncService.initSyncListener(); // هذا السطر يجعل المزامنة تعمل عند عودة الإنترنت

    // Browser: the connectivity event doesn't fire on open like on phone /
    // desktop, so sync right away when already logged in
    if (kIsWeb &&
        (Get.find<Myservices>().sharedPreferences?.getString("token") ?? "")
            .isNotEmpty) {
      syncService.syncAll().then((_) {
        // Reload the open page with the synced data
        if (Get.isRegistered<Siedbarcontroller>()) {
          Get.find<Siedbarcontroller>().pageReloadTick.value++;
        }
      });
    }

    if (!kIsWeb && Platform.isAndroid) {
      await AndroidAlarmManager.initialize();
      AndroidAlarmManager.periodic(
        const Duration(minutes: 15),
        123,
        syncCallback,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    } else {
      // هذا السطر يجعل المزامنة تعمل كل 15 دقيقة على ويندوز
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(minutes: 15), (_) async {
        if (await checkInternet()) {
          print("🔔 تنفيذ مهمة مزامنة دورية (foreground timer)...");
          await syncService.syncAll();
        }
      });
    }
  }

  void stop() {
    if (!kIsWeb && Platform.isAndroid) {
      AndroidAlarmManager.cancel(123);
      print("AlarmManager stopped");
    } else {
      _timer?.cancel();
      _timer = null;
      print("Timer stopped");
    }
  }
}
@pragma('vm:entry-point')
void syncCallback() async {
  await initialServices();
  if (await checkInternet()) {
    print("🔔 تنفيذ مهمة مزامنة دورية (background isolate)...");
    final sync = SyncService();
    await sync.syncAll();
  }

  print("SYNC 🔥 running in background isolate");
}
