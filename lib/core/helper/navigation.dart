import 'package:flutter/material.dart';

class CustomNavigation {
  static void navigationPush(BuildContext context, Widget target) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => target));
  }

  static void navigationPushReplacement(BuildContext context, Widget target) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: ((context) => target)));
  }

  static void navigateAndRemoveAll(BuildContext context, Widget target) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => target),
      ((route) => false),
    );
  }
}
