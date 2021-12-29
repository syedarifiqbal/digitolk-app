import 'package:digitolk_test/models/drawer_item.dart';
import 'package:digitolk_test/pages/locations_page.dart';
import 'package:digitolk_test/pages/tasks_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerItems {
  static const Tasks = DrawerItem(
    title: "Task",
    icon: CupertinoIcons.doc_plaintext,
    // screen: TasksPage(onCreateClick: (index){},),
    shouldNavigate: false,
  );
  static const Plus = DrawerItem(
    title: "Add New",
    icon: CupertinoIcons.add,
    screenName: "PLUS",
    // screen: FeedsScreen(),
    shouldNavigate: true,
  );
  static const Locations = DrawerItem(
    title: "Locations",
    // icon: Icons.location_pin,
    icon: CupertinoIcons.location,
    screen: LocationsPage(),
    shouldNavigate: false,
  );

  static final List<DrawerItem> bottomMenus = [
    Tasks,
    Plus,
    Locations,
  ];
}
