import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:valeeze/screens/home/home_page.dart';
import 'package:valeeze/screens/send/payment.dart';
import 'package:valeeze/screens/send/send_page.dart';
import 'package:valeeze/screens/send/transporter_profile.dart';
import 'package:valeeze/screens/transporter/add_new_trip.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/screens/transporter/trips_home.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/utils/tab_navigator.dart';
import 'package:device_info/device_info.dart';
import 'package:valeeze/screens/travel_log/travel_log_home.dart';

class MainScreen extends StatefulWidget {
  final tabIndex;
  MainScreen({Key? key, this.tabIndex}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  static int? tab;
  static var tab1;
  Widget? _child;
  int _currentIndex = 0;
  String? currentPage;
  List<String> pageKeys = ['home', 'log', 'trips'];

  String? deviceId;

  List<Widget> _children = [
    HomePage(),
    SendPage(),
    AddNewTrip(),
    TravelLogHome(),
    TripsHome(),
  ];

  @override
  void initState() {
    tab = widget.tabIndex != null ? widget.tabIndex : tab = 0;

    getDevideID();
    super.initState();
  }

  getDevideID() async {
    deviceId = await _getId();
    if (deviceId != null) {
      Constants.DEVICE_ID = deviceId!;
      log('device id set in homepage' + Constants.DEVICE_ID);
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  void dispose() {
    tab = 0;
    super.dispose();
  }

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/home.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      activeIcon: SvgPicture.asset(
        'assets/svg/home_filled.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/send)_icon.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Send',
      activeIcon: SvgPicture.asset(
        'assets/svg/send)_icon.svg',
        color: AppTheme.appYellow,
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/trip.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Become An Angel',
      activeIcon: SvgPicture.asset(
        'assets/svg/trip_filled.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/travel_bag.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'My Luggage',
      activeIcon: SvgPicture.asset(
        'assets/svg/travel_bag_filled.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/trip.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Trips',
      activeIcon: SvgPicture.asset(
        'assets/svg/trip_filled.svg',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,

      // context,pushNewScreen(),

      controller: _controller,

      screens: _children,
      items: _perSistentNavBarItems(),
      confineInSafeArea: true,
      hideNavigationBar: false,

      navBarHeight: 80,

      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,

      popActionScreens: PopActionScreensType.once,
      // itemAnimationProperties: ItemAnimationProperties(
      //   // Navigation Bar's items animation properties.
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
      // screenTransitionAnimation: ScreenTransitionAnimation(
      //   // Screen transition animation on change of selected tab.
      //   animateTabTransition: true,
      //
      //   curve: Curves.ease,
      //   duration: Duration(milliseconds: 200),
      // ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }

  void onTabTapped(int index) {
    log('$index');
    setState(() {
      tab = index;
    });
  }

  _showExitAlert() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are you sure to close the app?'),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                SystemNavigator.pop();
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              child: Text('No'),
              onPressed: () async {
                // var route =
                //     MaterialPageRoute(builder: (context) => MainScreen());
                // Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PersistentBottomNavBarItem> _perSistentNavBarItems() {
    return [
      PersistentBottomNavBarItem(
        // iconSize: 10,
        icon: Container(
          // padding: EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/svg/home.svg',
            height: 25,
            width: 25,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: ("Home"),
        textStyle: TextStyle(color: Colors.black),
        activeColorPrimary: AppTheme.appYellow,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // icon: SvgPicture.asset(
        //   'assets/svg/send)_icon.svg',
        //   // height: 25,
        //   // width: 25,
        //   fit: BoxFit.contain,
        // ),
        // iconSize: 10,
        icon: Container(
          // padding: EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/svg/send)_icon.svg',
            height: 25,
            width: 25,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: ("Send"),
        textStyle: TextStyle(color: Colors.black),
        activeColorPrimary: AppTheme.appYellow,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // icon: SvgPicture.asset(
        //   'assets/svg/trip.svg',
        //   // height: 25,
        //   // width: 25,
        //   fit: BoxFit.contain,
        // ),
        //iconSize: 50,
        icon: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/icons/angel.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
        title: ("     "),
        textStyle: TextStyle(color: Colors.black),
        activeColorPrimary: AppTheme.appYellow,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // icon: SvgPicture.asset(
        //   'assets/svg/travel_bag.svg',
        //   // height: 25,
        //   // width: 25,
        //   fit: BoxFit.contain,
        // ),
        // iconSize: 10,
        icon: Container(
          // padding: EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/svg/travel_bag.svg',
            height: 25,
            width: 25,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: ("Lug"),
        textStyle: TextStyle(color: Colors.black),
        activeColorPrimary: AppTheme.appYellow,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // icon: SvgPicture.asset(
        //   'assets/svg/trip.svg',
        //   // height: 25,
        //   // width: 25,
        //   fit: BoxFit.contain,
        // ),
        // iconSize: 10,
        icon: Container(
          // padding: EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/svg/trip.svg',
            height: 25,
            width: 25,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: ("Trips"),
        textStyle: TextStyle(color: Colors.black),
        activeColorPrimary: AppTheme.appYellow,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
