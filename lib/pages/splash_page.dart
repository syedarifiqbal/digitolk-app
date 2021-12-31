import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:digitolk_test/constants.dart';
import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/core/storage.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:digitolk_test/pages/home_page.dart';
import 'package:digitolk_test/pages/login_page.dart';
import 'package:digitolk_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  static const String name = 'SPLASH';

  @override
  // _SplashPageState createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  String route = LoginPage.name;

  // @override
  // void initState() {
  //   super.initState();
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    loadUserIfLoggedIn(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Digitolk Test",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadUserIfLoggedIn(BuildContext context) async {
    String? token = await LocalStorage.get('token');
    String? deviceId = await getDeviceId();


    if (token == null) {
      Navigator.pushNamed(context, route);
      return;
    }

    try {
      User user = await AuthService.me(deviceId: deviceId);
      user.toJson().forEach((key, value) => LocalStorage.set(key, "$value"));
      route = HomePage.name;
    } on Exception catch (e) {
      route = LoginPage.name;
    } finally {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}
