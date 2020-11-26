//      	                          |     |
//                                  \\_V_//
//                                  \/=|=\/           <---me
//                                   [=v=]
//                                 __\___/_____
//                                /..[  _____  ]
//             bugs              /_  [ [  M /] ]
//               |              /../.[ [ M /@] ]
//               |             <-->[_[ [M /@/] ]
//               v            /../ [.[ [ /@/ ] ]
//       _________________]\ /__/  [_[ [/@/ C] ]
//      <_________________>>0---]  [=\ \@/ C / /
//         ___      ___   ]/000o   /__\ \ C / /
//            \    /              /....\ \_/ /
//         ....\||/....           [___/=\___/
//        .    .  .    .          [...] [...]
//       .      ..      .         [___/ \___]
//       .    0 .. 0    .         <---> <--->
//    /\/\.    .  .    ./\/\      [..]   [..]
//   / / / .../|  |\... \ \ \    _[__]   [__]_
//  / / /       \/       \ \ \  [____>   <____]

import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/model/event.dart';

import 'package:AllinthePlan/screens/dailycalendar.dart';
import 'package:AllinthePlan/screens/monthlycalendar.dart';
import 'package:AllinthePlan/screens/notescreen.dart';
import 'package:AllinthePlan/screens/profilescreen.dart';
import 'package:AllinthePlan/screens/weeklycalendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'signinscreen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/signInscreen/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  _Controller myController;
  var formKey = GlobalKey<FormState>();
  List<Event> events;

  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  void render(passedFunction) => setState(passedFunction);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    events ??= arg['calendarData'];

    return Scaffold(
      appBar: AppBar(
        title: Text("AllInThePlan Home"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
           Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Image.asset('images/homeScreen.jpg'),
              ),
          RaisedButton(
              child: Text("Monthly Calendar"),
              onPressed: myController.monthlyCalendar),
          RaisedButton(
              child: Text("Weekly Calendar"),
              onPressed: myController.weeklyCalendar),
          RaisedButton(
              child: Text("Daily Calendar"),
              onPressed: myController.dailyCalenday),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile Settings'),
              onTap: myController.profileSettings,
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Notes'),
              onTap: myController.noteScreen,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: myController.signOut,
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _HomeScreenState _state;
  _Controller(this._state);

  void signOut() async {
    try {
      await FireBaseController.signOut();
    } catch (e) {
      print('signOut Exception ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void noteScreen() async {
    await Navigator.pushNamed(_state.context, NoteScreen.routeName, arguments: {
      'user': _state.user,
      'notes': await FireBaseController.getNotes(_state.user.email)
    });

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;

    Navigator.pop(_state.context);
  }

  void monthlyCalendar() async {
    await Navigator.pushNamed(_state.context, MonthlyCalendar.routeName,
        arguments: {
          'user': _state.user,
          'calendarData': _state.events,
          'notes': await FireBaseController.getNotes(_state.user.email)
        });

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
  }

  void weeklyCalendar() async {
    await Navigator.pushNamed(_state.context, WeeklyCalendar.routeName,
        arguments: {
          'user': _state.user,
          'calendarData': _state.events,
          'notes': await FireBaseController.getNotes(_state.user.email)
        });

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
  }

  void dailyCalenday() async {
    await Navigator.pushNamed(_state.context, DailyCalendar.routeName,
        arguments: {
          'user': _state.user,
          'calendarData': _state.events,
          'notes': await FireBaseController.getNotes(_state.user.email)
        });

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
  }

  void profileSettings() async {
    await Navigator.pushNamed(
      _state.context,
      ProfileScreen.routeName,
      arguments: _state.user,
    );

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;

    Navigator.pop(_state.context);
  }
}
