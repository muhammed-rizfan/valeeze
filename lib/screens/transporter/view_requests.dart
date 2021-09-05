import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valeeze/models/single_delivery_item.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/providers/status_provider.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/status/accept_request.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewLuggageRequests extends StatefulWidget {
  final List<ScheduledLuggageDeliveryDetail>? scheduledLuggageDeliveryDetails;
  final String customerId;
  final TripDetails tripDetails;

  const ViewLuggageRequests({
    Key? key,
    required this.scheduledLuggageDeliveryDetails,
    required this.tripDetails,
    required this.customerId,
  }) : super(key: key);

  @override
  _ViewLuggageRequestsState createState() => _ViewLuggageRequestsState();
}

class _ViewLuggageRequestsState extends State<ViewLuggageRequests> {
  List<SingleDeliveryItem> _deliveryItems = [];
  @override
  void initState() {
    loadItems();
  }

  bool loading = true;

  loadItems() async {
    List<SingleDeliveryItem> itemsList = [];

    SingleDeliveryItem item = SingleDeliveryItem();
    for (int i = 0; i < widget.scheduledLuggageDeliveryDetails!.length; i++) {
      String id = widget.scheduledLuggageDeliveryDetails![i].deliveryItemId!;
      var res = await http
          .get(Uri.parse(Constants.BASE_URL + 'getDeliverItemFromId/$id'));
      itemsList = singleDeliveryItemFromJson(res.body);
      item = itemsList[0];
      _deliveryItems.add(item);
    }
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Luggage Requests',
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
              'assets/icons/menu_icon.png',
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _deliveryItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return LuggageRequestCard(
                          deliveryItem: _deliveryItems[index],
                          //  scheduleDeliveryId: _deliveryItems[index].id!,
                          scheduleDeliveryId: widget
                              .scheduledLuggageDeliveryDetails![index].id!,
                          customerId: widget.customerId,
                          statusId: widget
                              .scheduledLuggageDeliveryDetails![index]
                              .scheduledStatusId!,
                          refreshWidget: this.widget,
                          scheduledLuggageDeliveryDetail:
                              widget.scheduledLuggageDeliveryDetails![index],
                        );
                      }),
                )
              ],
            ),
    );
  }
}

class LuggageRequestCard extends StatefulWidget {
  final SingleDeliveryItem deliveryItem;
  final ScheduledLuggageDeliveryDetail scheduledLuggageDeliveryDetail;
  final String scheduleDeliveryId;
  final String customerId;
  final int statusId;
  final Widget refreshWidget;

  const LuggageRequestCard({
    Key? key,
    required this.deliveryItem,
    required this.customerId,
    required this.scheduleDeliveryId,
    required this.scheduledLuggageDeliveryDetail,
    required this.statusId,
    required this.refreshWidget,
  }) : super(key: key);

  @override
  _LuggageRequestCardState createState() => _LuggageRequestCardState();
}

class _LuggageRequestCardState extends State<LuggageRequestCard> {
  List<FullCustomerData> fullCustomerData = [];
  CustomerProfile customerProfile = CustomerProfile();
  String customerName = '';
  Color gradient1 = Color.fromRGBO(236, 237, 243, 1);
  Color gradient2 = Color.fromRGBO(255, 255, 255, 1);
  void initState() {
    super.initState();
    loadCustomer();
  }

  loadCustomer() async {
    String id = widget.customerId;
    var res = await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));
    fullCustomerData = fullDataFromJson(res.body);
    customerName = fullCustomerData[0].name!;
    customerProfile = fullCustomerData[0].customerProfile![0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(left: 25.w, right: 25, top: 25),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradient1, gradient2],
              ),
            ),
            height: 140,
            child: ListTile(
              onTap: () {
                var route = MaterialPageRoute(
                  builder: (context) => AcceptRequest(
                    scheduleDeliveryDetailId: widget.scheduleDeliveryId,
                    customerData: fullCustomerData[0],
                    scheduledLuggageDeliveryDetail:
                        widget.scheduledLuggageDeliveryDetail,
                    deliveryItem: widget.deliveryItem,
                  ),
                );
                Navigator.push(context, route);
              },

              title: FittedBox(
                child: SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(right: 15, left: 0),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(Constants.MEDIA_URL +
                                    '${widget.deliveryItem.itemImage}'),
                                fit: BoxFit.cover),
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                      ),
                      // CircleAvatar(
                      //   radius: 20,
                      //   backgroundImage:
                      //       AssetImage('assets/images/video_thumbnail.png'),
                      // ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              customerName,
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    //  alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                        'assets/svg/weight.svg',
                                        color: AppTheme.appYellow,
                                        semanticsLabel: 'weight'),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Weight: ${widget.deliveryItem.itemWeight} Kg',
                                    style: TextStyle(
                                        color: AppTheme.appGrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(width: 10),
                                  // Container(
                                  //   //  alignment: Alignment.center,
                                  //   height: 20,
                                  //   width: 20,
                                  //   child: SvgPicture.asset(
                                  //       'assets/svg/money.svg',
                                  //       color: AppTheme.appYellow,
                                  //       semanticsLabel: 'money'),
                                  // ),
                                  SizedBox(width: 2),
                                  // Text(
                                  //   '12 \$/Kg',
                                  //   style: TextStyle(color: Colors.grey),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 10),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Icon(Icons.star,
                          //           color: AppTheme.appYellow, size: 15),
                          //       Icon(Icons.star,
                          //           color: AppTheme.appYellow, size: 15),
                          //       Icon(Icons.star,
                          //           color: AppTheme.appYellow, size: 15),
                          //       Icon(Icons.star,
                          //           color: AppTheme.appYellow, size: 15),
                          //       Icon(Icons.star, color: Colors.grey, size: 15),
                          //     ],
                          //   ),
                          // ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Icon(Icons.flag, color: Colors.green),
                                  Container(
                                      height: 20.w,
                                      width: 20.w,
                                      child: Text(' ')
                                      // Image.asset('assets/images/flight.png'),
                                      ),
                                  SizedBox(width: 5),
                                  Text(
                                    ' ',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 50),

                      VerticalDivider(
                        color: Colors.grey[200],
                        thickness: 0.8,
                        width: 0.8,
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 0),
                        height: 150,
                        width: 20,
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              // trailing: Container(
              //   alignment: Alignment.center,
              //   height: 150,
              //   width: 20,
              //   color: Colors.teal,
              //   child: Center(child: Icon(Icons.arrow_forward_ios)),
              // ),
            ),
          ),
        )
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

  Text getCurrentStatusText(int statusId) {
    String status = 'Accept';
    Text statusText = Text(
      status,
      style: TextStyle(
        color: AppTheme.appYellow,
        fontWeight: FontWeight.w400,
      ),
    );

    if (statusId == 1) {
      return statusText;
    } else if (statusId == 2) {
      return Text(
        'Accepted',
        style: TextStyle(
          color: Colors.lightGreen,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (statusId == 3) {
      return Text(
        'Rejected',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (statusId == 4) {
      return Text(
        'Cancelled',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        'Confirmed',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  changeStatus(int status, StatusProvider statusProvider) async {
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> body = {
      "scheduledDeliveryDetailId": "${widget.scheduleDeliveryId}",
      "customerId": "${widget.customerId}",
      "type": "1",
      "status": "2"
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

        showSnackbar('Accepted succesfully');
        var route = MaterialPageRoute(builder: (context) => MainScreen());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
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

  refreshPage() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => widget.refreshWidget));
  }
}
