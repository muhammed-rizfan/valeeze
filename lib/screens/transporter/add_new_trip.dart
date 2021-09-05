import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/customer_model.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/screens/transporter/trip_done.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:day_night_time_picker/day_night_time_picker.dart';

class AddNewTrip extends StatefulWidget {
  @override
  _AddNewTripState createState() => _AddNewTripState();
}

class _AddNewTripState extends State<AddNewTrip> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _travelDateController = TextEditingController();
  TextEditingController _arrivalDateController = TextEditingController();
  TextEditingController _pickupDateController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _kgController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _pickupFromController = TextEditingController();
  TextEditingController _pickupToController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _reachTimeController = TextEditingController();

  DateRangePickerController _travelPickCtrl = DateRangePickerController();
  DateRangePickerController _arrivalPickCtrl = DateRangePickerController();
  DateRangePickerController _pickupDateCtrl = DateRangePickerController();
  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  FocusNode _fromFocus = FocusNode();
  FocusNode _destFocus = FocusNode();
  FocusNode _travelDateFocus = FocusNode();
  FocusNode _arrivalDateFocus = FocusNode();
  FocusNode _vehicleNameFocus = FocusNode();
  FocusNode _kgFocus = FocusNode();
  FocusNode _priceFocus = FocusNode();

  FocusNode _durationFocus = FocusNode();
  FocusNode _startTimeFocus = FocusNode();
  FocusNode _reachTimeFocus = FocusNode();
  FocusNode _vehicleNumberFocus = FocusNode();
  FocusNode _pickupDateFocus = FocusNode();
  FocusNode _pickupFromFocus = FocusNode();
  FocusNode _pickupToFocus = FocusNode();

  late String source;
  late String destination;
  late String travelDate;
  late String arrivalDate;
  late String vehicleName;
  late String luggageWeight;
  late String ratePerKg;
  late String vehicleNumber;
  late String startTime;
  late String startMinute;
  late String reachTime;
  late String reachMinute;
  late String pickupTimeFrom;
  late String pickupTimeTo;
  late String duration;

  late String pickUpDate;

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  bool iosStyle = true;

  void onTimeChangedStartTime(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      startTime = _time.hour.toString() + ":" + _time.minute.toString();
      _startTimeController.text = startTime;
      log(startTime);
    });
  }

  void onTimeChangedReachTime(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      reachTime = _time.hour.toString() + ":" + _time.minute.toString();
      _reachTimeController.text = reachTime;
      log(reachTime);
    });
  }

  void onTimeChangedDuration(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      pickupTimeFrom = _time.hour.toString() + ":" + _time.minute.toString();
      _durationController.text = pickupTimeFrom;
      log(pickupTimeFrom);
    });
  }

  void onTimeChangedPickupFrom(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      pickupTimeFrom = _time.hour.toString() + ":" + _time.minute.toString();
      _pickupFromController.text = pickupTimeFrom;
      log(pickupTimeFrom);
    });
  }

  void onTimeChangedPickupTo(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      pickupTimeTo = _time.hour.toString() + ":" + _time.minute.toString();
      _pickupToController.text = pickupTimeTo;

      log(pickupTimeTo);
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _value1 = nameList[0];
    _value2 = nameList[3];
    loadSharedPref();
  }

  DateTime? _departureDate;
  DateTime? _arrivalDate;
  bool dateError = false;

  String? _value1;
  String? _value2;

  final List<String> nameList = <String>[
    "DXB",
    "CNN",
    "CCJ",
    "MCT",
    "SFO",
    "BLR"
  ];

  @override
  void dispose() {
    super.dispose();
    _fromController.dispose();
    _destinationController.dispose();
    _travelDateController.dispose();
    _arrivalDateController.dispose();
    _vehicleNameController.dispose();
    _kgController.dispose();
    _priceController.dispose();
    _fromFocus.dispose();
    _destFocus.dispose();
    _travelDateFocus.dispose();
    _arrivalDateFocus.dispose();
    _vehicleNumberFocus.dispose();
    _kgFocus.dispose();
    _priceFocus.dispose();
  }

  bool _imagePicked = false;

  bool loading = true;
  bool imageUploading = false;
  Customer customer = Customer();
  List<FullCustomerData> fullCustomerData = [];
  XFile? _image;
  bool showAlert = false;
  loadSharedPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String phoneNumberFromPref = preferences.getString('mobile')!;

      customer = await Api.getCustomerFromPhone(phoneNumberFromPref);
      String id = customer.id!;
      var res =
          await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));

      fullCustomerData = fullDataFromJson(res.body);
      if (fullCustomerData[0].customerProfile!.length == 0) {
        setState(() {
          //  showAlert = true;
          loading = false;
        });
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _handleAlertPress() {
    return Future.value(false);
  }

  Future<bool> _handleBackPress() {
    Navigator.pop(context, 'added');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add New Trip',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // actions: [
          //   Container(
          //     margin: EdgeInsets.symmetric(horizontal: 20),
          //     height: 25,
          //     width: 25,
          //     child: Image.asset('assets/icons/menu_icon.png'),
          //   )
          // ],
        ),
        body: loading || imageUploading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: AnimatedContent(
                  show: true,
                  leftToRight: 5.0,
                  topToBottom: 0.0,
                  time: 1700,
                  child: Column(
                    children: [
                      _text(),
                      _headerImage(),
                      _textFields(),
                      _favorOption(),
                      _imageUploadBox(),
                      _buildButton(),
                      _termsCondition(),
                      SizedBox(height: 30)
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _termsCondition() {
    return Container(
      child: Text(
        '* Terms and Conditions',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  _dropdownDestination() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Arrival'),
            content: DropdownButton(
              value: _value1,
              onChanged: (value) {
                setState(() {
                  _value1 = value.toString();
                  _destinationController.text = _value1!;
                });
                Navigator.pop(context);
              },
              items: nameList.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        });
  }

  _dropdown() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Departure'),
            content: DropdownButton(
              value: _value1,
              onChanged: (value) {
                setState(() {
                  _value1 = value.toString();
                  _fromController.text = _value1!;
                });
                Navigator.pop(context);
              },
              items: nameList.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        });
  }

  _favorOption() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        children: [
          _favourCard('Favour', 0),
          _favourCard('Paid', 1),
          Spacer(),
        ],
      ),
    );
  }

  int _isSelectedId = 0;
  _favourCard(String text, int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelectedId = id;
        });
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppTheme.appGrey,
          ),
        ),
        child: Container(
          height: 60,
          width: 150.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _isSelectedId == id ? AppTheme.purpleColor : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 10),
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: _isSelectedId == id ? Colors.white : Colors.black,
                    )),
                child: _isSelectedId == id
                    ? Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 8,
                      )
                    : SizedBox.shrink(),
              ),
              Text(
                text,
                style: TextStyle(
                    color: _isSelectedId == id ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changed(bool) {}

  _textFields() {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 7),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        shadowColor: Colors.white,
                        child: TextFormField(
                          controller: _fromController,
                          readOnly: true,
                          focusNode: _fromFocus,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 2) {
                              return 'Enter valid data';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onSaved: (val) => source = val!,
                          onTap: _dropdown,
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              padding: EdgeInsets.all(10),
                              height: 10,
                              width: 10,
                              child: SvgPicture.asset(
                                  'assets/svg/address_icon.svg'),
                            ),
                            // hintText: 'From',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'From which city',
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
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 7),
                      //margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        shadowColor: Colors.white,
                        child: TextFormField(
                          controller: _destinationController,
                          focusNode: _destFocus,
                          onTap: _dropdownDestination,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 2) {
                              return 'Enter valid data';
                            }
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onSaved: (val) => destination = val!,
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              padding: EdgeInsets.all(10),
                              height: 10,
                              width: 10,
                              child: SvgPicture.asset(
                                  'assets/svg/address_icon.svg'),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Your travel destination',
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
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 7),
                      // margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        shadowColor: Colors.white,
                        child: TextFormField(
                          controller: _travelDateController,
                          focusNode: _travelDateFocus,
                          onTap: _showDatePickerTravel,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter valid data';
                            }
                            //  else {
                            //   String errorMessage = '';
                            //   if (_arrivalDate!.isBefore(_departureDate!)) {
                            //     errorMessage =
                            //         'Arrival date cannot be less than departure Date';
                            //   }
                            //   return errorMessage;
                            // }
                          },
                          onSaved: (val) => travelDate = val!,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              padding: EdgeInsets.all(10),
                              height: 10,
                              width: 10,
                              child: SvgPicture.asset(
                                  'assets/svg/calendar_icon.svg'),
                            ),
                            // hintText: 'From',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Travel Date',
                            labelStyle: TextStyle(
                                color: Colors.black54, fontSize: 15.sp),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 7),
                      // margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        shadowColor: Colors.white,
                        child: TextFormField(
                          controller: _arrivalDateController,
                          readOnly: true,
                          focusNode: _arrivalDateFocus,
                          textInputAction: TextInputAction.next,
                          onTap: _showDatePickerDestination,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 2) {
                              return 'Enter valid data';
                            }
                          },
                          onSaved: (val) => arrivalDate = val!,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              padding: EdgeInsets.all(10),
                              height: 8,
                              width: 8,
                              child: SvgPicture.asset(
                                  'assets/svg/calendar_icon.svg'),
                            ),
                            // hintText: 'From',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Arrival Date',
                            labelStyle: TextStyle(
                                color: Colors.black54, fontSize: 15.sp),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _startTimeController,
                  focusNode: _startTimeFocus,
                  onTap: _startTimePicker,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  onSaved: (val) => travelDate = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Start Time',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _reachTimeController,
                  focusNode: _reachTimeFocus,
                  onTap: _reachTimePicker,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  onSaved: (val) => travelDate = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Reach Time',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _durationController,
                  focusNode: _durationFocus,
                  onTap: _durationTimePicker,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  //onSaved: (val) => duration = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Travel Duration',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _vehicleNameController,
                  focusNode: _vehicleNameFocus,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid data';
                    }
                  },
                  onSaved: (val) => vehicleName = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    // suffixIcon: Icon(Icons.flight),
                    suffixIcon: Container(
                      padding: EdgeInsets.all(12),
                      height: 5,
                      width: 5,
                      //color: Colors.teal,
                      child: Image.asset(
                        'assets/icons/flight.png',
                        height: 5,
                        width: 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Flight Name',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _vehicleNumberController,
                  focusNode: _vehicleNumberFocus,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 2) {
                      return 'Enter valid data';
                    }
                  },
                  onSaved: (val) => vehicleNumber = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    // suffixIcon: Icon(Icons.flight),
                    suffixIcon: Container(
                      padding: EdgeInsets.all(12),
                      height: 5,
                      width: 5,
                      //color: Colors.teal,
                      child: Image.asset(
                        'assets/icons/flight.png',
                        height: 5,
                        width: 5,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Flight Number',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _kgController,
                  focusNode: _kgFocus,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  onSaved: (val) => luggageWeight = val!,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: 35, maxWidth: 35),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 15),
                      // height: 5,
                      // width: 5,
                      child: SvgPicture.asset(
                        'assets/svg/weight.svg',
                        color: Colors.grey[500],
                        // height: 10,
                        // width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'KGs available',
                    // suffix: Text('KG'),
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _priceController,
                  focusNode: _priceFocus,
                  textInputAction: TextInputAction.done,
                  onSaved: (val) => ratePerKg = val!,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  keyboardType: TextInputType.number,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: 35, maxWidth: 35),

                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 15),
                      // height: 5,
                      // width: 5,
                      child: SvgPicture.asset(
                        'assets/svg/money.svg',
                        color: Colors.grey[500],
                        // height: 10,
                        // width: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //suffix: Text('\$'),

                    labelText: 'Price/kg',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _pickupDateController,
                  focusNode: _pickupDateFocus,
                  onTap: _showDatePickerPickUp,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  // onSaved: (val) => pickUpDate = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Pickup Date',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _pickupFromController,
                  focusNode: _pickupFromFocus,
                  onTap: _pickUpFromTimePicker,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  // onSaved: (val) => travelDate = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Pickup Time - From',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _pickupToController,
                  focusNode: _pickupToFocus,
                  onTap: _pickUpToTimePicker,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  // onSaved: (val) => travelDate = val!,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Pickup Time - To',
                    labelStyle:
                        TextStyle(color: Colors.black54, fontSize: 15.sp),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _startTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        is24HrFormat: true,
        accentColor: AppTheme.appYellow,
        onChange: onTimeChangedStartTime,
      ),
    );
  }

  _reachTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        is24HrFormat: true,
        accentColor: AppTheme.appYellow,
        onChange: onTimeChangedReachTime,
      ),
    );
  }

  _durationTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        is24HrFormat: true,
        accentColor: AppTheme.appYellow,
        onChange: onTimeChangedDuration,
      ),
    );
  }

  _pickUpFromTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        is24HrFormat: true,
        accentColor: AppTheme.appYellow,
        onChange: onTimeChangedPickupFrom,
      ),
    );
  }

  _pickUpToTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        is24HrFormat: true,
        accentColor: AppTheme.appYellow,
        onChange: onTimeChangedPickupTo,
      ),
    );
  }

  _showDatePickerDestination() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              onSelectionChanged: _onSelectionChangedDestination,
            ),
          ));
        });
  }

  void _onSelectionChangedDestination(
      DateRangePickerSelectionChangedArgs args) {
    var dateFormatLeadingZeros = new DateFormat('dd/MM/yyyy');
    String formatedDate = dateFormatLeadingZeros.format(args.value);
    var stringList = args.value.toIso8601String().split(new RegExp(r"[T\.]"));
    var formatedDate2 = "${stringList[0]} ${stringList[1]}";
    if (args.value is DateTime) {
      _arrivalDate = args.value;

      if (this.mounted) {
        setState(() {
          _arrivalDateController.text = formatedDate2.substring(0, 10);
        });
      }
      Navigator.pop(context);
    }
  }

  _showDatePickerPickUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              onSelectionChanged: _onSelectionChangedPickUp,
            ),
          ));
        });
  }

  _showDatePickerTravel() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              onSelectionChanged: _onSelectionChangedTravel,
            ),
          ));
        });
  }

  void _onSelectionChangedTravel(DateRangePickerSelectionChangedArgs args) {
    var dateFormatLeadingZeros = new DateFormat('dd-MM-yyyy');
    String formatedDate = dateFormatLeadingZeros.format(args.value);
    var stringList = args.value.toIso8601String().split(new RegExp(r"[T\.]"));
    var formatedDate2 = "${stringList[0]} ${stringList[1]}";

    if (args.value is DateTime) {
      _departureDate = args.value;
      if (this.mounted) {
        setState(() {
          _travelDateController.text = formatedDate2.substring(0, 10);
        });
      }
      // Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  void _onSelectionChangedPickUp(DateRangePickerSelectionChangedArgs args) {
    var dateFormatLeadingZeros = new DateFormat('dd-MM-yyyy');
    String formatedDate = dateFormatLeadingZeros.format(args.value);
    var stringList = args.value.toIso8601String().split(new RegExp(r"[T\.]"));
    var formatedDate2 = "${stringList[0]} ${stringList[1]}";

    if (args.value is DateTime) {
      _departureDate = args.value;
      if (this.mounted) {
        setState(() {
          _pickupDateController.text = formatedDate2.substring(0, 10);
        });
      }
      // Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  _imageUploadBox() {
    return GestureDetector(
      onTap: _showPicker,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: 200.h,
              width: 300.w,
              child: _imagePicked
                  ? Container(
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset('assets/svg/camera_filled.svg'),

                        Container(
                            alignment: Alignment.center,
                            height: 100.w,
                            width: 100.w,
                            child: SvgPicture.asset(
                                'assets/svg/camera_filled.svg')),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text('Upload the image of your ticket'),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
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
      });
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
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

  Container _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.white,
        color: AppTheme.appYellow,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: AppTheme.appYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () async {
            if ((_arrivalDate != null && _departureDate != null) &&
                !(_arrivalDate!.isBefore(_departureDate!))) {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (source == destination || destination == source) {
                  showSnackbar(
                      'Choose different places for Arrival and Departure');
                } else {}

                if (_imagePicked == true) {
                  setState(() {
                    imageUploading = true;
                  });

                  String result = await uploadImage(File(_image!.path));
                  if (result.contains('Cusomer profile added successfully')) {
                    setState(() {
                      imageUploading = false;
                    });
                    // await ToastUtil().showToastCenter('Trip added Successfully');
                    showSnackbar('Trip added Successfully');
                    var route =
                        MaterialPageRoute(builder: (context) => TripDone());
                    Navigator.push(context, route);
                  } else {
                    // await ToastUtil().showToastCenter('Could not add trip');
                    showSnackbar('Could not add trip');
                    setState(() {
                      imageUploading = false;
                    });
                  }
                } else {
                  // await ToastUtil().showToastCenter('Please upload ticket');
                  showSnackbar('Please upload ticket');
                }
              }
            } else {
              showSnackbar('Arrival Date cannot be before Departure Date');
              // await ToastUtil().showToastCenter(
              //     'Arrival Date cannot be before Departure Date');

            }
          },
          child: Text(
            'SAVE',
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

  _headerImage() {
    return Container(
      height: 200.h,
      width: 200.w,
      child: SvgPicture.asset('assets/svg/trip-banner.svg'),
    );
  }

  _text() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 55),
      alignment: Alignment.centerLeft,
      child: Text(
        'Where are you going',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 27.sp,
        ),
        textAlign: TextAlign.center,
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
      "ticket": await MultipartFile.fromFile(
        image.path,
      ),
      "customerId": customer.id,
      "startFrom": source,
      "destination": destination,
      "travelDate": _travelDateController.text,
      "reachDate": _arrivalDateController.text,
      "vehicleName": vehicleName,
      "availableLuggageWeight": luggageWeight,
      "ratePerKg": ratePerKg,
      "mode": "1",
      "vehicleNo": vehicleNumber,
      "startTime": startTime,
      "reachTime": reachTime,
      "travelTime": _durationController.text,
      "pickupDate": _pickupDateController.text,
      "pickupTime1": pickupTimeFrom,
      "pickupTime2": pickupTimeTo,
    });

    fileName = await dio
        .post(Constants.BASE_URL + "addTripDetails",
            data: formdata, options: Options(method: 'POST'))
        .then((response) => response.toString())
        .catchError((error) => print(error));

    log(fileName);

    return fileName;
  }
}
