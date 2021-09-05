import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/auth/otp_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/yellow_button.dart';

class LoginPage extends StatefulWidget {
  final bool isRegistration;
  LoginPage({required this.isRegistration});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  String buttonText = 'Sign in';
  bool verifyStatus = false;
  late String countryCode;
  String? userCountry;
  String? customerName;
  late String mobileNumber;
  bool numberValidate = false;
  bool nameValidate = false;
  bool newUser = false;
  bool deviceIdChanged = false;
  String? customerId;
  final _formKey = GlobalKey<FormState>();

  String? phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    newUser = widget.isRegistration;
    nameFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  showToast(String message) async {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: AnimatedContent(
          show: true,
          leftToRight: 5.0,
          topToBottom: 0.0,
          time: 1700,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300.h,
                            child: Image.asset(
                              'assets/images/wave_header_one.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 44.h,
                                  // bottom: 30,
                                  left: 94.w,
                                  right: 94.w),
                              height: 117.h,
                              width: 171.w,
                              child: SvgPicture.asset('assets/svg/logo1.svg',
                                  // fit: BoxFit.fill,

                                  semanticsLabel: 'logo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 0, bottom: widget.isRegistration ? 16.h : 11.h),
                      child: Text(
                        widget.isRegistration ? 'Register' : 'Sign In',
                        style: TextStyle(
                            fontSize: 36.sp, fontWeight: FontWeight.w200),
                      ),
                    ),
                    widget.isRegistration
                        ? Theme(
                            data: new ThemeData(
                                // primaryColor: AppTheme.appYellow,
                                // primaryColorDark: appDarkColor,
                                ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                //borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200]!,
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      offset: Offset(3, 3)),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 37),
                              child: TextFormField(
                                focusNode: nameFocus,
                                // onEditingComplete: () =>
                                //     FocusScope.of(context).nextFocus(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (val) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: nameController,
                                validator: (val) {
                                  if (val != null) if (val.isEmpty ||
                                      val.length < 3) {
                                    showToast('Enter valid name');
                                    return;
                                  } else {
                                    nameValidate = true;
                                  }
                                },
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  prefix: SizedBox(width: 10),
                                  //contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: AppTheme.appGrey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                  hintText: 'First Name',

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      // color: AppTheme.appYellow,
                                      width: 0.35,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      //  color: AppTheme.appYellow,
                                      width: 0.35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 10),
                    Theme(
                      data: new ThemeData(
                          //  primaryColor: AppTheme.appYellow,
                          ),
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 37),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200]!,
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: Offset(3, 3)),
                          ],
                        ),
                        child: TextFormField(
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          focusNode: phoneFocus,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14.sp),
                          controller: phoneController,
                          validator: (val) {
                            if (val != null) if (val.isEmpty ||
                                val.length < 3) {
                              showToast('Enter valid number');
                              return;
                            } else {
                              numberValidate = true;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              height: 50,
                              width: 120,
                              child: CountryCodePicker(
                                onInit: (country) {
                                  userCountry = country?.name;
                                  countryCode = country.toString();
                                },
                                onChanged: (country) {
                                  userCountry = country.name;
                                  countryCode = country.toString();
                                },

                                //showDropDownButton: true,

                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: '+971',
                                flagDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),

                                // favorite: ['+971', 'IN'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,

                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: true,
                              ),
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: AppTheme.appGrey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                            hintText: 'Mobile',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                //color: AppTheme.appYellow,
                                width: 0.35,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                //color: AppTheme.appYellow,
                                width: 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.isRegistration
                        ? SizedBox.shrink()
                        : SizedBox(height: newUser ? 5.h : 60.h),
                    newUser ? _numberNotRegisteredWarning() : SizedBox.shrink(),
                    Container(
                      margin: EdgeInsets.only(top: 26.h),
                      child: YellowButton(
                        onPress: () async {
                          if (widget.isRegistration) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              mobileNumber = phoneController.text;
                              log(countryCode + mobileNumber);
                              customerName = nameController.text;
                            }
                            if (nameValidate && numberValidate) {
                              await checkCustomerExist();
                              setState(() {
                                verifyStatus = true;
                              });
                            }

                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              var route = MaterialPageRoute(
                                  builder: (context) => OTPPage(
                                        name: customerName,
                                        customerNumber:
                                            countryCode + mobileNumber,
                                        customerCountry: userCountry,
                                        newUser: newUser,
                                        deviceIDChanged: deviceIdChanged,
                                        customerId: customerId,
                                      ));
                              (nameValidate && numberValidate)
                                  ? Navigator.pushReplacement(context, route)
                                  : null;
                            });
                          } else {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              mobileNumber = phoneController.text;
                              log(countryCode + mobileNumber);
                              // customerName = nameController.text;
                            }
                            if (numberValidate) {
                              await checkCustomerExist();
                              setState(() {
                                verifyStatus = true;
                              });
                            }
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              var route = MaterialPageRoute(
                                  builder: (context) => OTPPage(
                                        name: customerName,
                                        customerNumber:
                                            countryCode + mobileNumber,
                                        customerCountry: userCountry,
                                        newUser: newUser,
                                        deviceIDChanged: deviceIdChanged,
                                        customerId: customerId,
                                      ));
                              (numberValidate && newUser == false)
                                  ? Navigator.pushReplacement(context, route)
                                  : null;
                            });
                          }
                        },
                        title: widget.isRegistration ? "SIGN UP" : "SIGN IN",
                      ),
                    ),
                    _registerButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberNotRegisteredWarning() {
    if (widget.isRegistration) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your number is not a registered user',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please '),
              GestureDetector(
                onTap: () {
                  var signUpRoute = MaterialPageRoute(
                      builder: (context) => LoginPage(isRegistration: true));

                  Navigator.pushReplacement(context, signUpRoute);
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: AppTheme.appYellow,
                    decoration: TextDecoration.underline,
                    fontSize: 14.sp,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _registerButton() {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.isRegistration
                ? 'Have an account?'
                : 'Don\'t have an account?',
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 3),
          GestureDetector(
            onTap: () {
              var signInRoute = MaterialPageRoute(
                  builder: (context) => LoginPage(isRegistration: false));
              var signUpRoute = MaterialPageRoute(
                  builder: (context) => LoginPage(isRegistration: true));
              widget.isRegistration
                  ? Navigator.pushReplacement(context, signInRoute)
                  : Navigator.pushReplacement(context, signUpRoute);
            },
            child: Text(
              widget.isRegistration ? 'Sign In' : 'Sign Up',
              style: TextStyle(
                color: AppTheme.appYellow,
                decoration: TextDecoration.underline,
                fontSize: 14.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showSnackbar(String message) {
    log(message);
    log(mobileNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  checkCustomerExist() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    String phoneToCheck = countryCode + mobileNumber;

    try {
      String customerIdCreated;
      var res = await http.get(
          Uri.parse(Constants.BASE_URL + 'getCustomerFromPhone/$phoneToCheck'));
      log(res.body);

      if (res.body != '[]') {
        log('existing user');
        setState(() {
          newUser = false;
        });
        String deviceIdFromDB = jsonDecode(res.body)[0]['device_id'];
        customerId = jsonDecode(res.body)[0]['id'];
        log('device id from DB $deviceIdFromDB');
        log('device id from device ${Constants.DEVICE_ID}');
        if (deviceIdFromDB.compareTo(Constants.DEVICE_ID) != 0) {
          log('device id changed in login screen');

          setState(() {
            deviceIdChanged = true;
          });
        } else {
          log('same device id. not changed');
        }
      } else {
        log('new user');
        setState(() {
          newUser = true;
        });
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
  }
}
