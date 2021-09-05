import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/deliver_item_model.dart';
import 'package:valeeze/screens/send/transporter.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'dart:math' as math;

class FindTransporter extends StatefulWidget {
  final DeliveryItem deliverItem;
  final String currentUserId;
  const FindTransporter(
      {Key? key, required this.currentUserId, required this.deliverItem})
      : super(key: key);

  @override
  _FindTransporterState createState() => _FindTransporterState();
}

class _FindTransporterState extends State<FindTransporter> {
  bool isFlight = true;
  bool isRoad = false;
  String? from;
  String? to;
  String? date;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  final List<String> nameList = <String>[
    "DXB",
    "CNN",
    "CCJ",
    "MCT",
    "SFO",
    "BLR"
  ];

  String? _value1;
  String? _value2;
  DateTime? _searchDate;

  void initState() {
    super.initState();
    _value1 = nameList[0];
    _value2 = nameList[3];
    _fromController.text = widget.deliverItem.itemFrom!;
    _toController.text = widget.deliverItem.itemTo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.only(left: 24),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Send',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/svg/travel_bag.svg',
              height: 25,
              width: 25,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 25),
            height: 25,
            width: 25,
            // color: Colors.teal,
            // child: SvgPicture.asset('assets/svg/box.svg')
            child: Image.asset(
              'assets/icons/menu_icon.png',
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: AnimatedContent(
          show: true,
          leftToRight: 5.0,
          topToBottom: 0.0,
          time: 1700,
          child: Column(
            children: [
              _image(),
              _text(),
              _buildTextFields(),
              // _buildCheckBoxes(),
              SizedBox(height: 50.h),

              Container(
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 5,
                  shadowColor: Colors.white,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppTheme.appYellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_searchDate!.day < DateTime.now().day) {
                          showSnackbar(
                              'Date cannot be less than today\'s date');
                        } else {
                          _formKey.currentState!.save();
                          var route = MaterialPageRoute(
                              builder: (context) => Transporters(
                                    date: date,
                                    endTo: widget.deliverItem.itemTo,
                                    startFrom: widget.deliverItem.itemFrom,
                                    deliverItem: widget.deliverItem,
                                    currentUserId: widget.currentUserId,
                                  ));
                          Navigator.push(context, route);
                        }
                        // _formKey.currentState!.save();
                        // var route = MaterialPageRoute(
                        //     builder: (context) => Transporters(
                        //           date: date,
                        //           endTo: to,
                        //           startFrom: from,
                        //         ));
                        // Navigator.push(context, route);
                      }
                    },
                    child: Text(
                      'FIND YOUR ANGEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),

              // YellowButton(
              //   title: 'SEARCH',
              //   onPress: () {},
              // )
            ],
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

  _image() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: Container(
        height: 200.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20.w),
        child: SvgPicture.asset(
          'assets/svg/transporte_with_bag.svg',
        ),
      ),
    );
  }

  _text() {
    return Container(
        margin: EdgeInsets.only(bottom: 25.w),
        child: Text(
          'Find your angel',
          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w200),
        ));
  }

  _buildTextFields() {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 25, right: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      shadowColor: Colors.white,
                      child: TextFormField(
                        controller: _fromController,
                        readOnly: true,

                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter valid data';
                          }
                        },
                        // onTap: _dropdown,
                        onSaved: (val) => from = val,
                        decoration: InputDecoration(
                          // hintText: 'From',
                          fillColor: Colors.white,
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'From',
                          labelStyle: TextStyle(color: Colors.black54),
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
                    margin: EdgeInsets.only(left: 10, right: 25),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      shadowColor: Colors.white,
                      child: TextFormField(
                        controller: _toController,
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter valid data';
                          }
                        },
                        onSaved: (val) => to = val,
                        // onTap: _toDropDown,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'To',
                          labelStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                shadowColor: Colors.white,
                child: TextFormField(
                  controller: _dateController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter valid data';
                    }
                  },
                  readOnly: true,
                  onTap: _showDatePickerTravel,
                  onSaved: (val) => date = val,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // hintText: 'From',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Date',
                    suffixIcon: Container(
                      padding: EdgeInsets.all(10),
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/svg/calendar_icon.svg'),
                    ),
                    labelStyle: TextStyle(color: Colors.black54),
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

  _toDropDown() {
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
                  _toController.text = _value1!;
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

  BuildContext? alrCtxt;
  _showDatePickerTravel() {
    return showDialog(
        context: context,
        builder: (alertContext) {
          alrCtxt = alertContext;
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
    var dateFormatLeadingZeros = new DateFormat('yyyy-MM-dd');
    String formatedDate = dateFormatLeadingZeros.format(args.value);
    var stringList = args.value.toIso8601String().split(new RegExp(r"[T\.]"));
    var formatedDate2 = "${stringList[0]} ${stringList[1]}";

    if (args.value is DateTime) {
      _searchDate = args.value;
      if (this.mounted) {
        setState(() {
          _dateController.text = formatedDate2.substring(0, 10);
        });
      }
      //Navigator.pop(context);
    }
    Navigator.pop(alrCtxt!);
  }

  _buildCheckBoxes() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // height: 20,
            // width: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            // color: AppTheme.appYellow,
            child: Checkbox(
              value: isFlight,
              onChanged: (val) {
                setState(() {
                  isFlight = val!;
                  isRoad = !val;
                });
              },
              checkColor: Colors.black,
            ),
          ),
          Text(
            'Flight',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 15),
          Container(
            child: Checkbox(
              value: isRoad,
              checkColor: Colors.black,
              onChanged: (val) {
                setState(() {
                  isRoad = val!;
                  isFlight = !val;
                });
              },
            ),
          ),
          Text(
            'Road',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
