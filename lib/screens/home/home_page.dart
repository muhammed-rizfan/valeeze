import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/animations/fade_animation.dart';
import 'package:valeeze/models/customer_model.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/find_transporter.dart';
import 'package:valeeze/screens/send/payment.dart';
import 'package:valeeze/screens/send/send_page.dart';
import 'package:valeeze/screens/send/transporter.dart';
import 'package:valeeze/screens/send/transporter_profile.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'trust_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  List<FullCustomerData> fullCustomerData = [];
  Customer customer = Customer();
  bool loading = true;
  bool profileCompleted = false;

  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  loadSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String phoneNumberFromPref = preferences.getString('mobile')!;

    customer = await Api.getCustomerFromPhone(phoneNumberFromPref);
    await preferences.setString('custId', customer.id!);
    await preferences.setString('name', customer.name!);
    await preferences.setString('country', customer.country!);
    String id = customer.id!;
    var res = await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));
    log(res.body);
    fullCustomerData = fullDataFromJson(res.body);
    if (fullCustomerData[0].customerProfile!.length != 0) {
      profileCompleted = true;
    }
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
    // if (this.mounted) {
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  int _currentIndex = 0;

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/home.png',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/lug.png',
        height: 25,
        width: 25,
        fit: BoxFit.contain,
      ),
      label: 'Lug',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/trips.png',
        height: 25,
        width: 25,
        fit: BoxFit.cover,
      ),
      label: 'Trips',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: Container(
        //   padding: EdgeInsets.all(12),
        //   height: 10,
        //   width: 10,
        //   // child: SvgPicture.asset('assets/svg/box.svg')
        //   child: Image.asset(
        //     'assets/icons/menu_icon.png',
        //     fit: BoxFit.contain,
        //     height: 10,
        //     width: 10,
        //   ),
        // ),
        actions: [
          Container(
            //padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(right: 25),
            height: 25,
            width: 25,
            // child: SvgPicture.asset('assets/svg/box.svg')
            child: Image.asset(
              'assets/icons/menu_icon.png',
              fit: BoxFit.contain,
              height: 25,
              width: 25,
            ),
          ),
        ],
        title: Container(
            height: 80,
            child: Image.asset(
              'assets/logo/logo2.png',
              fit: BoxFit.contain,
              height: 80,
            )),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Container(
                //height: MediaQuery.of(context).size.height,
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  physics: ScrollPhysics(),
                  children: [
                    _onboardImage(),
                    _textWelcome(),
                    _textBold(),
                    _buildIcons(),
                    _buildHowItWorks(),
                    // Spacer(),
                    _getStartedButton(),
                    SizedBox(height: 30)
                    // SizedBox(
                    //   height: 30.h,
                    // )
                  ],
                ),
              ),
            ),
    );
  }

  _getStartedButton() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 1000,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 26, vertical: 30.h),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Material(
          borderRadius: BorderRadius.circular(25),
          elevation: 5,
          shadowColor: AppTheme.appYellow,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.appYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: () {
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
            child: Text('GET STARTED',
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  _buildIcons() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 2000,
      child: Container(
        margin: EdgeInsets.only(top: 30.h, left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 26),
              child: CustomButton(
                icon: 'assets/svg/send)_icon.svg',
                onPress: () {
                  if (profileCompleted) {
                    var route =
                        MaterialPageRoute(builder: (context) => SendPage());
                    Navigator.push(context, route);
                  } else {
                    var profileRoute = MaterialPageRoute(
                        builder: (context) => BecomeTransporter(
                              pageId: 1,
                            ));
                    Navigator.push(context, profileRoute);
                  }
                },
                text: 'Send',
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: CustomButton(
                icon: 'assets/svg/transport.svg',
                onPress: () {
                  if (profileCompleted) {
                    var route = MaterialPageRoute(
                        builder: (context) => MainScreen(tabIndex: 2));
                    Navigator.push(context, route);
                  } else {
                    var profileRoute = MaterialPageRoute(
                        builder: (context) => BecomeTransporter(
                              pageId: 2,
                            ));
                    Navigator.push(context, profileRoute);
                  }
                },
                text: 'Transport',
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 26),
              child: CustomButton(
                icon: 'assets/svg/trust_icon.svg',
                onPress: () {
                  var route =
                      MaterialPageRoute(builder: (context) => TrustCircle());
                  Navigator.push(context, route);
                },
                text: 'Trust Circle',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _textWelcome() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 2500,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
          top: 20.h,
          left: 25,
        ),
        child: Text(
          'WELCOME',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  _textBold() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 2500,
      child: Container(
        margin: EdgeInsets.only(left: 25, top: 5),
        alignment: Alignment.centerLeft,
        child: Text(
          'Let\'s get started',
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _onboardImage() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 2800,
      child: Container(
        // color: Colors.teal,
        //alignment: Alignment.center,
        margin: EdgeInsets.only(left: 22, right: 22),
        padding: EdgeInsets.zero,
        // height: 200.h,
        height: 200.h,
        width: 400.w,
        child: SvgPicture.asset(
          'assets/svg/onboard2.svg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Container _logo() {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      alignment: Alignment.center,
      height: 150.h,
      width: 200.w,
      child: Image.asset('assets/logo/logo.png'),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _buildHowItWorks() {
    return AnimatedContent(
      show: true,
      leftToRight: 0.0,
      topToBottom: 5.0,
      time: 1500,
      child: Container(
        margin: EdgeInsets.only(top: 50.h, left: 30, right: 30),
        height: 200.h,
        // decoration: BoxDecoration(
        //   color: Colors.teal,
        //   borderRadius: BorderRadius.circular(12),
        // ),
        width: MediaQuery.of(context).size.width,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 5,
          shadowColor: Colors.white,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/video_thumbnail.png',
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
