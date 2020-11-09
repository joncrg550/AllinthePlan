import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //#TODO Firebase.initializeApp();
  runApp(AllInThePlan());
}

class AllinThePlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => Homescreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        //#TODO add screen navs here as added
      },
    );
  }
}
