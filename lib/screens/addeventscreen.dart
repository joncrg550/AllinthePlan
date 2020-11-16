import 'package:AllinthePlan/model/calendardata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = 'xcalendar/addEventScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddEventScreenState();
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  var formKey = GlobalKey<FormState>();
  User user;
  MyCalendarData myCalendarData;
  _Controller myController;

  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  void render(passedFunction) => setState(passedFunction);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _Controller {
  _AddEventScreenState _state;
  _Controller(this._state);
}
