import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/screens/profile/help_detail.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:valeeze/widgets/curved_painter.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _header(context),
          _buildTiles(context),
        ],
      ),
    );
  }

  _buildTiles(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _customTile('Lorem ipsum', context),
        _customTile('Help  topic 2', context),
        _customTile('Help  topic 3', context),
        _customTile('Help  topic 4', context),
        _customTile('Help  topic 5', context),
        Divider(color: Colors.black),
      ],
    );
  }

  _customTile(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(color: Colors.black),
          ListTile(
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (context) =>
                      HelpDetail(helpDetail: 'helpDetail', helpTopic: title));
              Navigator.push(context, route);
            },
            title: Text(title),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ),
        ],
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
                'Help',
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
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    ]);
  }
}
