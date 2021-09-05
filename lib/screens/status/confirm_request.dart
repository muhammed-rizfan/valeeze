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
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/payment.dart';
import 'package:valeeze/screens/send/send_complete.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/curved_painter.dart';
import 'package:valeeze/widgets/trip_card.dart';
import 'package:valeeze/widgets/upcoming_trip_card.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:http/http.dart' as http;

class ConfirmRequest extends StatefulWidget {
  final String scheduleDeliveryDetailId;
  // final ScheduledLuggageDeliveryDetail scheduledLuggageDeliveryDetail;
  final ScheduledDeliveryDetail scheduledDeliveryDetail;
  final DeliveryItem deliverItem;

  final FullCustomerData customerData;
  const ConfirmRequest(
      {Key? key,
      required this.customerData,
      required this.deliverItem,
      required this.scheduleDeliveryDetailId,
      //required this.scheduledLuggageDeliveryDetail,
      required this.scheduledDeliveryDetail})
      : super(key: key);

  @override
  _ConfirmRequestState createState() => _ConfirmRequestState();
}

class _ConfirmRequestState extends State<ConfirmRequest> {
  bool loading = true;
  late String customerName;
  late String requestingCustomer;

  @override
  void initState() {
    requestingCustomer =
        widget.scheduledDeliveryDetail.tripDetail!.customer!.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    customerName = widget.customerData.name!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: AnimatedContent(
          show: true,
          leftToRight: 5.0,
          topToBottom: 0.0,
          time: 1700,
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 1,
                child: Column(
                  children: [
                    _header(),
                    _description(),
                  ],
                ),
              ),
              _transporterDetails(),
              _messageTile(),
              _legalText(),
              SizedBox(height: 60.h),
              YellowButton(
                onPress: () async {
                  if (widget.scheduledDeliveryDetail.scheduledStatusId == 5) {
                    showSnackbar('You have already confirmed the request');
                  } else {
                    await changeStatus();
                  }
                },
                title: 'CONFIRM THE REQUEST',
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  changeStatus() async {
    String custId = widget.customerData.id!;

    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> body = {
      "scheduledDeliveryDetailId": "${widget.scheduleDeliveryDetailId}",
      "customerId": custId,
      "type": "1",
      "status": "5"
    };

    log(body.toString());

    var jsonBody = json.encode(body);

    try {
      var res = await http.post(
        Uri.parse(Constants.BASE_URL + 'changeScheduledStatus'),
        body: body,
        headers: headers,
      );

      log('response    ' + res.body);

      if (res.body.toString().contains('changed successfully')) {
        log('status changed');

        showSnackbar('Luggage confirmed succesfully');
        var route = MaterialPageRoute(
            builder: (context) => MainScreen(
                  tabIndex: 1,
                ));
        Future.delayed(const Duration(seconds: 1), () {
          // Navigator.of(context).pop();
          // Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        });
      } else {
        print('error changing status');
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
  }

  _messageTile() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: 23, right: 23),
        child: Card(
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.only(top: 15, left: 15),
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requestingCustomer,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Hi could you please take my luggage?',
                  style: TextStyle(
                      color: AppTheme.appGrey, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Weight ${widget.deliverItem.itemWeight} Kg',
                  style: TextStyle(
                      color: AppTheme.appGrey, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ));
  }

  _transporterDetails() {
    return Container(
      margin: EdgeInsets.only(top: 50.h, bottom: 20),
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
                'Requester',
                style: TextStyle(
                    color: AppTheme.appGrey, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }

  _legalText() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, top: 20, bottom: 20),
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      height: 80,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[400]!)),
        // margin: EdgeInsets.all(1),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Hi $customerName,\nI am ready to take your luggage',
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

  _options() {
    return Container(
      margin: EdgeInsets.only(top: 25.h),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('4/5'),
              Text(
                'Rating',
                style: TextStyle(color: Colors.grey[500], fontSize: 8.sp),
              ),
            ],
          ),
          SizedBox(width: 3.w),
          Icon(Icons.star, color: AppTheme.appYellow, size: 12.sp),
          Icon(Icons.star, color: AppTheme.appYellow, size: 12.sp),
          Icon(Icons.star, color: AppTheme.appYellow, size: 12.sp),
          Icon(Icons.star, color: AppTheme.appYellow, size: 12),
          Icon(Icons.star, color: Colors.grey, size: 12.sp),
          Spacer(),
          SizedBox(width: 10.w),
          Spacer(),
          Container(
            height: 15.w,
            width: 15.w,
            child: Icon(
              Icons.add_circle,
              color: AppTheme.appYellow,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'ADD TO\nTRUSTED CIRCLE ',
            style: TextStyle(color: Colors.grey[500], fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  _description() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
      child: Column(
        children: [
          Text(
            widget.customerData.name!,
            style: TextStyle(
              fontSize: 20.0.sp,
              letterSpacing: 1.5,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.customerData.customerProfile![0].biodata!,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(color: Colors.grey[500]),
          ),
          _options()
        ],
      ),
    );
  }

  _header() {
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
          bottom: 0,
          child: Container(
            width: 100.h,
            height: 100.h,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 3.0),
              color: Colors.white,
            ),
            child: Icon(Icons.person, size: 50),
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
              centerTitle: true,
              title: Text(
                'Confirm Request',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
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
              leading: IconButton(
                  padding: EdgeInsets.only(left: 22),
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
