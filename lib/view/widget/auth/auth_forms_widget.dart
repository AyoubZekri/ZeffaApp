import 'package:flutter/material.dart';
import 'package:zeffa/view/widget/auth/login_form_widget.dart';
import 'package:zeffa/view/widget/auth/signup_form_widget.dart';

class AuthFormsWidget extends StatelessWidget {
  final bool isLogin;

  const AuthFormsWidget({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return const LoginFormWidget();
  }
}
