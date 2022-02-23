import 'package:flutter/material.dart';

class DialogsProgress {
  static Future<void> showLoadingDialog(
      BuildContext context, bool loading, String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          msg,
                          style: TextStyle(color: Theme.of(context).primaryColorDark),
                        )
                      ]),
                    )
                  ]));
        });
  }
}