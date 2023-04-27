import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  VoidCallback? toLoginPage;
  SignUpPage({super.key, this.toLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
