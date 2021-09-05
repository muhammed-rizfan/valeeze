import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/curved_painter.dart';

class HelpDetail extends StatelessWidget {
  final String helpTopic;
  final String helpDetail;
  HelpDetail({required this.helpDetail, required this.helpTopic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _header(context),
          _helpDetails(),
        ],
      ),
    );
  }

  _helpDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        this.helpDetail,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  _header(BuildContext context) {
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
        top: 50,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Help',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppTheme.appYellow,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
