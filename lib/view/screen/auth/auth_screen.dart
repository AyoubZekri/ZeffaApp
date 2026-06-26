import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffa/controller/auth/Logincontroller.dart';
import 'package:zeffa/view/widget/auth/login_form_widget.dart';
import 'package:zeffa/core/constant/Colorapp.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;
  const AuthScreen({super.key, this.initialIsLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late Logincontroller loginController;

  @override
  void initState() {
    super.initState();
    loginController = Get.put(Logincontroller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.backgroundDark
          : AppColor.backgroundLight,
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: LoginFormWidget(),
          ),
        ),
      ),
    );
  }
}
