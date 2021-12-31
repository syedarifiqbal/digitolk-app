import 'package:digitolk_test/constants.dart';
import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/core/helper.dart';
import 'package:digitolk_test/core/storage.dart';
import 'package:digitolk_test/core/toastr.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:digitolk_test/pages/home_page.dart';
import 'package:digitolk_test/services/auth_service.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pusher_client/pusher_client.dart';

class LoginPage extends StatefulWidget {
  static const String name = "LOG_IN";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PusherClient pusher;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = "arifiqbal@outlook.com";
  String password = "Admin123";
  bool remember = false;
  bool _isObscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Log In",
                    style: TextStyle(
                      // color: PrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      fillColor: Color(0xffF6F6F6),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE8E8E8), width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE8E8E8),
                        ),
                      ),
                    ),
                    onChanged: (value) => email = value,
                    validator: RequiredValidator(
                      errorText: "Email is required.",
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: password,
                    onChanged: (value) => password = value,
                    obscureText: _isObscure,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      suffix: GestureDetector(
                        onTap: () => setState(() {
                          _isObscure = !_isObscure;
                        }),
                        child: Text(_isObscure ? "Show" : "Hide"),
                      ),
                      hintText: "Password",
                      fillColor: const Color(0xffF6F6F6),
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE8E8E8), width: 2.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE8E8E8),
                        ),
                      ),
                    ),
                    validator: RequiredValidator(
                      errorText: "Password is required.",
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  PrimaryButton(
                    title: 'Log In',
                    onTab: login,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Forget password?",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // onPressed: () {
            //   Navigator.of(context).pop();
            // },
          ),
        ),
      ),
    );
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    String? deviceId = await getDeviceId();

    try {
      // Helper.progressAlert(context: context);
      User user = await AuthService.login(
          email: email, password: password, deviceId: deviceId);

      // FlutterSecureStorage().write(key: 'token', value: user.token);
      LocalStorage.set('token', user.token);

      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.name, (route) => false);
    } on Exception catch (e) {
      Toastr(message: e.toString()).show();
      Navigator.pop(context);
    } finally {}
  }
}
