import 'package:flutter/material.dart';
import 'package:valeeze/screens/home/home_page.dart';
import 'package:valeeze/screens/transporter/trips_home.dart';
import 'package:valeeze/screens/travel_log/travel_log_home.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  const TabNavigator(
      {Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (tabItem == 'home')
      child = HomePage();
    else if (tabItem == 'log')
      child = TravelLogHome();
    else if (tabItem == 'trips') child = TripsHome();
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child!);
      },
    );
  }
}
