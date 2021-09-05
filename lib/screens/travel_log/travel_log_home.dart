import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/customer_model.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/send/send_page.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/custom_separator.dart';
import 'package:valeeze/widgets/screen_progress.dart';
import 'package:valeeze/widgets/luggage_card.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/models/deliver_item_model.dart';

class TravelLogHome extends StatefulWidget {
  @override
  _TravelLogHomeState createState() => _TravelLogHomeState();
}

class _TravelLogHomeState extends State<TravelLogHome> {
  List<DeliveryItem> _deliveryItems = [];

  List<DeliveryItemsWithSchedule> _items = [];
  List<FullCustomerData> fullCustomerData = [];
  bool profileCompleted = false;
  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  bool loading = true;
  String userNameFromPref = '';
  late String currentUserId;
  loadSharedPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String phoneNumberFromPref = preferences.getString('mobile')!;
      userNameFromPref = preferences.getString('name')!;

      // customer = await Api.getCustomerFromPhone(phoneNumberFromPref);
      // String id = customer.id!;
      String customerIdFromPref = preferences.getString('custId')!;

      currentUserId = customerIdFromPref;
      var res = await http.get(
          Uri.parse(Constants.BASE_URL + 'getCustomer/$customerIdFromPref'));
      log(res.body);
      fullCustomerData = fullDataFromJson(res.body);
      if (fullCustomerData[0].customerProfile!.length != 0) {
        profileCompleted = true;
      }
      await loadScheduledDelivers(customerIdFromPref);
    } catch (e) {
      log(e.toString() + 'zz');
    }
    //await getDeliveryItem(id);
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  loadScheduledDelivers(String custID) async {
    try {
      var res = await http.get(Uri.parse(Constants.BASE_URL +
          'getScheduledDeliveriDetailsFromCustomerId/$custID'));

      //Map<String, dynamic> map = json.decode(res.body);
      _items = deliveryItemsWithScheduleFromJson(res.body);
    } catch (e) {
      log(e.toString());
    }
  }

  getDeliveryItem(String id) async {
    // var res =
    //     await http.get(Uri.parse(Constants.BASE_URL + 'getDeliverItem/$id'));
    // log(res.body);
    //_items = deliverItemsFromJson(res.body);

    // _items.sort((a, b) => a.createdAt!.millisecondsSinceEpoch
    //     .compareTo(b.createdAt!.millisecondsSinceEpoch));
    // _items.reversed;
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
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: Image.asset(
            'assets/logo/logo2.png',
            fit: BoxFit.contain,
            height: 80,
          ),
        ),
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

        //  centerTitle: true,
        // actions: [
        //   Container(
        //     height: 100,
        //     width: 100,
        //     color: Colors.teal,
        //     child: Image.asset(
        //       'assets/logo/logo2.png',
        //       fit: BoxFit.fill,
        //       height: 80,
        //     ),
        //   ),
        // ],

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
                    _image(),
                    _lugIcon(),
                    ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: _items[0].deliveryItem!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return LuggageCard(
                            deliverItem: _items[0].deliveryItem![index],
                            ticks: 1,
                            currentId: currentUserId,
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }

  _lugIcon() {
    return GestureDetector(
      onTap: () {
        if (profileCompleted) {
          var route = MaterialPageRoute(builder: (context) => SendPage());
          Navigator.push(context, route);
        } else {
          var profileRoute = MaterialPageRoute(
              builder: (context) => BecomeTransporter(
                    pageId: 1,
                  ));
          Navigator.push(context, profileRoute);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 27),
        height: 65,
        width: 85,
        decoration: BoxDecoration(
          color: AppTheme.appYellow,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(6),
          shadowColor: Colors.white,
          color: AppTheme.appYellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                child: SvgPicture.asset(
                  'assets/svg/travel_bag.svg',
                  fit: BoxFit.contain,
                ),
              ),
              Icon(
                Icons.add_circle_outlined,
                size: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  'Add new lug',
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

  _image() {
    return Center(
      child: Container(
        height: 200.w,
        width: 300.w,
        child: SvgPicture.asset(
          'assets/svg/add-lug-banner.svg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _buildTripCards(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 20),
      height: 270,
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
                    'DXB',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp,
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
                    'SFO',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp,
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    height: 30.w,
                    width: 120.w,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.appYellow,
                        )),
                    child: Text(
                      'Approve Request',
                      style: TextStyle(
                        color: AppTheme.appYellow,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                'Saturday 20 Jun',
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
                    '1 KG',
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
                    '\$ 10',
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
                    'B77 - EK225',
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
                    'John Davis',
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
                    'Trip Value is \$ 10',
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
              child: ScreenProgress(ticks: 2, width: 10, pad: 1),
            ),
          ],
        ),
      ),
    );
  }
}
