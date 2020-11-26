import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/model/event.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:AllinthePlan/screens/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DeleteEventScreen extends StatefulWidget {
  static const routeName = "xcalendarscreen/deleteEventScreen";
  @override
  State<StatefulWidget> createState() {
    return _DeleteEventScreenState();
  }
}

class _DeleteEventScreenState extends State<DeleteEventScreen> {
  _Controller myController;
  User user;
  List<Event> events;
  EventDataSource source;

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
    source ??= arg['dataSource'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete events"),
        backgroundColor: Colors.greenAccent[400],
        actions: <Widget>[
          myController.delIndex == null
              ? SizedBox(
                  height: 0.0,
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: myController.delete,
                )
        ],
      ),
      body: events.length == 0
          ? Text(
              'No Events to delete',
              style: TextStyle(
                  fontFamily: 'ShadowsIntoLight',
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) => Container(
                color: myController.delIndex != null &&
                        myController.delIndex == index
                    ? Colors.red[200]
                    : Colors.white,
                child: ListTile(
                  leading: MyImageView.network(
                      imageUrl: events[index].photoURL, context: context),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(events[index].eventTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Start: ${events[index].from}'),
                      Text('End: ${events[index].to}'),
                      Text('location: ${events[index].eventLocation}'),
                      Text('Note:  ${events[index].eventNote}'),
                    ],
                  ),
                  onTap: () => myController.deselect(index),
                  onLongPress: () => myController.select(index),
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _DeleteEventScreenState _state;
  int delIndex;

  _Controller(this._state);

  void select(int index) {
    if (delIndex != null) {
      _state.render(() => delIndex = null);
    }
  }

  void deselect(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void delete() async {
    try {
      Event event = _state.events[delIndex];
      await FireBaseController.deleteEvent(event);
      _state.render(() {
        _state.source.appointments.remove(event);
      });

      _state.source.notifyListeners(
          CalendarDataSourceAction.remove, _state.source.appointments);
      Navigator.pop(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      DialogBox.info(
        context: _state.context,
        title: 'Delete Event error',
        content: Text(e.toString()),
      );
    }
  }
}
