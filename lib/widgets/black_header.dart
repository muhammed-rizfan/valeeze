import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/curved_painter.dart';

class BlackHeader extends StatelessWidget {
  final IconData icon;
  final String heading;
  final VoidCallback onPress;
  BlackHeader(
      {required this.onPress, required this.heading, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          //height: 250,
        ),
        painter: HeaderCurvedContainer(
          color: Colors.black,
          dy: 150,
          y1: 250,
        ),
      ),
      Positioned(
        top: 60,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                heading,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  icon,
                  color: AppTheme.appYellow,
                ),
                onPressed: this.onPress,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
