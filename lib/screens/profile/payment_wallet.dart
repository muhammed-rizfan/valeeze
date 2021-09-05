import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/black_header.dart';

class PaymentWallet extends StatefulWidget {
  @override
  _PaymentWalletState createState() => _PaymentWalletState();
}

class _PaymentWalletState extends State<PaymentWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: AnimatedContent(
          show: true,
          leftToRight: 5.0,
          topToBottom: 0.0,
          time: 1700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlackHeader(
                onPress: _onPress,
                heading: 'Payment & wallet',
                icon: Icons.close,
              ),
              _totalAmount(),
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: Text(
                  'Cards',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              _savedCards('assets/icons/master_card.png'),
              _savedCards('assets/icons/visa_card.png'),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Add a new Card',
                      // style: TextStyle(
                      //   fontSize: 15,
                      // ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  _savedCards(String iconPath) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('Card Holder Name'),
        subtitle: Text('1234 XXXX XXXX 1234'),
        trailing: Icon(Icons.more_vert),
        leading: SizedBox(
          height: 40,
          width: 50,
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  _onPress() {
    print('pressed');
    Navigator.of(context).canPop();
  }

  _totalAmount() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 15, left: 15),

          // alignment: Alignment.center,
          height: 220.h,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            'assets/svg/wallet.svg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 60.w,
          left: 50.w,
          child: Text(
            'My wallet',
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
        ),
        Positioned(
          bottom: 60.w,
          left: 125.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$ 150.00',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Available Balance',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ],
          ),
        )
      ],
    );
  }
}
