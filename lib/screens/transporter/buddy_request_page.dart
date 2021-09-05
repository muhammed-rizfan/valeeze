import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/theme/theme.dart';

class BuddiesRequested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Buddies Requested'),
      ),
      body: AnimatedContent(
        show: true,
        leftToRight: 5.0,
        topToBottom: 0.0,
        time: 1700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.w,
                width: 50.w,
                child: Icon(
                  Icons.error_outline_outlined,
                  size: 50,
                  color: Colors.amber,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'This page is currently under Ddevelopment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(height: 80.h),
            _buildButton(context)
          ],
        ),
      ),
    );
  }

  Container _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 10),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 60.h,
      width: 300.w,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: AppTheme.appYellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'OKAY',
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
      ),
    );
  }
}
