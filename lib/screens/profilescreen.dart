import 'dart:io';
import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/screens/notificationsettings.dart';
import 'package:AllinthePlan/screens/ui_settings.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'views/myimageview.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'homeScreen/profileScreen';

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  _Controller myController;
  var formKey = GlobalKey<FormState>();
  User user;
  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  void render(passedFunction) => setState(passedFunction);

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        backgroundColor: Colors.greenAccent[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: myController.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'Change Profile Picture',
                style: TextStyle(
                    fontFamily: 'ShadowsIntoLight',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: myController.imageFile == null
                        ? MyImageView.network(
                            imageUrl: user.photoURL, context: context)
                        : Image.file(myController.imageFile, fit: BoxFit.fill),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      child: PopupMenuButton<String>(
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'Camera',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_camera),
                                Text('Camera'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Gallery',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_library),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: myController.getPicture,
                      ),
                    ),
                  ),
                ],
              ),
              myController.progressMessage == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      myController.progressMessage,
                      style: TextStyle(fontSize: 20.0),
                    ),
              TextFormField(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Display Name',
                ),
                initialValue: user.displayName ?? 'N/A',
                autocorrect: false,
                validator: myController.validatorDisplayName,
                onSaved: myController.onSavedDisplayName,
              ),
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Colors.greenAccent[400],
                ),
                title: Text('Profile Settings'),
                onTap: myController.notificationSettingsScreen,
              ),
              ListTile(
                leading: Icon(
                  Icons.android,
                  color: Colors.greenAccent[400],
                ),
                title: Text('UI Settings'),
                onTap: myController.uiSettingsScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _ProfileScreenState _state;
  File imageFile;
  String displayName;
  String progressMessage;
  _Controller(this._state);

  void getPicture(String src) async {
    try {
      PickedFile _image;
      if (src == 'Camera')
        _image = await ImagePicker().getImage(source: ImageSource.camera);
      else
        _image = await ImagePicker().getImage(source: ImageSource.gallery);

      _state.render(() {
        var file = File(_image.path);
        return imageFile = file;
      });
    } catch (e) {
      DialogBox.info(
        context: _state.context,
        title: 'Image Capture errror',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorDisplayName(String value) {
    if (value.length < 2)
      return 'min 2 chars';
    else
      return null;
  }

  void onSavedDisplayName(String value) {
    this.displayName = value;
  }

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FireBaseController.updateProfile(
        image: imageFile,
        displayName: displayName,
        user: _state.user,
        progressListener: (double percentage) {
          _state.render(() {
            progressMessage = 'uploading ${percentage.toStringAsFixed(1)}';
          });
        },
      );
      Navigator.pop(_state.context);
    } catch (e) {
      DialogBox.info(
        context: _state.context,
        title: 'Profile update error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void notificationSettingsScreen() async {
    await Navigator.pushNamed(
      _state.context,
      NotificationSettingsScreen.routeName,
      arguments: _state.user,
    );

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
  }

  void uiSettingsScreen() async {
    await Navigator.pushNamed(
      _state.context,
      UISettingsScreen.routeName,
      arguments: _state.user,
    );

    await _state.user.reload();
    _state.user = FirebaseAuth.instance.currentUser;
  }
}
