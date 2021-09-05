import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/transporter_model.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/send/booking_summary.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/curved_painter.dart';
import 'package:valeeze/widgets/upcoming_trip_card.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/models/deliver_items_with_schedule.dart';

class TransporterProfile extends StatefulWidget {
  final Buddies buddy;
  final DeliveryItem deliverItem;

  const TransporterProfile(
      {Key? key, required this.deliverItem, required this.buddy})
      : super(key: key);

  @override
  _TransporterProfileState createState() => _TransporterProfileState();
}

class _TransporterProfileState extends State<TransporterProfile> {
  List<FullCustomerData> fullCustomerData = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadCustomerTrips(widget.buddy.customer!.id!);
  }

  List<TripDetails> _trips = [];

  loadCustomerTrips(String id) async {
    var res = await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));

    fullCustomerData = fullDataFromJson(res.body);

    if (fullCustomerData[0].customerProfile!.length != 0) {
      _trips = fullCustomerData[0].tripDetail!;
    }

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
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _header(),
                          _description(),
                        ],
                      ),
                    ),
                    // _pricAndWeight(),
                    // Container(
                    //     margin: EdgeInsets.only(top: 25.h),
                    //     child: Text('Upcoming Trips')),
                    _upcomingTrips(),
                  ],
                ),
              ),
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
                'Mover Profile',
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

  _description() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
      child: Column(
        children: [
          Text(
            widget.buddy.customer!.name!,
            style: TextStyle(
              fontSize: 20.0.sp,
              letterSpacing: 1.5,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.buddy.customer!.customerProfile![0].biodata!,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(color: Colors.grey[500]),
          ),
          _options()
        ],
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

  _pricAndWeight() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20.w,
            width: 20.w,
            child: SvgPicture.asset(
              'assets/svg/weight.svg',
              height: 20.w,
              width: 20.w,
            ),
          ),
          Text(
            '1 KG Available',
            style:
                TextStyle(color: AppTheme.appGrey, fontWeight: FontWeight.w800),
          ),
          SizedBox(width: 25.w),
          Container(
            height: 20.w,
            width: 20.w,
            child: SvgPicture.asset(
              'assets/svg/money.svg',
              height: 20.w,
              width: 20.w,
            ),
          ),
          Text(' 10 \$/kg',
              style: TextStyle(
                  color: AppTheme.appGrey, fontWeight: FontWeight.w800))
        ],
      ),
    );
  }

  _upcomingTrips() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
          physics: ScrollPhysics(),
          itemCount: _trips.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripDetails selectedTrip = _trips.firstWhere(
                (element) => element.id == widget.buddy.id,
                orElse: null);
            return GestureDetector(
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (context) => BookingSummary(
                          tripDetail: _trips[index],
                          deliverItem: widget.deliverItem,
                        ));
                Navigator.push(context, route);
              },
              child: index == 0
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text('Selected Trip'),
                        ),
                        UpcomingTripCard(
                          trip: selectedTrip,
                          currentTripId: widget.buddy.id!,
                          index: index,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text('Upcoming Trips'),
                        ),
                      ],
                    )
                  : UpcomingTripCard(
                      trip: _trips[index],
                      currentTripId: widget.buddy.id!,
                      index: index,
                    ),
            );
          }),
    );
  }
}
