import 'package:flutter/material.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/chat/chat_head.dart';
import 'package:vip_picnic/view/home/home.dart';
import 'package:vip_picnic/view/notifications/notifications.dart';
import 'package:vip_picnic/view/settings/settings.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    this.currentIndex = 0,
  });

  int? currentIndex;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> screens = [
    Home(),
    ChatHead(),
    Container(),
    Notifications(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: BottomNavigationBar(
          elevation: 3,
          type: BottomNavigationBarType.fixed,
          backgroundColor: kPrimaryColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: kLightPurpleColor,
          currentIndex: widget.currentIndex!,
          onTap: (index) => setState(() {
            widget.currentIndex = index;
          }),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ImageIcon(
                  AssetImage(
                    Assets.imagesHome,
                  ),
                  size: 45.0,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ImageIcon(
                  AssetImage(
                    Assets.imagesChat,
                  ),
                  size: 45.0,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppLinks.purchaseEvents,
                ),
                child: Image.asset(
                  Assets.imagesAdd,
                  height: 48.66,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ImageIcon(
                  AssetImage(
                    Assets.imagesAlerts,
                  ),
                  size: 45.0,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ImageIcon(
                  AssetImage(
                    Assets.imagesSettings,
                  ),
                  size: 45.0,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
