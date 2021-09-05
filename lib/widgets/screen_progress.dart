import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valeeze/theme/theme.dart';

class ScreenProgress extends StatelessWidget {
  final int ticks;
  final double width;
  final double pad;

  ScreenProgress({required this.ticks, required this.width, required this.pad});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              tick1(),
              line(),
              tick2(),
              line(),
              tick3(),
              // line(),
              // tick4(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.l,
            children: <Widget>[
              tick1Text(),
              tick2Text(),
              tick3Text(),
              // tick4Text(),
            ],
          ),
        ),
      ],
    );
  }

  Widget tick(bool isChecked, String orderStatus, bool currentStatus) {
    return isChecked
        ? new Column(
            children: [
              new Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.appGrey),
                  color: ticks >= 3 ? Colors.green : AppTheme.appGrey,
                ),

                // child: Icon(
                //   Icons.check_circle,
                //   color: currentStatus ? Colors.green : AppTheme.appYellow,
                // ),
              ),
            ],
          )
        : new Column(children: [
            new Container(
              child: Icon(
                Icons.radio_button_unchecked,
                color: currentStatus ? Colors.green : AppTheme.appGrey,
              ),
            ),
          ]);
  }

  Widget tickTxt(bool isChecked, String orderStatus, bool currentStatus) {
    return new Column(
      children: [
        new Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              orderStatus,
              style: new TextStyle(
                  fontSize: 10.0, fontFamily: "Muli", color: Colors.black),
            )),
      ],
    );
  }

  Widget tick1Text() {
    bool currentStatus = this.ticks == 1 ? true : false;
    return this.ticks > 0
        ? tickTxt(true, "Requested", currentStatus)
        : tickTxt(false, "Requested", currentStatus);
  }

  Widget tick2Text() {
    bool currentStatus = this.ticks == 2 ? true : false;
    return this.ticks > 1
        ? tickTxt(true, "Accepted", currentStatus)
        : tickTxt(false, "Accepted", currentStatus);
  }

  Widget tick3Text() {
    bool currentStatus = this.ticks == 3 ? true : false;
    return this.ticks > 2
        ? tickTxt(true, "Delivered", currentStatus)
        : tickTxt(false, "Delivered", currentStatus);
  }

  Widget tick4Text() {
    bool currentStatus = this.ticks == 4 ? true : false;
    return this.ticks > 3
        ? tickTxt(true, "Delivered", currentStatus)
        : tickTxt(false, "Delivered", currentStatus);
  }

  Widget tick1() {
    bool currentStatus = this.ticks == 1 ? true : false;
    return this.ticks > 0
        ? tick(true, "Accepted", currentStatus)
        : tick(false, "Accepted", currentStatus);
  }

  Widget tick2() {
    bool currentStatus = this.ticks == 2 ? true : false;
    return this.ticks > 1
        ? tick(true, "Package Ready", currentStatus)
        : tick(false, "Package Ready", currentStatus);
  }

  Widget tick3() {
    bool currentStatus = this.ticks == 3 ? true : false;
    return this.ticks > 2
        ? tick(true, "On the way", currentStatus)
        : tick(false, "On the way", currentStatus);
  }

  Widget tick4() {
    bool currentStatus = this.ticks == 4 ? true : false;
    return this.ticks > 3
        ? tick(true, "Delivered", currentStatus)
        : tick(false, "Delivered", currentStatus);
  }

  Widget line() {
    return Expanded(
      child: Container(
        color: ticks >= 3 ? Colors.green : AppTheme.appGrey,
        height: 5.0,
      ),
    );
  }
}
