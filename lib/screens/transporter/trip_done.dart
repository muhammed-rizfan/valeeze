import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/theme/theme.dart';

class TripDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: SvgPicture.asset(
                  'assets/svg/done.svg',
                  color: Colors.lightGreen,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Your trip is added',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w300),
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
          var route =
              MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 2));
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        },
        child: Text(
          'DONE',
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
      ),
    );
  }
}
