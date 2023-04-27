import 'package:flutter/material.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Firebase_Auth/SignUp_Page.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLogged = true; // change to true if u want to start at login page
  @override
  Widget build(BuildContext context) => isLogged
      ? LoginPage(
          toSignUpPage: toggle,
        )
      : SignUpPage(
          toLoginPage: toggle,
        );

  void toggle() => setState(() => isLogged = !isLogged);
}
