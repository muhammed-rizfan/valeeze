import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:valeeze/screens/auth/login_page.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/utils/constants.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    getDevideID();
  }

  String? deviceId;
  getDevideID() async {
    deviceId = await _getId();
    if (deviceId != null) {
      Constants.DEVICE_ID = deviceId!;
      log('device id set in onboard' + Constants.DEVICE_ID);
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appYellow,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _logo(),
            _onboardOne(),
            _textBold(),
            Spacer(),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _signInButton(context)),
                Expanded(child: _signUpButton(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _signInButton(BuildContext context) {
    return Container(
      height: 70.h,
      alignment: Alignment.center,
      child: TextButton(
          style: TextButton.styleFrom(),
          onPressed: () {
            var route = MaterialPageRoute(
                builder: (context) => LoginPage(
                      isRegistration: false,
                    ));
            Navigator.pushReplacement(context, route);
          },
          child: Text(
            'Sign In',
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          )),
    );
  }

  Container _signUpButton(BuildContext context) {
    return Container(
      height: 66.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () {
            var route = MaterialPageRoute(
                builder: (context) => LoginPage(
                      isRegistration: true,
                    ));
            Navigator.pushReplacement(context, route);
          },
          child: Text(
            'Create Account',
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          )),
    );
  }

  Container _textTwo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        'The human delivery service',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300),
      ),
    );
  }

  Container _textBold() {
    return Container(
      margin: EdgeInsets.only(top: 40.h, left: 29.w, right: 29.w),
      child: Text(
        'Send with ease',
        style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w200),
      ),
    );
  }

  Container _onboardOne() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 62),
      height: 175.h,
      width: 208.w,
      child: Image.asset('assets/images/onb4.png'),
    );
  }

  Container _logo() {
    return Container(
      margin: EdgeInsets.only(top: 44.h, left: 95.w, right: 94.w),
      alignment: Alignment.center,
      height: 117.h,
      width: 171.w,
      child: Image.asset('assets/logo/logo.png'),
    );
  }
}
