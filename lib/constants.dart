import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
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

Future<String?> getDeviceId() async {
  FirebaseMessaging fbm = FirebaseMessaging.instance;
  return fbm.getToken();
}
