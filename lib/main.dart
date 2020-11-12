import 'package:AllinthePlan/screens/dailycalendar.dart';
import 'package:AllinthePlan/screens/monthlycalendar.dart';
import 'package:AllinthePlan/screens/notescreen.dart';
import 'package:AllinthePlan/screens/notificationsettings.dart';
import 'package:AllinthePlan/screens/ui_settings.dart';
import 'package:AllinthePlan/screens/weeklycalendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/homescreen.dart';
import 'screens/profilescreen.dart';
import 'screens/signinscreen.dart';
import 'screens/signupscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(AllInThePlan()));
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
        ProfileScreen.routeName: (context) => ProfileScreen(),
        MonthlyCalendar.routeName: (context) => MonthlyCalendar(),
        WeeklyCalendar.routeName: (context) => WeeklyCalendar(),
        DailyCalendar.routeName: (context) => DailyCalendar(),
        NotificationSettingsScreen.routeName: (context) =>
            NotificationSettingsScreen(),
        UISettingsScreen.routeName: (context) => UISettingsScreen(),
        NoteScreen.routeName: (context) => NoteScreen(),
        //#TODO add screen navs here as added
      },
    );
  }
}
