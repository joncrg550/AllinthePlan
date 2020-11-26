import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/model/note.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  static const routeName = 'homePage/noteScreen';
  @override
  State<StatefulWidget> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<NoteScreen> {
  _Controller myController;
  User user;
  var formKey = GlobalKey<FormState>();
  List<Note> notes;

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
    notes ??= arg['notes'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: Text("Note Screen"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: myController.delete,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              notes.length == 0
                  ? Text("No Notes")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        color: myController.delIndex != null &&
                                myController.delIndex == index
                            ? Colors.red[200]
                            : Colors.white,
                        child: ListTile(
                          subtitle: Text(notes[index].note),
                          title: Text(notes[index].title),
                          onTap: () => myController.onTap(index),
                          onLongPress: () => myController.onLongPress(index),
                        ),
                      ),
                      //#TODO build a view for the notes we make
                    ),
              TextFormField(
                decoration: InputDecoration(hintText: "Note title"),
                keyboardType: TextInputType.text,
                autocorrect: true,
                validator: myController.validatorTitle,
                onSaved: myController.onSavedTitle,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter a note here!"),
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                validator: myController.validatorNote,
                onSaved: myController.onSavedNote,
              ),
              RaisedButton(
                color: Colors.greenAccent[400],
                child: Text(
                  "Save Note",
                  style: TextStyle(
                      fontFamily: 'ShadowsIntoLight',
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.black),
                ),
                onPressed: myController.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _NoteScreenState _state;
  _Controller(this._state);
  String _title;
  String _note;
  int delIndex;

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void onTap(int index) {
    if (delIndex != null) {
      _state.render(() => delIndex = null);
    }
  }

  void delete() async {
    try {
      Note note = _state.notes[delIndex];
      await FireBaseController.deleteNote(note);
      _state.render(() {
        _state.notes.removeAt(delIndex);
      });
    } catch (e) {
      DialogBox.info(
        context: _state.context,
        title: 'Delete note error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorNote(String note) {
    if (note == null || note.length < 3) {
      return "Note must be at least three characters";
    } else
      return null;
  }

  void onSavedNote(String note) {
    _note = note;
  }

  String validatorTitle(String title) {
    bool alreadyExisting = false;
    if (title == null || title.length < 3) {
      return "Title must be at least three characters";
    } else
      _state.notes.forEach((element) {
        String value = element.title.toString();
        if (title == value) {
          alreadyExisting = true;
        }
      });

    if (alreadyExisting)
      return "This title is already used";
    else
      return null;
  }

  void onSavedTitle(String title) {
    _title = title;
  }

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    var note = Note(title: _title, note: _note, createdBy: _state.user.email);
    await FireBaseController.addNote(note);

    _state.render(() {
      _state.notes.add(note);
    });
    //upload note to firebase
  }
}
