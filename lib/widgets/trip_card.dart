import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripCard extends StatelessWidget {
  final TripDetails tripDetail;
  const TripCard({
    Key? key,
    required this.tripDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = tripDetail.travelDate;

    String fromDate = DateFormat('EEEE, d MMM').format(date!);
    var reachDate = tripDetail.travelDate;

    String toDate = DateFormat('EEEE, d MMM').format(date);
    var fromList = fromDate.split(',');
    var toList = toDate.split(',');

    return Stack(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!)),
          child: Container(
            padding: EdgeInsets.all(12),
            height: 120,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style:
                              TextStyle(color: AppTheme.appGrey, fontSize: 12),
                        ),
                        Text(tripDetail.startFrom!,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 10),
                        Text(tripDetail.travelDate.toString().substring(10, 16),
                            style: TextStyle(
                                color: AppTheme.appGrey, fontSize: 10)),
                        Text(fromList[0],
                            style: TextStyle(
                                color: AppTheme.appGrey, fontSize: 10)),
                        Text(fromList[1],
                            style: TextStyle(
                                color: AppTheme.appGrey, fontSize: 10))
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Container(
                    // height: 120,
                    // decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.grey.withOpacity(.3),
                    //       spreadRadius: 2,
                    //       blurRadius: 2,
                    //       offset: Offset(0, 1.5))
                    // ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Icon(Icons.flag_outlined, color: Colors.green),
                        SizedBox(
                          height: 25.w,
                          width: 25.w,
                          child: Image.asset('assets/images/flight.png'),
                        ),
                        Text(tripDetail.vehicleNo!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12)),
                        SizedBox(height: 8),
                        Text(tripDetail.travelTime!.substring(0, 5) + ' Hours',
                            style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Transform.translate(
                    offset: Offset(0, -8),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                                color: AppTheme.appGrey, fontSize: 12),
                          ),
                          Text(tripDetail.destination!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          SizedBox(height: 10),
                          Text(
                              tripDetail.reachDate.toString().substring(10, 16),
                              style: TextStyle(
                                  color: AppTheme.appGrey, fontSize: 10)),
                          Text(toList[0],
                              style: TextStyle(
                                  color: AppTheme.appGrey, fontSize: 10)),
                          Text(toList[1],
                              style: TextStyle(
                                  color: AppTheme.appGrey, fontSize: 10))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
