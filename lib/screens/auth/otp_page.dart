import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/utils/toast_util.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:http/http.dart' as http;

class OTPPage extends StatefulWidget {
  final String? name;
  final String? customerNumber;
  final String? customerCountry;
  final String? verificationIdPassed;
  final FirebaseAuth? auth;
  final bool? newUser;
  final bool? deviceIDChanged;
  final String? customerId;

  OTPPage({
    this.customerNumber,
    this.name,
    this.customerCountry,
    this.verificationIdPassed,
    this.auth,
    this.newUser,
    this.deviceIDChanged,
    this.customerId,
  });
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  Timer? _timer;
  int _start = 60;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String phoneNo, verificationId, smsCode;
  bool otpCorrect = false;
  String? _verificationId;
  String? otpEntered;
  bool autoVerify = false;

  bool codeSent = false;
  final _scaffoldKeyOTPPage = GlobalKey<ScaffoldState>();
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('change in otp page init' + widget.deviceIDChanged.toString());

    verifyPhone2(widget.customerNumber!);
    startTimer();
  }

  Future<void> signInWithPhoneNumber2() async {
    log('sign in called');
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpEntered!,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("Congrats ! Successfully signed in...");
      setState(() {
        otpCorrect = true;
      });
      if (widget.newUser == true) {
        var userCreated = await Api.addCustomer(
            widget.name!, widget.customerNumber!, widget.customerCountry!);
        if (userCreated) {
          await saveUserToPref();
          await saveNumberToPref(widget.customerNumber!);
          var route = MaterialPageRoute(builder: (context) => MainScreen());
          Navigator.pushReplacement(context, route);
        } else {
          await ToastUtil().showToast('Failed in creating user data');
        }
      } else if (widget.deviceIDChanged == true) {
        log('updating...');
        await updateCustomer();
      } else if (widget.newUser == false) {
        await saveUserToPref();
        await saveNumberToPref(widget.customerNumber!);
        var route = MaterialPageRoute(builder: (context) => MainScreen());
        Navigator.pushReplacement(context, route);
      }
    } catch (e) {
      showSnackbar("Failed to sign in");
    }
  }

  verifyPhone2(String phone) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        otpCorrect = true;
        autoVerify = true;
      });
      await saveUserToPref();
    };

//Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      if (authException.message!
          .toLowerCase()
          .contains('we have blocked all requests from this device')) {
        showSnackbar('Too many login attempts. Please try again later');
      } else {
        showSnackbar('Phone number verification failed');
      }
    };

//Callback for when the code is sent
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      //showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.customerNumber!,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      log(e.toString());
      showSnackbar("Failed to Verify Phone Number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: AnimatedContent(
        show: true,
        leftToRight: 5.0,
        topToBottom: 0.0,
        time: 1700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    //    margin: EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width,
                    height: 300.h,

                    child: Image.asset(
                      'assets/images/wave_header_two.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      height: 150,
                      width: 150,
                      child: SvgPicture.asset('assets/svg/logo1.svg',
                          semanticsLabel: 'logo'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                widget.newUser == true ? 'Welcome!' : 'Welcome Back!',
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w200),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 0),
              child: Text(
                'Enter OTP Sent to\n${widget.customerNumber} to sign in',
                style: TextStyle(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            autoVerify
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20.h, bottom: 60.h),
                    child: Text(
                      'OTP validated  Automatically. Click \'Sign Up\' to login',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        top: 20.h, bottom: 25.h, left: 25, right: 25),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: AppTheme.appYellow,
                        accentColor: AppTheme.appYellow,
                      ),
                      child: PinPut(
                        fieldsCount: 6,
                        onSubmit: (String pin) async {
                          setState(() {
                            otpEntered = pin;
                          });
                        },
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 5),
              child: Text(
                'Didn\'t receive a code?',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await verifyPhone2(widget.customerNumber!);
                setState(() {
                  otpCorrect = false;
                  // _start = 60;
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 0, bottom: 10),
                child: Text(
                  'Request again',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppTheme.appYellow,
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.h),
              child: YellowButton(
                onPress: () async {
                  autoVerify
                      ? await nextPage()
                      : await signInWithPhoneNumber2();
                },
                title: widget.newUser == true ? 'SIGN UP' : 'SIGN IN',
              ),
            ),
          ],
        ),
      ),
    );
  }

  nextPage() async {
    if (widget.newUser == true) {
      var userCreated = await Api.addCustomer(
          widget.name!, widget.customerNumber!, widget.customerCountry!);
      if (userCreated) {
        await saveNumberToPref(widget.customerNumber!);
        await saveUserToPref();
      } else {
        //await ToastUtil().showToast('Failed in creating user data');
      }
    } else if (widget.deviceIDChanged == true) {
      log('device id changed..updating ...');
      await updateCustomer();
    } else {
      log('same device id');
    }
    await saveNumberToPref(widget.customerNumber!);
    await saveUserToPref();
    var route = MaterialPageRoute(builder: (context) => MainScreen());
    Navigator.pushReplacement(context, route);
  }

  saveNumberToPref(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', number);
    if (widget.name != null) {
      await prefs.setString('name', widget.name!);
    }

    await prefs.setString('country', widget.customerCountry!);
    log('number saved to prefs');
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  postData() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    Map requestBody = {
      "name": widget.name,
      "deviceId": Constants.DEVICE_ID,
      "phone": widget.customerNumber,
      "country": widget.customerCountry
    };

    log(requestBody.toString());

    var jsonBody = json.encode(requestBody);

    log('json body in otp page $jsonBody');

    try {
      var res = await http.post(Uri.parse(Constants.BASE_URL + 'addCustomer'),
          body: jsonBody, headers: headers);

      log('response    ' + res.body);

      if (res.body.toString().contains('Cusomer added successfully')) {
        log('user created');
        var route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, route);
      } else {
        await showAlert("Something went wrong Please login again");
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
  }

  //Update device ID of customer

  updateCustomer() async {
    log('inside updating');
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    Map requestBody = {
      "customer_id": widget.customerId,
      "name": widget.name,
      "device_id": Constants.DEVICE_ID,
      "mobile_number": widget.customerNumber,
      "country": widget.customerCountry
    };

    log(requestBody.toString());

    var jsonBody = json.encode(requestBody);
    log('to update' + jsonBody.toString());

    await saveUserToPref();
    await saveNumberToPref(widget.customerNumber!);
    var route = MaterialPageRoute(builder: (context) => MainScreen());
    Navigator.pushReplacement(context, route);
  }

  saveUserToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool('isLoggedIn', true);

      log('user saved to prefs');
    } catch (e) {
      log(e.toString());
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  showAlert(String msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok')),
          ],
        );
      },
    );
  }
}
