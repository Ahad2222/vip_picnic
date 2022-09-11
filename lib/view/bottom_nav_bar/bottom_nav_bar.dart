import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/view/chat/chat_head_a.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DynamicLinkHandler.initDynamicLink();
  }

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
        child: SizedBox(
          height: 110,
          child: BottomNavigationBar(
            elevation: 3,
            type: BottomNavigationBarType.fixed,
            backgroundColor: kPrimaryColor,
            showUnselectedLabels: false,
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              color: kLightPurpleColor,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              color: kDarkBlueColor,
            ),
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
                    size: 27.21,
                  ),
                ),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ImageIcon(
                    AssetImage(
                      Assets.imagesChat,
                    ),
                    size: 27.3,
                  ),
                ),
                label: 'chat'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppLinks.purchaseEvents,
                    ),
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: kTertiaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: kPrimaryColor,
                        size: 40,
                      ),
                    ),
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
                    size: 29.5,
                  ),
                ),
                label: 'alerts'.tr,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ImageIcon(
                    AssetImage(
                      Assets.imagesSettings,
                    ),
                    size: 26.93,
                  ),
                ),
                label: 'settings'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
