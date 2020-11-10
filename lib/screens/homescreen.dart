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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AllInThePlan Home"),
      ),
      body: Text("All in the plan coming soon "),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
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
}
