import 'package:digitolk_test/data/drawer_items.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final ValueChanged<int> onItemChange;
  final int selectedIndex;

  const BottomNavigationWidget({
    Key? key,
    required this.selectedIndex,
    required this.onItemChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color(0xFFC3CBCE),
      onTap: onItemChange,
      unselectedIconTheme: const IconThemeData(
        color: Color(0xFFC3CBCE),
      ),
      selectedIconTheme: const IconThemeData(
        color: Colors.black,
      ),
      currentIndex: selectedIndex,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      elevation: 50,
      items: DrawerItems.bottomMenus.map(
        (item) {
          Widget icon = Icon(
            item.icon,
            size: 26,
          );

          if (item.screenName == 'PLUS') {
            icon = Container(
//                  margin: EdgeInsets.symmetric(horizontal: -10),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    spreadRadius: -10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              width: 60,
              height: 60,
              child: Icon(
                item.icon,
                size: 32,
                color: Colors.white,
              ),
            );
          }
          return BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: icon,
            label: item.screenName == 'PLUS' ? "" : item.title,
            tooltip: item.title,
          );
        },
      ).toList(),
    );
  }
}
