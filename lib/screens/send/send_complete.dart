import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/theme/theme.dart';

class SendComplete extends StatelessWidget {
  const SendComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedContent(
        show: true,
        leftToRight: 5.0,
        topToBottom: 0.0,
        time: 1700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                'assets/svg/done.svg',
                color: Colors.lightGreen,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Text(
                  'Thank you for using Valeeze.\nOnce the  transporter accepts,\nwe will notify you',
                  style:
                      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 50),
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
              MaterialPageRoute(builder: (context) => MainScreen(tabIndex: 1));
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        },
        child: Text(
          'OKAY',
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
      ),
    );
  }
}
