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
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNDNlZWIyODEzOGNiOWVkNzM5MGQzMmRlYTY0NTliMWUyNzllNjZhMDQwMjE2MDg3N2RkOTEwNjJmODc3NzlmMjA2MDgxZmRiMzBhZGRlMWIiLCJpYXQiOjE2NDA1NTE2NTIuMjgxMzg3LCJuYmYiOjE2NDA1NTE2NTIuMjgxMzksImV4cCI6MTY3MjA4NzY1Mi4yNzcwNTksInN1YiI6IjEiLCJzY29wZXMiOltdfQ.FMqRsuEdv0q_uQ33dtCuh4HdAJ4IQs-jtzAR4JwCrGXNsf3kh2etJ3nQX4NWWx_V7bUsnmcNkyOmCGAVM_biwoKOjD_66F7nG7wawbS8hltru5PdMZF0I0DMm1Hi__teA1yrlotuIjcoFpzu6NNQ_ZdCQFGQkmc4QgKp89HndJaIhPrLvzPQTxj-am3eMX3oI8XrldNL8feS-AFKMcr8V-3c2CLswjsk58y1VPsVO2u0jpi4aTQa9ucQKWXfUOqZwoNCLwi9TH9fNpYNABSQMphnUJ740-mRXG0koESiw4E4KuHlC_owKXo2m2Xz--hRP2sdEKohlTso-2wDrqgvjkLzHmVc6YcaFnMqjAgSVIR2dfJyhzogR0bf0tv2SLqrxFEYTdiC--1nef5jmP5uu4GoFAqllH9PN-yqhtS3B2OFBuwojCNlaaTiP-hGJSlk_jhAO6fzED4m_lAx9MaNMfUpTunnLlFW5D8V_3Cq_QBU5yx1XajdOm-QaO9GCRoXhT3HBiH7fhjNGtgQFDLsOG-qAbJdxAPAQEoyOHo2FN3n8vvSkaGTzeIUJIVSOdPGU5a36r3aZN4bnw1J16zNuNbttSDB3kkqTs0RpNk19dJl_w160x__7sS-zDFEW3Ce_71AWuTLLZs1EhXFD_db5c9EJnTs2EDBp5DunqZDVYU";
    PusherOptions options = PusherOptions(
      // host: 'example.com',
      // wsPort: 6001,
      encrypted: true,
      cluster: "ap2",
      auth: PusherAuth(
        '$baseUrl/broadcasting/auth',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    pusher = PusherClient(
      "3f4c73c6334ed62f0d32",
      options,
      autoConnect: false,
      enableLogging: false,
    );

    // connect at a later time than at instantiation.
    pusher.connect();

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    Channel channel = pusher.subscribe("private-task.1");

    channel.bind("due", (PusherEvent? event) {
      print(event?.data);
    });

    // Unsubscribe from channel
  }

  @override
  void dispose() {
    pusher.unsubscribe("private-task.1");
    pusher.disconnect();
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

    try {
      // Helper.progressAlert(context: context);
      User user = await AuthService.login(email: email, password: password);

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
