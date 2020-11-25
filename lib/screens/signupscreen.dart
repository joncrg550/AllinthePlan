import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signInScreen/SignUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
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
        title: Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: myController.validatorEmail,
                onSaved: myController.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                autocorrect: false,
                obscureText: true,
                validator: myController.validatorPassword,
                onSaved: myController.onSavedPassword,
              ),
              RaisedButton(
                onPressed: myController.signUp,
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpScreenState _state;
  _Controller(this._state);
  String email;
  String password;

  String validatorEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid Email';
  }

  void onSavedEmail(String value) {
    this.email = value;
  }

  String validatorPassword(String value) {
    if (value.length < 6)
      return 'Min 6 chars';
    else
      return null;
  }

  void onSavedPassword(String value) {
    this.password = value;
  }

  void signUp() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FireBaseController.signUp(email, password);
      DialogBox.info(
        context: _state.context,
        title: 'Succesfully created',
        content: Text('Your account is created! Go to Sign in'),
      );
    } catch (e) {
      DialogBox.info(
        context: _state.context,
        title: 'Error ',
        content: e.message ?? e.toString(),
      );
    }
  }
}
