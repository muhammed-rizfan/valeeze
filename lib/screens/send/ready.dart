import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/deliver_item_model.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/find_transporter.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:http/http.dart' as http;

class SendReady extends StatefulWidget {
  const SendReady({Key? key}) : super(key: key);

  @override
  _SendReadyState createState() => _SendReadyState();
}

class _SendReadyState extends State<SendReady> {
  bool loading = true;
  // List<DeliverItem> _items = [];
  List<DeliveryItem> _items = [];
  DeliveryItem _currentItem = DeliveryItem();
  List<DeliveryItemsWithSchedule> _allItemsWithSchedule = [];
  late String currentUserId;
  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  loadSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = await preferences.getString('custId')!;
    currentUserId = id;
    await getDeliveryItem(id);
    setState(() {
      loading = false;
    });
  }

  getDeliveryItem(String id) async {
    var res = await http.get(Uri.parse(
        Constants.BASE_URL + 'getScheduledDeliveriDetailsFromCustomerId/$id'));
    log(res.body);
    //  _items = deliverItemsFromJson(res.body);
    _allItemsWithSchedule = deliveryItemsWithScheduleFromJson(res.body);
    _items = _allItemsWithSchedule[0].deliveryItem!;
    _items.sort((a, b) => a.createdAt!.millisecondsSinceEpoch
        .compareTo(b.createdAt!.millisecondsSinceEpoch));
    _currentItem = _items.last;
    log(' zzz' + _currentItem.itemImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  _greenTick(),
                  SizedBox(
                    height: 20.h,
                  ),
                  _readyToGo(),
                  SizedBox(
                    height: 100.h,
                  ),
                  _findTransporterButton(context),
                ],
              ),
            ),
    );
  }

  _greenTick() {
    return Container(
      alignment: Alignment.center,
      // height: 50,
      // width: 50,
      child: SvgPicture.asset(
        'assets/svg/done.svg',
        height: 50,
        color: Colors.lightGreen,
      ),

      // child: Icon(
      //   Icons.check_circle_outline_outlined,
      //   size: 50.sp,
      //   color: Colors.lightGreen,
      // ),
    );
  }

  _readyToGo() {
    return Container(
      child: Text(
        'You are ready to go',
        style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w200),
      ),
    );
  }

  _findTransporterButton(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        shadowColor: AppTheme.appYellow,
        child: TextButton(
          style: TextButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: AppTheme.appYellow,
              padding: EdgeInsets.symmetric(horizontal: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            //TODO - check route here
            var route = MaterialPageRoute(
                builder: (context) => FindTransporter(
                      deliverItem: _currentItem,
                      currentUserId: currentUserId,
                    ));
            // Navigator.push(context, route);
            pushNewScreen(context,
                screen: FindTransporter(
                  deliverItem: _currentItem,
                  currentUserId: currentUserId,
                ),
                withNavBar: false);
          },
          child: Text(
            'FIND YOUR ANGEL',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
