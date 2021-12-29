import 'package:digitolk_test/constants.dart';
import 'package:digitolk_test/pages/home_page.dart';
import 'package:digitolk_test/pages/login_page.dart';
import 'package:digitolk_test/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setStatusBarColor();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              // systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white
          // ),
          // theme: ThemeData(fontFamily: "Khula"
          // backgroundColor: Colors.yellowAccent,
          // primarySwatch: Colors.blue,
          // scaffoldBackgroundColor: Color.fromARGB(1, 255, 255, 255),
          ),
      initialRoute: SplashPage.name,
      routes: {
        LoginPage.name: (context) => const LoginPage(),
        HomePage.name: (context) => const HomePage(),
        SplashPage.name: (context) => SplashPage(),
      },
    );
  }
}
