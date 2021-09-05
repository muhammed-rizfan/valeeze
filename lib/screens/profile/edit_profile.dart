import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:valeeze/widgets/curved_painter.dart';
import 'package:valeeze/widgets/yellow_button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  double get _textFieldWidth => MediaQuery.of(context).size.width;
  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backGroundWhiteContainer(),
          _header(),
          _profileImage(),
          _textFields(),
          _saveButton()
        ],
      ),
    );
  }

  Align _saveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: YellowButton(
          onPress: _pressButton,
          title: 'SAVE',
        ),
      ),
    );
  }

  _pressButton() {
    print('pressed yellow button');
  }

  _profileImage() {
    return Positioned(
      top: 175.h,
      left: 150.w,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.account_circle,
          size: 51.sp,
        ),
      ),
    );
  }

  _backGroundWhiteContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
    );
  }

  _header() {
    return CustomPaint(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        //height: 250,
      ),
      painter: HeaderCurvedContainer(
        color: Colors.black,
        dy: 200,
        y1: 300,
      ),
    );
  }

  _textFields() {
    return Positioned(
      top: 250,
      left: 0,
      right: 0,
      child: Container(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              elevation: 3,
              child: Container(
                width: _textFieldWidth,
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/person_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              elevation: 3,
              child: Container(
                width: _textFieldWidth,
                child: TextFormField(
                  controller: _bioController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      height: 20,
                      width: 20,
                      child: Align(
                        alignment: Alignment(.3, -3),
                        child: Container(
                          // padding: EdgeInsets.all(8),
                          height: 25,
                          width: 25,
                          child: SvgPicture.asset(
                            'assets/svg/bio_icon.svg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // suffixIconConstraints: BoxConstraints(
                    //   maxWidth: 20,
                    // ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Bio',
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Container(
                width: _textFieldWidth,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/phone_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Mobile',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Container(
                width: _textFieldWidth,
                child: TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    suffixIcon: Container(
                      height: 20,
                      width: 20,
                      child: Align(
                          alignment: Alignment(.2, -2),
                          child: Container(
                            // padding: EdgeInsets.all(8),
                            height: 25,
                            width: 25,
                            child: SvgPicture.asset(
                              'assets/svg/address_icon.svg',
                              height: 25,
                              width: 25,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Permanent address Line 1',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
