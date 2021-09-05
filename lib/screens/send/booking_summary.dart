import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/deliver_item_model.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/send/payment.dart';
import 'package:valeeze/screens/send/send_complete.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/curved_painter.dart';
import 'package:valeeze/widgets/trip_card.dart';
import 'package:valeeze/widgets/upcoming_trip_card.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:http/http.dart' as http;

class BookingSummary extends StatefulWidget {
  final TripDetails tripDetail;
  final DeliveryItem deliverItem;
  const BookingSummary(
      {Key? key, required this.deliverItem, required this.tripDetail})
      : super(key: key);

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  List<FullCustomerData> fullCustomerData = [];
  bool loading = true;
  late String customerName;

  bool _imagePicked = false;
  XFile? _image;
  int _radioValue1 = -1;
  int _radioValue2 = -2;
  TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _description;
  @override
  void initState() {
    super.initState();

    loadCustomer();
    if (widget.deliverItem.itemImage != null) {
      log('image is ' + widget.deliverItem.itemImage!);
    }
  }

  loadCustomer() async {
    String customerId = widget.tripDetail.customerId!;
    var res = await http
        .get(Uri.parse(Constants.BASE_URL + 'getCustomer/$customerId'));
    fullCustomerData = fullDataFromJson(res.body);
    customerName = fullCustomerData[0].name!;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    _header(context),
                    _uploadDetails(context),
                    _transporterDetails(),
                    Divider(),
                    _travelDateTile(),
                    _totalAmount(),
                    _legalText(),
                    // _imageUploadBox(),
                    _buildPaymentOption(),
                    _radioValue1 == 1 ? _imageUploadBox() : SizedBox.shrink(),

                    YellowButton(
                      onPress: () async {
                        log('radio on selcted $_radioValue1');
                        if (_radioValue1 == 0) {
                          await _scheduleWithPaymentGateWayMethod();
                        } else {
                          await _scheduleWithGiftOption();
                        }
                      },
                      title: 'REQUEST YOUR MOVER',
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }

  _scheduleWithGiftOption() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_imagePicked == false) {
        showSnackbar('Please upload item image');
      } else {
        log('upload in progress');
      }
    }
  }

  _scheduleWithPaymentGateWayMethod() async {
    String tripId = widget.tripDetail.id!;
    String itemId = widget.deliverItem.id!;

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      };
      Map requestBody = {
        "deliveryItemId": itemId,
        "tripDetailId": tripId,
      };
      log(requestBody.toString());
      var jsonBody = json.encode(requestBody);

      var res = await http.post(
        Uri.parse(Constants.BASE_URL + 'addScheduledDeliveryDetails'),
        body: jsonBody,
        headers: headers,
      );
      log(res.body);
      if (res.body.contains('Scheduled Delivery Details added successfully')) {
        showSnackbar('Schedule Delivery details added succesfully');
        var route = MaterialPageRoute(builder: (context) => SendComplete());
        Navigator.push(context, route);
      } else {
        showSnackbar('Could not schedule Delivery details');
      }
    } catch (e) {
      print(e);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _buildPaymentOption() {
    return Container(
      child: Row(
        children: [
          Radio(
            value: 0,
            groupValue: _radioValue1,
            onChanged: _handleRadioValueChange,
          ),
          Text('I\'ll make payment'),
          Radio(
            value: 1,
            groupValue: _radioValue1,
            onChanged: _handleRadioValueChange,
          ),
          Text('I\'ll offer a gift'),
        ],
      ),
    );
  }

  _handleRadioValueChange(int? value) {
    log('radio value is $value');
    setState(() {
      _radioValue1 = value!;
    });
  }

  _legalText() {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[400]!)),
        // margin: EdgeInsets.all(1),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Hi $customerName,\nCould you please take my luggage?\nWeight : ${widget.tripDetail.availableLuggageWeight} Kg',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
                color: AppTheme.appGrey,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  _totalAmount() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Amount',
            style: TextStyle(color: AppTheme.appGrey),
          ),
          Text(
            '\$ ${widget.tripDetail.ratePerKg}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          )
        ],
      ),
    );
  }

  _travelDateTile() {
    var date = widget.tripDetail.travelDate;

    String fromDate = DateFormat('EEEE, d MMM').format(date!);

    return Container(
        margin: EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Card(
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.only(top: 15, left: 15),
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  fromDate,
                  style: TextStyle(
                      color: AppTheme.appGrey, fontWeight: FontWeight.w400),
                )
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                '${widget.tripDetail.ratePerKg} \$',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ));
  }

  _transporterDetails() {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 25),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(.2),
              radius: 25,
              child: Icon(Icons.person),
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                'The Mover',
                style: TextStyle(
                    color: AppTheme.appGrey, fontWeight: FontWeight.w400),
              )
            ],
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Text(
              'change',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  _uploadDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 120,
            width: MediaQuery.of(context).size.width / 2,
            child: Card(
              elevation: 5,
              child: widget.deliverItem.itemImage == null
                  ? SizedBox.shrink()
                  : Image.network(
                      Constants.MEDIA_URL + widget.deliverItem.itemImage!,
                      fit: BoxFit.fill,
                    ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Icon(Icons.camera_alt_outlined, size: 30),
              //     Text(widget.deliverItem.itemImage!)
              //   ],
              // ),
            ),
          ),
          SizedBox(width: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 15.w,
                    width: 15.w,
                    child: SvgPicture.asset(
                      'assets/svg/weight.svg',
                    ),
                  ),
                  Text(
                    '${widget.tripDetail.availableLuggageWeight}',
                    style: TextStyle(
                        color: AppTheme.appGrey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 1),
                    height: 15.w,
                    width: 15.w,
                    child: SvgPicture.asset(
                      'assets/svg/money.svg',
                    ),
                  ),
                  Text(
                    '${widget.tripDetail.ratePerKg} \$/kg',
                    style: TextStyle(
                        color: AppTheme.appGrey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _header(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            //height: 250,
          ),
          painter: HeaderCurvedContainer(
            color: AppTheme.appYellow,
            dy: 150,
            y1: 250,
          ),
        ),
        Positioned(
          bottom: -40,
          child: Container(
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.only(top: 20),
              //height: 200,
              padding: const EdgeInsets.only(top: 0),
              child: TripCard(
                tripDetail: widget.tripDetail,
              )
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   border: Border.all(color: Colors.black, width: 3.0),
              //   // border: Border(bottom: BorderSide(color: Colors.black)),

              //   color: Colors.white,

              //   // image: DecorationImage(
              //   //   image: AssetImage(null),
              //   //   fit: BoxFit.cover,
              //   // ),
              // ),
              // child: Icon(Icons.person, size: 50),
              ),
        ),
        Positioned(
          top: 0,
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: AppBar(
              backgroundColor: AppTheme.appYellow,
              elevation: 0,
              // title: Text('Book Mover'),
              title: Text(
                'Book Mover',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              leading: IconButton(
                  padding: EdgeInsets.only(left: 22),
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
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
        ),
      ],
    );
  }

  _imageUploadBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, top: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showPicker,
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
                                  'assets/svg/camera_filled.svg',
                                  semanticsLabel: 'Acme Logo'),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text('Take a pic of your item'),
                            )
                          ],
                        ),
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: TextFormField(
                controller: _descriptionController,
                onSaved: (val) => _description = val,
                validator: (val) {
                  if (val!.isEmpty || val.length < 5) {
                    return 'Enter valid data';
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // suffix: Text('KG'),
                    hintText: 'Gift item description',
                    hintStyle:
                        TextStyle(color: AppTheme.appGrey, fontSize: 14.sp)),
              ),
            ),
          ),
        ],
      ),
    );
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
}
