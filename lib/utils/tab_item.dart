import 'package:flutter/material.dart';
import 'app.dart';

class TabItem {
  // you can customize what kind of information is needed
  // for each tab
  final String tabName;
  final Widget icon;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  int _index = 0;
  Widget? _page;
  TabItem({
    required this.tabName,
    required this.icon,
    required Widget page,
  }) {
    _page = page;
  }

  // I was getting a weird warning when using getters and setters for _index
  // so I converted them to functions

  // used to set the index of this tab
  // which will be used in identifying if this tab is active
  void setIndex(int i) {
    _index = i;
  }

  int getIndex() => _index;

// adds a wrapper around the page widgets for visibility
// visibility widget removes unnecessary problems
// like interactivity and animations when the page is inactive
  Widget get page {
    return Visibility(
      // only paint this page when currentTab is active
      visible: _index == AppState.currentTab,
      // important to preserve state while switching between tabs
      maintainState: true,
      child: Navigator(
        // key tracks state changes
        key: key,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) => _page!,
          );
        },
      ),
    );
  }
}
