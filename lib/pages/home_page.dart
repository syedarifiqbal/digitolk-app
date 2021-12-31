import 'dart:async';
import 'dart:convert';

import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/core/helper.dart';
import 'package:digitolk_test/core/storage.dart';
import 'package:digitolk_test/core/toastr.dart';
import 'package:digitolk_test/data/drawer_items.dart';
import 'package:digitolk_test/models/drawer_item.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:digitolk_test/pages/create_index_page.dart';
import 'package:digitolk_test/pages/locations_page.dart';
import 'package:digitolk_test/pages/login_page.dart';
import 'package:digitolk_test/pages/tasks_page.dart';
import 'package:digitolk_test/services/auth_service.dart';
import 'package:digitolk_test/services/local_notification_service.dart';
import 'package:digitolk_test/widgets/bottom_navigation_bar.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  static const String name = "HOME";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PusherClient? pusher;
  String? userId;

  int activeBottomMenuIndex = 0;
  int _selectedIndex = 0;
  late TabController _tabController =
      TabController(length: 3, initialIndex: _selectedIndex, vsync: this);

  bool pusherInitialized = false;

  DrawerItem item = DrawerItems.bottomMenus[0];
  Channel? channel;

  @override
  void initState() {
    super.initState();
    initializeTabs();
    // initializePusher();
    initializeFirebaseNotification();
  }

  @override
  void dispose() {
    if (pusher != null) {
      pusher?.unsubscribe("private-task.$userId");
      pusher?.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: activeBottomMenuIndex,
        onItemChange: (index) {
          DrawerItem item = DrawerItems.bottomMenus[index];
          setState(() {
            this._tabController.animateTo(
                  index,
                  duration: Duration(seconds: 1),
                );
            this.item = item;
            this.activeBottomMenuIndex = index;
          });
        },
      ),
      body: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        TasksPage(onCreateClick: (index) {
          setState(() {
            this._tabController.animateTo(
                  index,
                  duration: Duration(seconds: 1),
                );
            this.activeBottomMenuIndex = index;
          });
        }),
        CreateIndexPage(
          parentScreen: item.screenName,
          onBackClick: (index) {
            setState(() {
              _tabController.animateTo(
                index,
                duration: const Duration(seconds: 1),
              );
              activeBottomMenuIndex = index;
            });
          },
        ),
        const LocationsPage(),
      ],
      //controller: _tabController,
    );
  }

  void initializeTabs() {
    _tabController.addListener(() {
      setState(() {
        activeBottomMenuIndex = _tabController.index;
      });
    });
  }

  void initializePusher() async {
    String? token = await LocalStorage.get('token');
    userId = await LocalStorage.get('id');

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
      PUSHER_APP_KEY,
      options,
      autoConnect: true,
      enableLogging: false,
    );

    // connect at a later time than at instantiation.
    await pusher?.connect();

    pusher?.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
      if (state?.currentState == 'DISCONNECTED') {
        channel?.unbind('due');
        pusher?.unsubscribe('private-task.$userId');
      }
      if (state?.currentState == 'CONNECTED') {
        channel = pusher?.subscribe("private-task.$userId");

        channel?.bind("due", (PusherEvent? event) {
          if (event == null) {
            return;
          }
          var data = jsonDecode(event.data ?? "");
          String summary = data['task']['summary'];
          String description = data['task']['description'];

          Helper.reminderAlert(
            context: context,
            message: description,
            onRemindMeAgain: () {
              Toastr(message: "This feature is not implemented yet.").show();
              Navigator.pop(context);
            },
            onSkip: () {
              Toastr(message: "Skipped").show();
              Navigator.pop(context);
            },
          );
        });
      }
    });

    pusher?.onConnectionError((error) {
      print("error: ${error!.message}");
    });
  }

  void initializeFirebaseNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((value) => {});

    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
      if (message.notification == null) return;
      String? msg = message.notification!.body;
      if (msg == null) return;

      Helper.reminderAlert(
        context: context,
        message: msg,
        onRemindMeAgain: () {
          Toastr(message: "This feature is not implemented yet.").show();
          Navigator.pop(context);
        },
        onSkip: () {
          Toastr(message: "Skipped").show();
          Navigator.pop(context);
        },
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }
}
