import 'package:flutter/material.dart';

class DialogBox {
  static void circularProgressStart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  static void circularProgressEnd(BuildContext context) {
    Navigator.pop(context);
  }

  static void info(
      {BuildContext context, String title, String content, String photoUrl}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: <Widget>[
              photoUrl == null
                  ? SizedBox(
                      width: 0.0,
                    )
                  : Image.network(photoUrl),
              Text(content)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
