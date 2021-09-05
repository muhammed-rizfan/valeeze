import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/screens/transporter/upload_doc_complete.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/utils/toast_util.dart';

class UploadDocument extends StatefulWidget {
  String customerId;
  String bio;
  String address1;
  String address2;
  String city;
  String state;
  String country;
  String postCode;
  String travellerType;
  int pageId;
  bool newUser;
  UploadDocument({
    required this.address1,
    required this.address2,
    required this.bio,
    required this.city,
    required this.country,
    required this.customerId,
    required this.postCode,
    required this.state,
    required this.travellerType,
    required this.newUser,
    required this.pageId,
  });

  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  bool imageUploading = false;

  bool _imagePicked = false;

  XFile? _image;

  late String phoneNumberFromPref;
  late String nameFromPref;
  loadSharedPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //preferences.setString('country', widget.country);

      phoneNumberFromPref = preferences.getString('mobile')!;
      nameFromPref = preferences.getString('name')!;
    } catch (e) {
      print(e);
    }
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      setState(() {
        _image = pickedFile;
        _imagePicked = true;
      });
      // await
      // mage(File(_image!.path));
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

  _imgFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      setState(() {
        _image = pickedFile;
        _imagePicked = true;
        print(_image!.path);
      });
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.h),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/document_upload_header.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 15,
              child: Container(
                height: 100,
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 25),
                      height: 25,
                      width: 25,
                      // color: Colors.teal,
                      // child: SvgPicture.asset('assets/svg/box.svg')
                      child: Image.asset(
                        'assets/icons/menu_yellow.png',
                        fit: BoxFit.contain,
                        height: 25,
                        width: 25,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: imageUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _documentUploadBox(),
                  SizedBox(height: 20.h),
                  Icon(Icons.camera_alt, size: 40),
                  _buildButton(),
                  _termsCondition(),
                ],
              ),
            ),
    );
  }

  Container _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 20, left: 25, right: 25),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Material(
        borderRadius: BorderRadius.circular(25),
        elevation: 5,
        shadowColor: AppTheme.appYellow,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: AppTheme.appYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () async {
            Map<String, dynamic> body = {
              "customerId": widget.customerId,
              "biodata": widget.bio,
              "address1": widget.address1,
              "address2": widget.address2,
              "city": widget.city,
              "state": widget.state,
              "country": widget.country,
              // "document": "doc",
              "postcode": widget.postCode,
              "traveller_type": widget.travellerType,
              "name": nameFromPref,
              "phone": phoneNumberFromPref,
              "deviceId": Constants.DEVICE_ID,
            };
            var route = MaterialPageRoute(
                builder: (context) => UploadDocComplete(
                      pageId: widget.pageId,
                    ));
            if (widget.newUser) {
              if (_imagePicked == false) {
                // ToastUtil().showToastCenter('Please upload document');
                showSnackbar('Please upload document');
              } else {
                setState(() {
                  imageUploading = true;
                });
                String result = await uploadImage(File(_image!.path));
                if (result.contains('added successfully')) {
                  setState(() {
                    imageUploading = false;
                  });
                  //  await ToastUtil().showToastCenter('Profile added successfully');
                  showSnackbar('Profile added successfully');
                  pushNewScreen(context,
                      screen: UploadDocComplete(
                        pageId: widget.pageId,
                      ),
                      withNavBar: false);
                  //  Navigator.pushReplacement(context, route);
                } else {
                  // await ToastUtil().showToastCenter('Could not create profile');
                  showSnackbar('Could not create profile');
                  setState(() {
                    imageUploading = false;
                  });
                }

                // var uploaded = await Api.createCustomerProfile(body);
                // if (uploaded) {
                //   await ToastUtil()
                //       .showToastCenter('User Profile Created Successfully');
                //   Navigator.push(context, route);
                // } else {
                //   ToastUtil().showToastCenter(
                //       'Failed in creating User Profile\nPlease try again later');
                // }
              }

              // var uploaded = await Api.createCustomerProfile(body);
              // if (uploaded) {
              //   await ToastUtil()
              //       .showToastCenter('User Profile Created Successfully');
              //   Navigator.push(context, route);
              // } else {
              //   ToastUtil().showToastCenter(
              //       'Failed in creating User Profile\nPlease try again later');
              // }
            } else {
              // Navigator.pushReplacement(context, route);
              pushNewScreen(context,
                  screen: UploadDocComplete(
                    pageId: widget.pageId,
                  ),
                  withNavBar: false);
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
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _termsCondition() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Text(
        '* Terms and Conditions',
        style: TextStyle(
            decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
      ),
    );
  }

  _documentUploadBox() {
    return GestureDetector(
      onTap: _showPicker,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 25, right: 25),
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: _imagePicked
                ? Container(
                    child: Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/uplode-icon.svg',
                        height: 65,
                        width: 65,
                      ),
                      Text(
                        'Documents Upload',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 25),
                      Text('Passport or Any ID cards',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Future<String> uploadImage(File image) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    log('upload called');

    print(' path in upload' + image.path);
    Dio dio = new Dio();
    String fileName;
    String fileNames = image.path.split('/').last;
    FormData formdata = FormData.fromMap({
      "document": await MultipartFile.fromFile(
        image.path,
      ),
      "customerId": widget.customerId,
      "biodata": widget.bio,
      "address1": widget.address1,
      "address2": widget.address2,
      "city": widget.city,
      "state": widget.state,
      "country": widget.country,
      "postcode": widget.postCode,
      "traveller_type": widget.travellerType,
      "name": nameFromPref,
      "phone": phoneNumberFromPref,
      "deviceId": Constants.DEVICE_ID,
    });

    log(formdata.toString());

    fileName = await dio
        .post(Constants.BASE_URL + "addCustomerProfile",
            data: formdata, options: Options(method: 'POST'))
        .then((response) => response.toString())
        .catchError((error) => print(error));

    log(fileName);

    return fileName;
  }
}
