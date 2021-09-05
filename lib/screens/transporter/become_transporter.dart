import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/transporter/trips_home.dart';
import 'package:valeeze/screens/transporter/upload_documents.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:valeeze/models/customer_model.dart';
import 'package:http/http.dart' as http;

class BecomeTransporter extends StatefulWidget {
  final bool? notCompleted;
  final int? pageId;
  const BecomeTransporter({Key? key, this.notCompleted, this.pageId})
      : super(key: key);

  @override
  _BecomeTransporterState createState() => _BecomeTransporterState();
}

class _BecomeTransporterState extends State<BecomeTransporter> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  _resetForm() {
    _firstNameController.clear();
    _bioController.clear();
    _phoneController.clear();
    _addressController.clear();
    _address2Controller.clear();
    _cityController.clear();
    _stateController.clear();
    _pinCodeController.clear();
    _countryController.clear();
  }

  String _travellerType = "Regular";
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String bio;
  late String phoneNumber;
  late String address1;
  late String address2;
  late String city;
  late String state;
  late String pinCode;
  late String country;
  Customer customer = Customer();
  String? nameFromPref;
  String? phoneNumberFromPref;

  @override
  void initState() {
    super.initState();
    loadSharedPref();
    // _firstNameController.text = nameFromPref!;
    // _phoneController.text = phoneNumberFromPref!;
  }

  List<FullCustomerData> fullCustomerData = [];

  bool loading = true;
  bool newUser = true;

  loadSharedPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      country = preferences.getString('country')!;
      phoneNumberFromPref = preferences.getString('mobile')!;
      nameFromPref = preferences.getString('name')!;
      _firstNameController.text = nameFromPref!;
      _phoneController.text = phoneNumberFromPref!;

      customer = await Api.getCustomerFromPhone(phoneNumberFromPref!);
      preferences.setString('custId', customer.id!);
      String id = customer.id!;
      var res =
          await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));
      log(res.body);

      fullCustomerData = fullDataFromJson(res.body);
      if (fullCustomerData[0].customerProfile!.length != 0) {
        CustomerProfile customerProfile =
            fullCustomerData[0].customerProfile![0];
        _bioController.text = customerProfile.biodata!;
        _addressController.text = customerProfile.address1!;
        _address2Controller.text = customerProfile.address2!;
        _cityController.text = customerProfile.city!;
        _stateController.text = customerProfile.state!;
        _pinCodeController.text = customerProfile.postcode!;
        newUser = false;

        // var route = MaterialPageRoute(builder: (context) => MainScreen());
        // pushDynamicScreen(context,
        //     screen:
        //     Navigator.pushAndRemoveUntil(context, route, (route) => false));
        // await Navigator.pushReplacement(context, route);

      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _countryController.dispose();
  }

  int _isSelectedId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.h),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/document_upload_header.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 35,
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
                    'Complete Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(width: 70.w),
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
            )
          ],
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AnimatedContent(
                show: true,
                leftToRight: 5.0,
                topToBottom: 0.0,
                time: 1700,
                child: Column(
                  children: [
                    _image(),
                    _text(),
                    _completeProfileWarning(),

                    _travellerCards(),
                    _textFields(),
                    // _buildButton(),
                    _yellowButton(),
                    _termsCondition()
                  ],
                ),
              ),
            ),
    );
  }

  Container _completeProfileWarning() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.appYellow.withOpacity(.2),
      ),
      margin: EdgeInsets.only(top: 25.h, left: 25, right: 25),
      alignment: Alignment.center,
      child: Text(
        'Please complete your profile first for\nsending or receiving items',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
      ),
    );
  }

  _termsCondition() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        '* Terms and Conditions',
        style: TextStyle(
            decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
      ),
    );
  }

  _yellowButton() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 18),
      child: YellowButton(
          title: 'YOU ARE ALMOST THERE',
          onPress: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              var route = MaterialPageRoute(
                  builder: (context) => UploadDocument(
                        customerId: customer.id!,
                        address1: address1,
                        address2: address2,
                        bio: bio,
                        city: city,
                        country: country,
                        postCode: pinCode,
                        state: state,
                        travellerType: _travellerType,
                        newUser: newUser,
                        pageId: widget.pageId!,
                      ));
              Navigator.pushReplacement(context, route);
              _resetForm();
            }
          }),
    );
  }

  _textFields() {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                // shadowColor: Colors.white,
                child: TextFormField(
                  controller: _firstNameController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid name';
                    }
                  },
                  onSaved: (val) => firstName = val!,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/person_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.black54),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _bioController,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid data';
                    }
                  },
                  onSaved: (val) => bio = val!,
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
                          )),
                    ),
                    // suffixIconConstraints: BoxConstraints(
                    //   maxWidth: 20,
                    // ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Bio',
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  readOnly: true,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 5) {
                      return 'Enter valid number';
                    }
                  },
                  onSaved: (val) => phoneNumber = val!,
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
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Mobile',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _addressController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid address';
                    }
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (val) => address1 = val!,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/address_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Permanent address Line 1',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _address2Controller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid address';
                    }
                  },
                  onSaved: (val) => address2 = val!,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/address_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Permanent address Line 2',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _cityController,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid city';
                    }
                  },
                  onSaved: (val) => city = val!,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/address_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'City',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                elevation: 5,
                child: TextFormField(
                  controller: _stateController,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid state';
                    }
                  },
                  onSaved: (val) => state = val!,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/address_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'State',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: AppTheme.appGrey,
                    width: 1,
                  ),
                ),
                elevation: 5,
                child: TextFormField(
                  controller: _pinCodeController,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 4) {
                      return 'Enter valid pin Code';
                    }
                  },
                  onSaved: (val) => pinCode = val!,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(8),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/svg/address_icon.svg',
                        height: 10,
                        width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Pin/Zip code',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _travellerCards() {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTravellerCard(
              'assets/icons/traveller.png', 'Traveller', false, 0, 'Regular'),
          Spacer(),
          _buildTravellerCard('assets/svg/traveller_occasional.svg',
              'Occasional\nTraveller', true, 1, 'Occasional')
        ],
      ),
    );
  }

  _buildTravellerCard(
      String imagePath, String text, bool isSvg, int id, String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelectedId = id;
          _travellerType = type;
        });
      },
      child: Container(
        //margin: EdgeInsets.only(left: 25),
        height: 140,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: _isSelectedId == id ? AppTheme.appYellow : Colors.white,
          color: _isSelectedId == id ? AppTheme.appYellow : Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 25),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  height: 45,
                  width: 45,
                  child: isSvg
                      ? SvgPicture.asset(imagePath)
                      : Image.asset(imagePath),
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _text() {
    return Container(
      child: Text(
        'What type of traveller\nare you?',
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26.sp),
        textAlign: TextAlign.center,
      ),
    );
  }

  _image() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 140.w,
        width: 150.w,
        //child: SvgPicture.asset('assets/svg/become-a-transporter.svg'),
        child: Image.asset('assets/images/trolley_with_wings.png'),
      ),
    );
  }
}
