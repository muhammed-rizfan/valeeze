import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/screens/send/send_complete.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/yellow_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool selected = true;
  bool _wallet = true;
  bool _applePay = false;
  bool _bank = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Payment & wallet'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.menu),
          ),
        ],
      ),
      body: AnimatedContent(
        show: true,
        leftToRight: 5.0,
        topToBottom: 0.0,
        time: 1700,
        child: Column(
          children: [
            _totalAmount(),
            _paymentMethods(),
            Spacer(),
            // Container(
            //   margin: EdgeInsets.only(bottom: 50.h),
            //   // decoration: BoxDecoration(
            //   //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
            //   height: 60.h,
            //   width: 300.w,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //         backgroundColor: AppTheme.appYellow,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30))),
            //     onPressed: () {
            //       var route =
            //           MaterialPageRoute(builder: (context) => SendComplete());
            //       Navigator.of(context).push(route);
            //     },
            //     child: Text(
            //       'DONE',
            //       style: TextStyle(color: Colors.black, fontSize: 18.sp),
            //     ),
            //   ),
            // )

            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: YellowButton(
                onPress: () {
                  var route =
                      MaterialPageRoute(builder: (context) => SendComplete());
                  Navigator.of(context).push(route);
                },
                title: 'DONE',
              ),
            )
          ],
        ),
      ),
    );
  }

  _paymentMethods() {
    return Container(
      child: Column(
        children: [
          Text(
            'Payment Methods',
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w200),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _paymentCard('From Wallet', 0),
                _paymentCard('Pay', 1),
                _paymentCard('Bank Transfer', 2),
              ],
            ),
          )
        ],
      ),
    );
  }

  int _selectedId = 0;
  Widget _paymentCard(String paymentMethod, int id) {
    return GestureDetector(
      onTap: () {
        if (id == 0) {
          setState(() {
            _wallet = true;
            _applePay = false;
            _bank = false;
            _selectedId = id;
          });
        }
        if (id == 1) {
          setState(() {
            _wallet = false;
            _applePay = true;
            _bank = false;
            selected = true;
            _selectedId = id;
          });
        }
        if (id == 2) {
          setState(() {
            _wallet = false;
            _applePay = false;
            _bank = true;
            _selectedId = id;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, right: 10),
            alignment: Alignment.center,

            height: 60,
            width: 100.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _selectedId == id ? AppTheme.appYellow : Colors.white,
            ),
            child: Text(
              paymentMethod,
              style: TextStyle(fontSize: 10.sp),
              textAlign: TextAlign.center,
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   // crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       height: 8,
            //       width: 8,
            //       child: Icon(Icons.android, size: 15),
            //       // child: Image.asset(
            //       //   'assets/logo/apple_logo.png',
            //       //   color: Colors.white,
            //       // ),
            //     ),
            //     Text(paymentMethod),
            //   ],
            // ),
          ),
          _selectedId == id
              ? Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.appYellow,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 13,
                      color: Colors.black,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  bool getBoxColor(int id) {
    bool status = false;
    if (id == 0) {
      setState(() {
        _wallet = true;
      });
    }
    return status;
  }

  _totalAmount() {
    return Container(
      // alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: 80,
            width: 150.w,
            child: ListTile(
              title: Text(
                'Total Amount',
                style: TextStyle(color: AppTheme.appGrey, fontSize: 14.sp),
              ),
              subtitle: Text(
                '\$ 10.00',
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 200.w,
                width: 200.w,
                child: SvgPicture.asset(
                  'assets/svg/wallet.svg',
                ),
              ),
              Positioned(
                top: 60.w,
                left: 25.w,
                child: Text(
                  'My wallet',
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
              Positioned(
                bottom: 60.w,
                right: 15.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$ 150.00',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available Balance',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
