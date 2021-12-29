import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final String screenName;
  final bool shouldNavigate;

  const DrawerItem({
    required this.title,
    required this.icon,
    this.screen = const Center(),
    this.screenName = "",
    required this.shouldNavigate,
  });
}
