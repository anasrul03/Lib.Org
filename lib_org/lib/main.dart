// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Components/navigationDummy.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Pages/Home_Page.dart';
import 'package:lib_org/Services/Firebase_Auth.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';
import 'package:lib_org/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepo(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.indigo),
        title: 'Flutter Demo',
        home: NavigateDummy(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  setUserId(String? userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    prefs.setString('userId', userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        //Validating the user email & password
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          } else if (snapshot.hasData) {
            print("Directing to Homepage");
            print("User id is " + snapshot.data!.uid);

            // log(snapshot.data!.uid);
            // Store userId in local Phone Storage
            setUserId(snapshot.data!.uid);
            return HomePage();
          } else {
            print("Re-directing to AuthPage");
            double width = MediaQuery.of(context).size.width;
            print("the width is $width");
            return Authentication();
          }
        },
      ),
    );
  }
}
