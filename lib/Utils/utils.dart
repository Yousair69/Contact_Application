import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class Utils {
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(15),
          message: message,
          flushbarPosition: FlushbarPosition.BOTTOM,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.black,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          duration: Duration(seconds: 3),
          icon: const Icon(
            Icons.error_rounded,
            size: 20,
            color: Colors.white,
          ),
        )..show(context));
  }
}
