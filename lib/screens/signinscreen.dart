import 'package:AllinthePlan/controller/firebasecontroller.dart';

import 'package:AllinthePlan/model/event.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'signupscreen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller myController;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: myController.validatorEmail,
                onSaved: myController.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: myController.validatorPassword,
                onSaved: myController.onSavedPassword,
              ),
              RaisedButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: myController.signIn,
              ),
              SizedBox(
                height: 30.0,
              ),
              FlatButton(
                onPressed: myController.signUp,
                child: Text(
                  'No Account yet? Click here to create.',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    DialogBox.circularProgressStart(_state.context);

    User user;

    try {
      user = await FireBaseController.signIn(email, password);
      print('#DEBUG USER: $user');
    } catch (e) {
      DialogBox.circularProgressEnd(_state.context);
      DialogBox.info(
        context: _state.context,
        title: 'Sign in Error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    try {
      List<Event> eventList = await FireBaseController.getEvents(user.email);

      DialogBox.circularProgressEnd(_state.context);

      Navigator.pushReplacementNamed(_state.context, HomeScreen.routeName,
          arguments: {'user': user, 'calendarData': eventList});
    } catch (e) {
      print(e.toString());
    }
  }

  void signUp() async {
    Navigator.pushNamed(_state.context, SignUpScreen.routeName);
  }

  String validatorEmail(String email) {
    if (email == null || !email.contains("@") || !email.contains(".")) {
      return 'Email must be of format name@host.domain';
    } else
      return null;
  }

  String validatorPassword(String password) {
    if (password == null || password.length < 6) {
      return "Password must be at least 6 characters.";
    } else
      return null;
  }

  void onSavedEmail(String updatedEmail) {
    email = updatedEmail;
  }

  void onSavedPassword(String updatedPassword) {
    password = updatedPassword;
  }
}
