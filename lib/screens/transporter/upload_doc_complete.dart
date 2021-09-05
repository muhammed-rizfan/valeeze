import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/send_page.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/theme/theme.dart';

class UploadDocComplete extends StatelessWidget {
  final int pageId;
  UploadDocComplete({required this.pageId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 250.h,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/doc_upload_complete.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 35,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).canPop();
                      },
                    ),
                  ),
                  SizedBox(width: 50.w),
                  Text(
                    'Documents Upload',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  // SizedBox(width: 50.w),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 25),
                    height: 20,
                    width: 20,
                    // color: Colors.teal,
                    // child: SvgPicture.asset('assets/svg/box.svg')
                    child: Image.asset(
                      'assets/icons/menu_new.png',
                      fit: BoxFit.contain,
                      height: 20,
                      width: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 90.w,
            child: Container(
              height: 200.h,
              width: 200.w,
              child: SvgPicture.asset('assets/svg/banner-document.svg',
                  fit: BoxFit.contain),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 50, left: 25, right: 25),
              child: Text(
                'Thank you for your documents.\nWe will let you know once\nthey are verified',
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: _buildButton(context),
          ),
          Align(
            alignment: Alignment(0, .65),
            child: _termsCondition(),
          )
        ],
      ),
    );
  }

  _termsCondition() {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 40),
      child: Text(
        '* Terms and conditions',
        style: TextStyle(
            decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
      ),
    );
  }

  Container _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 25, right: 25),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: AppTheme.appYellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          if (pageId == 1) {
            var sendItemRoute =
                MaterialPageRoute(builder: (context) => SendPage());
            Navigator.pushReplacement(context, sendItemRoute);
          } else if (pageId == 2) {
            var addTripRoute = MaterialPageRoute(
                builder: (context) => MainScreen(tabIndex: 4));
            Navigator.pushReplacement(context, addTripRoute);
          } else {
            var trustCircleRoute = MaterialPageRoute(
                builder: (context) => MainScreen(tabIndex: 0));
            Navigator.pushReplacement(context, trustCircleRoute);
          }
        },
        child: Text(
          'DONE',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
