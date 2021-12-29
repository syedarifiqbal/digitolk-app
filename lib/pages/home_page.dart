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
import 'package:digitolk_test/widgets/bottom_navigation_bar.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pusher_client/pusher_client.dart';

class HomePage extends StatefulWidget {
  static const String name = "HOME";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PusherClient pusher;
  late String? userId;

  int activeBottomMenuIndex = 0;
  int _selectedIndex = 0;
  late TabController _tabController =
      TabController(length: 3, initialIndex: _selectedIndex, vsync: this);

  bool pusherInitialized = false;

  DrawerItem item = DrawerItems.bottomMenus[0];
  late Channel channel;

  @override
  void initState() {
    super.initState();
    initializeTabs();
    initializePusher();
  }

  @override
  void dispose() {
    pusher.unsubscribe("private-task.$userId");
    pusher.disconnect();
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
    // Timer(Duration(seconds: 1), () {
    //   Helper.reminderAlert(
    //     context: context,
    //     message:
    //         "reminderAlertreminder AlertreminderAlert reminderAlert reminderAlert reminderAlert",
    //     onRemindMeAgain: () {
    //       Toastr(message: "This feature is not implemented yet.").show();
    //       Navigator.pop(context);
    //     },
    //     onSkip: () {
    //       Toastr(message: "Skipped").show();
    //       Navigator.pop(context);
    //     },
    //   );
    // });

    try {} catch (error) {
      // print(error.toString());
    }

    // if (!isSearchScreen) return item.screen;
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
      "3f4c73c6334ed62f0d32",
      options,
      autoConnect: true,
      enableLogging: false,
    );

    // connect at a later time than at instantiation.
    await pusher.connect();

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
      if (state?.currentState == 'DISCONNECTED') {
        channel.unbind('due');
        pusher.unsubscribe('private-task.$userId');
      }
      if (state?.currentState == 'CONNECTED') {
        print("SocketID: ${pusher.getSocketId()}");

        channel = pusher.subscribe("private-task.$userId");

        channel.bind("due", (PusherEvent? event) {
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

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });
  }
}
