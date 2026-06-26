import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/Services.dart';
import '../../view/screen/Settings/Notifications.dart';
import '../../view/screen/ReservationsScreen.dart';
import '../../view/screen/EventTypesScreen.dart';
import '../../view/screen/DishCategoriesScreen.dart';
import '../../view/screen/DishesScreen.dart';
import '../../view/screen/CalendarScreen.dart';
import '../../view/screen/ExpensesScreen.dart';
import '../../view/screen/NotesScreen.dart';
import '../../view/screen/TermsScreen.dart';
import '../../view/screen/ServicesScreen.dart';
import '../../view/screen/RolesScreen.dart';
import '../../view/screen/SubUsersScreen.dart';

import 'CalendarController.dart';
import 'DishCategoriesController.dart';
import 'DishesController.dart';
import 'EventTypesController.dart';
import 'ExpensesController.dart';
import 'NotesController.dart';
import 'NotificationsController.dart';
import 'Reservationscontroller.dart';
import 'TermsController.dart';
import 'ServicesController.dart';
import 'RolesController.dart';
import 'SubUsersController.dart';

class Siedbarcontroller extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  bool issobscureText = true;
  bool issobscureText2 = true;
  RxInt currentPage = 0.obs;
  RxnInt expandedIndex = RxnInt();
  RxnInt currentSubIndex = RxnInt();
  Rx<Widget Function()?> currentSubPage = Rx<Widget Function()?>(null);
  Myservices myservices = Get.find();
  String get type => myservices.sharedPreferences!.getString("type") ?? "";
  
  List<String> get permissions {
    String? permsStr = myservices.sharedPreferences!.getString("permissions");
    if (permsStr != null && permsStr.isNotEmpty) {
      try {
        List<dynamic> decoded = jsonDecode(permsStr);
        return decoded.map((e) => e.toString()).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  bool hasPermission(String screenName) {
    if (type != "partial") return true;
    return permissions.contains(screenName);
  }

  RxBool isDarkMode = false.obs;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    myservices.sharedPreferences!.setBool("isDarkMode", isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  List<Map<String, dynamic>> get screens {
    int? currentStatus = myservices.sharedPreferences!.getInt("status");
    return [
      if (hasPermission('calendar'))
        {
          'name': 'calendar',
          'icon': Icons.calendar_month_rounded,
          'page': () => const CalendarScreen(),
          'subPages': [],
        },
      if (hasPermission('reservations'))
        {
          'name': 'reservations',
          'icon': Icons.calendar_today_rounded,
          'page': () => const ReservationsScreen(),
          'subPages': [],
        },
      if (hasPermission('event_types'))
        {
          'name': 'event_types',
          'icon': Icons.category_rounded,
          'page': () => const EventTypesScreen(),
          'subPages': [],
        },
      if (hasPermission('dish_categories'))
        {
          'name': 'dish_categories',
          'icon': Icons.restaurant_menu_rounded,
          'page': () => const DishCategoriesScreen(),
          'subPages': [],
        },
      if (hasPermission('dishes'))
        {
          'name': 'dishes',
          'icon': Icons.flatware_rounded,
          'page': () => const DishesScreen(),
          'subPages': [],
        },
      if (hasPermission('expenses'))
        {
          'name': 'expenses',
          'icon': Icons.account_balance_wallet_outlined,
          'page': () => const ExpensesScreen(),
          'subPages': [],
        },
      if (hasPermission('additional_services'))
        {
          'name': 'additional_services',
          'icon': Icons.room_service_outlined,
          'page': () => const ServicesScreen(),
          'subPages': [],
        },
      if (hasPermission('sub_users') && currentStatus != 2)
        {
          'name': 'sub_users',
          'icon': Icons.people_outline_rounded,
          'page': () => const SubUsersScreen(),
          'subPages': [],
        },
      if (hasPermission('notes'))
        {
          'name': 'notes',
          'icon': Icons.notes_rounded,
          'page': () => const NotesScreen(),
          'subPages': [],
        },
      if (hasPermission('terms'))
        {
          'name': 'terms',
          'icon': Icons.gavel_rounded,
          'page': () => const TermsScreen(),
          'subPages': [],
        },
      // {
      //   'name': 'notifications',
      //   'icon': Icons.notifications_none_outlined,
      //   'page': () => const NotificationsScreen(),
      // },
      if (hasPermission('roles_permissions') && currentStatus != 2)
        {
          'name': 'roles_permissions',
          'icon': Icons.admin_panel_settings_outlined,
          'page': () => const RolesScreen(),
          'subPages': [],
        },
    ];
  }
  void _deleteAllControllers() {
    Get.delete<CalendarController>();
    Get.delete<Reservationscontroller>();
    Get.delete<EventTypesController>();
    Get.delete<DishCategoriesController>();
    Get.delete<DishesController>();
    Get.delete<ExpensesController>();
    Get.delete<NotesController>();
    Get.delete<TermsController>();
    Get.delete<NotificationsController>();
    Get.delete<ServicesController>();
    Get.delete<RolesController>();
    Get.delete<SubUsersController>();
  }

  void changePage(int index) {
    _deleteAllControllers();
    currentPage.value = index;
    currentSubIndex.value = null;
    currentSubPage.value = null;
    update();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
    update();
  }

  void changeSubPage(int subIndex, Widget Function() page) {
    _deleteAllControllers();
    currentSubIndex.value = subIndex;
    currentSubPage.value = page;
    update();
  }

  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  void showPassword2() {
    issobscureText2 = issobscureText2 == true ? false : true;
    update();
  }

  void logout() async {
    myservices.sharedPreferences!.clear();
    Get.offAllNamed('/login'); // Make sure this matches Approutes.Login
  }

  RxString name = "".obs;
  RxString emailofuser = "".obs;
  RxString hallname = "".obs;
  RxString roleName = "".obs;
  RxnString imagePath = RxnString();
  RxnInt status = RxnInt();
  RxnString dateExperiment = RxnString();

  void loadProfileData() {
    name.value = myservices.sharedPreferences!.getString("username") ?? "";
    emailofuser.value = myservices.sharedPreferences!.getString("email") ?? "";
    hallname.value = myservices.sharedPreferences!.getString("hallname") ?? "";
    roleName.value = myservices.sharedPreferences!.getString("role_name") ?? "";
    imagePath.value = myservices.sharedPreferences!.getString("image");
    status.value = myservices.sharedPreferences!.getInt("status");
    dateExperiment.value = myservices.sharedPreferences!.getString(
      "date_experiment",
    );
    update();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    isDarkMode.value =
        myservices.sharedPreferences!.getBool("isDarkMode") ?? false;
    final refreshService = Get.find<RefreshService>();
    ever(refreshService.refreshTrigger, (_) {
      loadProfileData();
    });
    Get.find<RefreshService>().fire();
    super.onInit();
  }
}
