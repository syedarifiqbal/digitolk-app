import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class Helper {
  static void progressAlert(
      {required BuildContext context, String? message = "Logging you in..."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  height: message != null ? 20 : 0,
                ),
                message != null ? new Text(message) : SizedBox(),
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  static void reminderAlert({
    required BuildContext context,
    required String message,
    required Null Function() onRemindMeAgain,
    required Null Function() onSkip,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Reminder",
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(
                  height: message != null ? 20 : 0,
                ),
                message != null ? new Text(message) : SizedBox(),
                SizedBox(
                  height: message != null ? 20 : 0,
                ),
                PrimaryButton(title: "Remind me again", onTab: onRemindMeAgain),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: onSkip,
                  child: const Text("Skip"),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }
}
