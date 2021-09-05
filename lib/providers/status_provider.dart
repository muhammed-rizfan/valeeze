import 'package:flutter/material.dart';
import 'package:valeeze/theme/theme.dart';

class StatusProvider with ChangeNotifier {
  int _currentStatusId = 1;

  int get newStatus => _currentStatusId;
  void updateStatus(int newStatus) {
    _currentStatusId = newStatus;
    notifyListeners();
  }

  Text getCurrentStatusText(int statusId) {
    String status = 'Accept';
    Text statusText = Text(
      status,
      style: TextStyle(
        color: AppTheme.appYellow,
        fontWeight: FontWeight.w400,
      ),
    );

    if (_currentStatusId == 1) {
      return statusText;
    } else if (_currentStatusId == 2) {
      return Text(
        'Accepted',
        style: TextStyle(
          color: Colors.lightGreen,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (_currentStatusId == 3) {
      return Text(
        'Rejected',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (_currentStatusId == 4) {
      return Text(
        'Cancelled',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        'Confirmed',
        style: TextStyle(
          color: AppTheme.appYellow,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }
}
