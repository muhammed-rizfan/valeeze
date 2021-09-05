import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/black_header.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlackHeader(
            onPress: _onPress,
            heading: 'History',
            icon: Icons.close,
          ),
          _travelHistoryTile(),
        ],
      ),
    );
  }

  _travelHistoryTile() {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: expanded ? 200 : 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [
              Colors.grey[200]!,
              Colors.grey[100]!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              // spreadRadius: 3,
              // offset: Offset(.5, .5),
            )
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'John Davis',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Transporter',
                    style: TextStyle(
                      color: AppTheme.appGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$ 10',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      expanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 30,
                      color: Colors.lightGreen,
                    ),
                  ),
                ],
              ),
              Text(
                '20/04/2021 - 05.00 PM',
                style: TextStyle(
                  color: AppTheme.appGrey,
                  fontSize: 14.sp,
                ),
              ),
              expanded ? SizedBox(height: 20) : SizedBox.shrink(),
              expanded
                  ? RichText(
                      text: TextSpan(
                        text: 'DXB',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(text: ' '),
                          TextSpan(
                            text: 'To',
                            style: TextStyle(
                              color: AppTheme.appGrey,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: 'SFO',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              expanded ? SizedBox(height: 15) : SizedBox.shrink(),
              expanded
                  ? Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset('assets/svg/weight.svg'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '1 KG',
                          style: TextStyle(
                            color: AppTheme.appGrey,
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'assets/images/flight.png',
                          ),
                        ),
                        SizedBox(width: 15),
                        Text('B777 - EK225')
                      ],
                    )
                  : SizedBox.shrink(),
              expanded ? SizedBox(height: 15) : SizedBox.shrink(),
              expanded
                  ? Text('Payment done via card XXXX 1234')
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  _onPress() {
    print('pressed');
    Navigator.of(context).canPop();
  }
}
