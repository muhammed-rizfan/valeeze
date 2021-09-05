import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/transporter/add_new_trip.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/screens/transporter/view_requests.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'dart:math' as math;

import 'package:valeeze/widgets/custom_separator.dart';
import 'package:valeeze/widgets/screen_progress.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/models/trip_model.dart';

class TripsHome extends StatefulWidget {
  const TripsHome({Key? key}) : super(key: key);

  @override
  _TripsHomeState createState() => _TripsHomeState();
}

class _TripsHomeState extends State<TripsHome> {
  List<FullCustomerData> fullCustomerData = [];
  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  bool loading = true;
  bool profileCompleted = false;
  String nameFromPref = '';
  loadTrips() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      String custId = preferences.getString('custId')!;
      nameFromPref = preferences.getString('name')!;
      var res =
          await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$custId'));

      fullCustomerData = fullDataFromJson(res.body);
      if (fullCustomerData[0].customerProfile!.length != 0) {
        profileCompleted = true;
      }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: Container(
        //     padding: EdgeInsets.all(12),
        //     height: 10,
        //     width: 10,
        //     child: Image.asset(
        //       'assets/icons/menu_icon.png',
        //       fit: BoxFit.contain,
        //       height: 10,
        //       width: 10,
        //     )),
        title: Container(
            height: 80,
            child: Image.asset(
              'assets/logo/logo2.png',
              fit: BoxFit.contain,
              height: 80,
            )),
        centerTitle: true,
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Spacer(),
        //     Transform.translate(
        //       offset: Offset(25, 0),
        //       child: Container(
        //         height: 80,
        //         padding: EdgeInsets.zero,
        //         margin: EdgeInsets.zero,
        //         child: Image.asset(
        //           'assets/logo/logo2.png',
        //           fit: BoxFit.contain,
        //           height: 80,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 25),
              // padding: EdgeInsets.all(12),
              height: 25,
              width: 25,
              child: Image.asset(
                'assets/icons/menu_icon.png',
                fit: BoxFit.contain,
                height: 25,
                width: 25,
              )),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AnimatedContent(
                show: true,
                leftToRight: 5.0,
                topToBottom: 0.0,
                time: 2200,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: _image(),
                    ),
                    _tripIcon(),
                    fullCustomerData.length != 0
                        ? _buildTripCards(context)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
    );
  }

  _buildTripCards(BuildContext context) {
    List<TripDetails> _trips = [];
    _trips = fullCustomerData[0].tripDetail!;
    _trips.sort((a, b) => a.travelDate!.compareTo(b.travelDate!));

    log(_trips.length.toString());

    return ListView.builder(
        physics: ScrollPhysics(),
        itemCount: _trips.length,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (context, index) {
          // log('zzz' +
          //     _trips[index].scheduledDeliveryDetails!.length.toString());
          return CustomerTripCard(
            tripDetail: _trips[index],
            customerName: nameFromPref,
          );
        });
  }

  _tripIcon() {
    return GestureDetector(
      onTap: () async {
        if (profileCompleted) {
          var route = MaterialPageRoute(builder: (context) => AddNewTrip());

          await Navigator.push(context, route);
        } else {
          var route = MaterialPageRoute(
              builder: (context) => BecomeTransporter(pageId: 2));
          Navigator.pushReplacement(context, route);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 27.5),
        height: 65,
        width: 85,
        decoration: BoxDecoration(
          color: AppTheme.appYellow,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(6),
          shadowColor: AppTheme.appYellow,
          color: AppTheme.appYellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(Icons.location_on_outlined, size: 25),
              SvgPicture.asset(
                'assets/svg/address_icon.svg',
                height: 25,
                width: 25,
                fit: BoxFit.contain,
              ),
              Icon(
                Icons.add_circle_outlined,
                size: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Add new trip',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPress() {
    var route = MaterialPageRoute(builder: (context) => AddNewTrip());
    Navigator.push(context, route);
  }

  _image() {
    return Container(
      height: 200.w,
      width: 200.w,
      child: SvgPicture.asset('assets/svg/trip-banner.svg'),
    );
  }
}

class CustomerTripCard extends StatelessWidget {
  final TripDetails? tripDetail;
  final String customerName;

  const CustomerTripCard(
      {Key? key, required this.tripDetail, required this.customerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(tripDetail!.travelDate.toString());
    var date = tripDetail!.travelDate;
    String fromDate = DateFormat('EEEE, d MMM').format(date!);
    //log(fromDate);

    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 25),
      height: 280,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    tripDetail!.startFrom!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: tripDetail!.startFrom!.length > 4 ? 12 : 22.sp,
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
                    tripDetail!.destination!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize:
                          tripDetail!.destination!.length > 4 ? 12 : 22.sp,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      var route = MaterialPageRoute(
                          builder: (context) => ViewLuggageRequests(
                                scheduledLuggageDeliveryDetails:
                                    tripDetail?.scheduledDeliveryDetails,
                                customerId: tripDetail!.customerId!,
                                tripDetails: tripDetail!,
                              ));
                      Navigator.push(context, route);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.w,
                      width: 120.w,
                      //  padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.appYellow,
                        ),
                      ),
                      child: Text(
                        'View Requests',
                        style: TextStyle(
                          color: AppTheme.appYellow,
                          fontWeight: FontWeight.w400,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                fromDate,
                style: TextStyle(
                  color: AppTheme.appGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                children: [
                  Container(
                    height: 20.w,
                    width: 20.w,
                    child: SvgPicture.asset('assets/svg/weight.svg'),
                  ),
                  SizedBox(width: 2),
                  Text(
                    tripDetail!.availableLuggageWeight.toString(),
                    style: TextStyle(
                        color: AppTheme.appGrey, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 15),
                  Container(
                    height: 20.w,
                    width: 20.w,
                    child: SvgPicture.asset('assets/svg/money.svg'),
                  ),
                  Text(
                    '\$ ${tripDetail!.ratePerKg.toString()}',
                    style: TextStyle(
                        color: AppTheme.appGrey, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 25),
                  Container(
                    height: 20.w,
                    width: 20.w,
                    child: Image.asset('assets/images/flight.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    tripDetail!.vehicleName!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person_outline,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    customerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 20.w,
                    width: 20.w,
                    child: SvgPicture.asset('assets/svg/money.svg'),
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Trip Value is \$ ${tripDetail!.ratePerKg.toString()}',
                    style: TextStyle(
                      color: AppTheme.appGrey,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
              child: CustomSeparator(color: Colors.grey[500]!, height: .5),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 2, left: 20),
              child: Text(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10.sp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ScreenProgress(
                  //  ticks: tripDetail!.deliveryStatusId!,
                  ticks: 0,
                  width: 10,
                  pad: 1),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 15, right: 15, top: 10, bottom: 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           // if (status == 'Requested') {
            //           //   var route = MaterialPageRoute(
            //           //       builder: (context) => TransportersFromSchedule(
            //           //             scheduledDeliveries:
            //           //                 deliverItem.scheduledDeliveryDetails!,
            //           //           ));
            //           //   Navigator.push(context, route);
            //           // }
            //         },
            //         child: Container(
            //           alignment: Alignment.center,
            //           height: 30,
            //           width: 120,
            //           //  padding: EdgeInsets.symmetric(horizontal: 5),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(
            //               color: AppTheme.appYellow,
            //             ),
            //           ),
            //           child: Text(
            //             'accept' + '1',
            //             style: TextStyle(
            //               color: AppTheme.appYellow,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 13.sp,
            //             ),
            //           ),
            //         ),
            //       ),
            //       // Text(
            //       //   status + ': $count',
            //       //   style: TextStyle(color: Colors.black),
            //       // ),
            //       GestureDetector(
            //         onTap: () {
            //           // var route = MaterialPageRoute(
            //           //     builder: (context) => FindTransporter(
            //           //           deliverItem: deliverItem,
            //           //         ));
            //           // Navigator.push(context, route);
            //         },
            //         child: Container(
            //           alignment: Alignment.center,
            //           height: 30,
            //           width: 120,
            //           //  padding: EdgeInsets.symmetric(horizontal: 5),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(
            //               color: AppTheme.appYellow,
            //             ),
            //           ),
            //           child: Text(
            //             'Find Movers',
            //             style: TextStyle(
            //               color: AppTheme.appYellow,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 13.sp,
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
