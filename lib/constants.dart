import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setStatusBarColor({color = Colors.white}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarBrightness: Brightness.light,
      // systemNavigationBarColor: Colors.red,
      // systemStatusBarContrastEnforced: true,
    ),
  );
}
