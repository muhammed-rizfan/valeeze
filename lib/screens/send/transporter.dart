import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/deliver_item_model.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/send/transporter_profile.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/models/transporter_model.dart';

class Transporters extends StatefulWidget {
  final String? startFrom;
  final DeliveryItem deliverItem;
  final String currentUserId;
  final String? endTo;
  final String? date;
  const Transporters(
      {Key? key,
      required this.deliverItem,
      required this.currentUserId,
      this.startFrom,
      this.date,
      this.endTo})
      : super(key: key);

  @override
  _TransportersState createState() => _TransportersState();
}

class _TransportersState extends State<Transporters> {
  @override
  void initState() {
    super.initState();
    loadBuddies();
    log(widget.date!);
  }

  List<Buddies> buddiesList = [];
  bool loading = true;
  loadBuddies() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    Map requestBody = {
      "startFrom": widget.startFrom,
      "endTo": widget.endTo,
      "startDate": widget.date,
      "currentUserId": widget.currentUserId
    };

    log(requestBody.toString());

    var jsonBody = json.encode(requestBody);
    try {
      var res = await http.post(Uri.parse(Constants.BASE_URL + 'searchTrip'),
          body: jsonBody, headers: headers);

      log('buddies ' + res.body);

      buddiesList = buddiesFromJson(res.body);

      print('buddy len is+ ${buddiesList.length}');

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Angels',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
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
              'assets/icons/menu_icon.png',
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: loading
          ? Center(child: CircularProgressIndicator())
          : AnimatedContent(
              show: true,
              leftToRight: 5.0,
              topToBottom: 0.0,
              time: 1700,
              child: _buildBuddies(),
            ),
    );
  }

  _buildBuddies() {
    return buddiesList.length == 0
        ? _noBuddiesWidget()
        : Container(
            // alignment:   Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: buddiesList.length,
              itemBuilder: (context, index) {
                var itemWeight = widget.deliverItem.itemWeight;
                var moverLimit = buddiesList[index].availableLuggageWeight;
                // return BuddiesCard(
                //   buddy: buddiesList[index],
                //   count: buddiesList.length,
                //   index: index,
                //   deliverItem: widget.deliverItem,
                // );

                if (itemWeight! <= moverLimit!) {
                  return BuddiesCard(
                    buddy: buddiesList[index],
                    count: buddiesList.length,
                    index: index,
                    deliverItem: widget.deliverItem,
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          );
  }

  _noBuddiesWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50.w,
              width: 50.w,
              child: Icon(
                Icons.error_outline_outlined,
                size: 50,
                color: Colors.amber,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'No movers available',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(height: 80.h),
          _buildButton(context)
        ],
      ),
    );
  }

  Container _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 10, right: 25, left: 25),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: AppTheme.appYellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'OKAY',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class BuddiesCard extends StatelessWidget {
  final Buddies? buddy;
  final int? count;
  final int? index;
  final DeliveryItem deliverItem;
  const BuddiesCard(
      {Key? key, required this.deliverItem, this.buddy, this.count, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('buddy id' + buddy!.id!);

    var date = buddy?.travelDate;
    String fromDate = DateFormat('EEEE, d MMM').format(date!);
    var fromList = fromDate.split(',');

    var date2 = buddy?.reachDate;
    String toDate = DateFormat('EEEE, d MMM').format(date); //
    var toList = toDate.split(',');
    Color gradient1 = Color.fromRGBO(236, 237, 243, 1);
    Color gradient2 = Color.fromRGBO(255, 255, 255, 1);
    return Column(
      children: [
        index == 0
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$count Movers available',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Spacer(),
                    IconButton(icon: Icon(Icons.sort), onPressed: () {}),
                    Text(
                      'Filter',
                      style: TextStyle(fontSize: 15.sp),
                    )
                  ],
                ),
              )
            : SizedBox.shrink(),
        index == 0
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buddy!.startFrom!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        Text(
                          fromList[0],
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                        Text(
                          fromList[1],
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Divider(
                          color: AppTheme.appYellow,
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buddy!.destination!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        Text(
                          toList[0],
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                        Text(
                          toList[1],
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        Card(
          margin: EdgeInsets.only(left: 25, right: 25, top: 25),
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
            //  alignment: Alignment.center,
            height: 160,
            child: ListTile(
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (context) => TransporterProfile(
                          buddy: buddy!,
                          deliverItem: deliverItem,
                        ));
                Navigator.push(context, route);
              },
              // leading:
              //
              // Container(
              //   // margin: EdgeInsets.only(top: 30),
              //   height: 80,
              //   width: 80,
              //   decoration:
              //       BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
              // ),

              // leading: CircleAvatar(
              //   radius: 50,
              //   backgroundImage:
              //       AssetImage('assets/images/video_thumbnail.png'),
              // ),
              title: FittedBox(
                child: SizedBox(
                  height: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(right: 15, left: 0),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/video_thumbnail.png'),
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
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              buddy!.customer!.name!,
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
                                    ' ${buddy!.availableLuggageWeight.toString()} Kg available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    //  alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                        'assets/svg/money.svg',
                                        color: AppTheme.appYellow,
                                        semanticsLabel: 'money'),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    ' ${buddy?.ratePerKg.toString()} \$/Kg',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star, color: Colors.grey, size: 15),
                              ],
                            ),
                          ),
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
                                    child:
                                        Image.asset('assets/images/flight.png'),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'B777 - EK225',
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
                      SizedBox(width: 15),

                      // Container(
                      //   decoration: BoxDecoration(boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey,
                      //     )
                      //   ]),
                      //   child: VerticalDivider(
                      //     color: Colors.grey[200],
                      //     thickness: 0.8,
                      //     width: 0.8,
                      //   ),
                      // ),
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
                          ),
                        ),
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
}
