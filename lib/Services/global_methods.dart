import 'package:flutter/material.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String err, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(width * 0.008),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: width * 0.050,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.008),
                  child: const Text(
                    'Error Occurred',
                  ),
                )
              ],
            ),
            content: Text(
              err,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.040,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
