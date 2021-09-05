import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/tab_item.dart';

import 'app.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    required this.onSelectTab,
    required this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabs
          .map(
            (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              tabName: e.tabName,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {int? index, Widget? icon, String? tabName}) {
    return BottomNavigationBarItem(
      icon: IconButton(
        onPressed: () {},
        icon: icon!,
        color: _tabColor(index: index),
      ),
      title: Text(
        tabName!,
        style: TextStyle(
          color: _tabColor(index: index),
          fontSize: 12,
        ),
      ),
    );
  }

  Color _tabColor({int? index}) {
    return AppState.currentTab == index ? AppTheme.appYellow : Colors.grey;
  }
}
