import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:valeeze/models/deliver_item_model.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/find_transporter.dart';
import 'package:valeeze/screens/transporter/buddy_request_page.dart';
import 'package:valeeze/screens/travel_log/transporters_from_schedule.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/custom_separator.dart';
import 'package:valeeze/widgets/screen_progress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class LuggageCard extends StatefulWidget {
  final DeliveryItem deliverItem;
  final String currentId;

  final int ticks;
  LuggageCard({
    Key? key,
    required this.deliverItem,
    required this.ticks,
    required this.currentId,
  }) : super(key: key);

  @override
  _LuggageCardState createState() => _LuggageCardState();
}

class _LuggageCardState extends State<LuggageCard> {
  String status = "Scheduled";

  String count = '';

  String vehicleNumber = "";

  String dummyImage =
      'https://lab.csschopper.com/placeholder/images/placeholder_image_logo.png';

  @override
  Widget build(BuildContext context) {
    String source = widget.deliverItem.itemFrom.toString();

    String destination = widget.deliverItem.itemTo.toString();
    String itemImage = widget.deliverItem.itemImage == null
        ? dummyImage
        : Constants.MEDIA_URL + widget.deliverItem.itemImage!;
    String weight = widget.deliverItem.itemWeight.toString();
    String price = widget.deliverItem.itemValue.toString();

    if (widget.deliverItem.scheduledDeliveryDetails!.isNotEmpty) {
      // log(deliverItem.scheduledDeliveryDetails![0].scheduledStatus!.status
      //     .toString());

      // deliverItem.scheduledDeliveryDetails!.forEach((element) {
      //   return log('xxxx' + element.tripDetail!.startFrom!);
      // });
      status = widget
          .deliverItem.scheduledDeliveryDetails![0].scheduledStatus!.status
          .toString();
      count = " : " +
          widget.deliverItem.scheduledDeliveryDetails!.length.toString();
      vehicleNumber = widget
          .deliverItem.scheduledDeliveryDetails![0].tripDetail!.vehicleName!;
    }
    var date = widget.deliverItem.createdAt;

    log(status);

    String addedDate = DateFormat('EEEE, d MMM').format(date!);
    String customerId = widget.deliverItem.customerId!;
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 25),
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Card(
        elevation: 3,
        color: Colors.white,
        // margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0.0, -25),
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.zero,
                        // alignment: Alignment.topCenter,
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                            )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(itemImage, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  source,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'To',
                                  style: TextStyle(
                                    color: AppTheme.appGrey,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  destination,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                status == 'Accepted'
                                    ? Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            log('taped top find mover');
                                            var route = MaterialPageRoute(
                                                builder: (context) =>
                                                    TransportersFromSchedule(
                                                      scheduledDeliveries: widget
                                                          .deliverItem
                                                          .scheduledDeliveryDetails!,
                                                      status: status,
                                                      customerId: customerId,
                                                      deliveryItem:
                                                          widget.deliverItem,
                                                    ));
                                            Navigator.push(context, route);
                                            // var route = MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         FindTransporter(
                                            //           deliverItem:
                                            //               widget.deliverItem,
                                            //           currentUserId:
                                            //               widget.currentId,
                                            //         ));
                                            // Navigator.push(context, route);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: 120,
                                            //  padding: EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                            ),
                                            child: Text(
                                              status + '$count',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            // child: Text(
                                            //   'View Requests',
                                            //   //  status != 'Accepted' ? 'Find Movers' : 'Confirm',
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.w400,
                                            //     fontSize: 13,
                                            //     // color: Colors.red,
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 3),
                            child: Text(
                              addedDate,
                              style: TextStyle(
                                color: AppTheme.appGrey,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 13),
                              child: Row(
                                children: [
                                  Container(
                                    height: 20.w,
                                    width: 20.w,
                                    child: SvgPicture.asset(
                                        'assets/svg/weight.svg'),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    weight,
                                    style: TextStyle(
                                        color: AppTheme.appGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 20.w,
                                    width: 20.w,
                                    child: SvgPicture.asset(
                                        'assets/svg/money.svg'),
                                  ),
                                  Text(
                                    '\$ ${price}',
                                    style: TextStyle(
                                        color: AppTheme.appGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 15),
                                  vehicleNumber == ""
                                      ? SizedBox.shrink()
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/images/flight.png'),
                                        ),
                                  SizedBox(width: 10),
                                  Text(
                                    vehicleNumber,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Transform.translate(
                            //old value is (-75,0)
                            offset: Offset(0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                getStatusText(),
                                // status == 'Scheduled'
                                //     ? 'Status: You have scheduled a delivery.\nClick on  \'Find Movers\' and\nrequest for transport'
                                //     : 'You have requested for the movers.\nClick on "Requested"\nto view the details',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppTheme.appGrey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(left: 0, top: 10, right: 8),
                          //   child: Row(
                          //     children: [
                          //       // Text(
                          //       //   passengerName + ' 555',
                          //       //   textAlign: TextAlign.center,
                          //       //   softWrap: true,
                          //       //   style: TextStyle(
                          //       //     fontWeight: FontWeight.bold,
                          //       //     fontSize: 18,
                          //       //   ),
                          //       // ),
                          //       SizedBox(width: 12),
                          //       Container(
                          //         height: 20,
                          //         width: 20,
                          //         child: SvgPicture.asset('assets/svg/money.svg'),
                          //       ),
                          //       SizedBox(width: 2),
                          //       Text(
                          //         'Trip Value is \$ ${tripValue}',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           color: AppTheme.appGrey,
                          //           fontSize: 10,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: CustomSeparator(color: Colors.grey[500]!, height: .5),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8, bottom: 2, left: 20),
            //   child: Text(
            //     'Progress',
            //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10.sp),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15),
            //   child: ScreenProgress(ticks: ticks, width: 10, pad: 1),
            // ),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  status == 'Accepted'
                      ? GestureDetector(
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (context) => TransportersFromSchedule(
                                      scheduledDeliveries: widget.deliverItem
                                          .scheduledDeliveryDetails!,
                                      status: 'Requested',
                                      customerId: customerId,
                                      deliveryItem: widget.deliverItem,
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 120,
                            //  padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            child: Text(
                              'Requested' + '$count',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (status == 'Requested') {
                              var route = MaterialPageRoute(
                                  builder: (context) =>
                                      TransportersFromSchedule(
                                        scheduledDeliveries: widget.deliverItem
                                            .scheduledDeliveryDetails!,
                                        status: status,
                                        customerId: customerId,
                                        deliveryItem: widget.deliverItem,
                                      ));
                              Navigator.push(context, route);
                            } else if (status == 'Accepted') {
                              var route = MaterialPageRoute(
                                  builder: (context) =>
                                      TransportersFromSchedule(
                                        scheduledDeliveries: widget.deliverItem
                                            .scheduledDeliveryDetails!,
                                        status: status,
                                        customerId: customerId,
                                        deliveryItem: widget.deliverItem,
                                      ));
                              Navigator.push(context, route);
                            } else if (status == 'Confirmed') {
                              var route = MaterialPageRoute(
                                  builder: (context) =>
                                      TransportersFromSchedule(
                                        scheduledDeliveries: widget.deliverItem
                                            .scheduledDeliveryDetails!,
                                        status: status,
                                        customerId: customerId,
                                        deliveryItem: widget.deliverItem,
                                      ));
                              Navigator.push(context, route);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 120,
                            //  padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            child: Text(
                              status + '$count',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                  GestureDetector(
                    onTap: () async {
                      log('taped bottom find mover');
                      var route = MaterialPageRoute(
                          builder: (context) => FindTransporter(
                                deliverItem: widget.deliverItem,
                                currentUserId: widget.currentId,
                              ));
                      //  Navigator.push(context, route);
                      pushNewScreen(context,
                          screen: FindTransporter(
                            deliverItem: widget.deliverItem,
                            currentUserId: widget.currentId,
                          ),
                          withNavBar: false);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 120,
                      //  padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                      child: Text(
                        'Find Movers',
                        //  status != 'Accepted' ? 'Find Movers' : 'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeStatus(int status) async {
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> body = {
      "scheduledDeliveryDetailId":
          "${widget.deliverItem.scheduledDeliveryDetails![0].id}",
      "customerId": "${widget.deliverItem.customerId}",
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

        showSnackbar('Confirmed succesfully');
        var route = MaterialPageRoute(builder: (context) => this.widget);
        Navigator.pushReplacement(context, route);
        // statusProvider.updateStatus(status);
        // refreshPage();
      } else {
        print('error changing status');
      }
      print(res.body);
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

  String getStatusText() {
    String stat = 'Scheduled';
    if (status == 'Scheduled') {
      stat =
          'Status: You have scheduled a delivery.\nClick on  \'Find Movers\' and\nrequest for transport';
    } else if (status == 'Accepted') {
      stat = 'Your delivery item is accepted.\nPlease confirm the same';
    } else if (status == 'Confirmed') {
      stat = 'Your delivery item is confirmed.';
    }

    return stat;
  }
}
