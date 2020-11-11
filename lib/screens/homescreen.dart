//      	                          |     |
//                                  \\_V_//
//                                  \/=|=\/
//                                   [=v=]
//                                 __\___/_____
//                                /..[  _____  ]
//                               /_  [ [  M /] ]
//             Bugs             /../.[ [ M /@] ]
//                             <-->[_[ [M /@/] ]
//                            /../ [.[ [ /@/ ] ]
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
import 'package:AllinthePlan/screens/profilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("AllInThePlan Home"),
      ),
      body: Text("All in the plan coming soon "),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile Settings'),
              onTap: myController.profileSettings,
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
