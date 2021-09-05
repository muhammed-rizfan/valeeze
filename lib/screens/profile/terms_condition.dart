import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/curved_painter.dart';

class TermsConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                '1. Introduction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                '''Thisfollowingsetsoutthetermsandcon- ditionsonwhichyoumayusethecontenton business-standard.comwebsite,busi- ness-standard.com'smobilebrowsersite, BusinessStandardinstoreApplicationsand otherdigitalpublishingservices(www.smart- investor.in,www.bshindi.comandwww.bsmo- toring,com)ownedbyBusinessStandardPri- vateLimited,alltheserviceshereinwillbere- ferredtoasBusinessStandardContentSer- vices
                ''',
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                '2. Registration Access and Use',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                '''Thisfollowingsetsoutthetermsandcon- ditionsonwhichyoumayusethecontenton business-standard.comwebsite,busi- ness-standard.com'smobilebrowsersite, BusinessStandardinstoreApplicationsand otherdigitalpublishingservices(www.smart- investor.in,www.bshindi.comandwww.bsmo- toring,com)ownedbyBusinessStandardPri- vateLimited,alltheserviceshereinwillbere- ferredtoasBusinessStandardContentSer- vices
                ''',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _header(BuildContext context) {
    return Stack(children: [
      CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          //height: 250,
        ),
        painter: HeaderCurvedContainer(
          color: Colors.black,
          dy: 150,
          y1: 250,
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
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppTheme.appYellow,
                ),
                onPressed: () {
                  Navigator.of(context).canPop();
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
