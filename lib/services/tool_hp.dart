import 'package:flutter/material.dart';

//static class, cannot use _Fun
class ToolHp {

  //show msg box
  static void msg(BuildContext context, String info) {

    // set up the button
    Widget okBtn = TextButton(
      child: Text('OK'),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text('My title'),
      content: Text(info),
      actions: [
        okBtn,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //show msg box
  static void ans(BuildContext context, String info, [Function? onYes = null]) {

    // set up the button
    Widget okBtn = TextButton(
      child: Text('Yes'),
      onPressed: () {
        closePop(context);
        if (onYes != null)
          onYes();
      },
    );
    Widget cancelBtn = TextButton(
      child: Text('No'),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(info),
      actions: [
        okBtn,
        cancelBtn,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void openWait(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 150,
            height: 70,
            padding: const EdgeInsets.all(10),
            child: ListTile(
              horizontalTitleGap: 20,
              leading: CircularProgressIndicator(),
              title: Text('Working...'),
            ),
          ),
        );
      },
    );
  }

  static void closeWait(BuildContext context){
    closePop(context);
  }

  static void closePop(BuildContext context){
    Navigator.pop(context);
  }
} //class
