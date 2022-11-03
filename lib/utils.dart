import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  static void showTopSnackBar(
      BuildContext context,
      String message,
      Color color,
      ) => showSimpleNotification(
    Center(child: Text('Welcomed by WALLPAPERCAGE', style: TextStyle(fontWeight: FontWeight.bold),)),
    duration: Duration(seconds: 5),
    subtitle: Text(message),
    background: color,
  );
}