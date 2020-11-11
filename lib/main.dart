import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/homescreen.dart';
import 'screens/signinscreen.dart';
import 'screens/signupscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(AllInThePlan());
}

class AllInThePlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        //#TODO add screen navs here as added
      },
    );
  }
}
