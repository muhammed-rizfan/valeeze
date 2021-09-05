import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/curved_painter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _header(),
    );
  }

  _header() {
    return Stack(
      // alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            //height: 250,
          ),
          painter: HeaderCurvedContainer(
            color: Colors.black,
            dy: 220,
            y1: 350,
          ),
        ),
        Positioned(
          top: 210.h,
          left: 43.w,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Container(
              width: 320.h,
              height: 550.h,

              // padding: const EdgeInsets.all(10.0),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: Icon(
                            Icons.settings_outlined,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, top: 10),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.h, bottom: 15.h),
                    child: Text(
                      'John Davis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.sp,
                      ),
                    ),
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      ListTile(
                        onTap: _onTileTap,
                        tileColor: Colors.grey[200],
                        leading: Icon(Icons.chat),
                        title: Text('Messages'),
                        trailing: Text('12 unread'),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.account_circle),
                        title: Text('Profile'),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.watch_later),
                        title: Text('History'),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.list_alt),
                        title: Text('Wallet and Payment Details'),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.help),
                        title: Text('Help'),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.list_alt_sharp),
                        title: Text('Terms and Conditions'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 170.h,
          left: 150.w,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.account_circle,
              size: 51.sp,
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppTheme.appYellow,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('V 1.20'),
          ),
        )
      ],
    );
  }

  _onTileTap() {
    // setState(() {
    //
    // });
  }
}
