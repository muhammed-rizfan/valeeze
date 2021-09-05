import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//  source: _trips[index].startFrom!,
//                 destination: _trips[index].destination!,
//                 time: '8.30',
//                 date: fromDate,
//                 day: 'Saturday',
//                 key: Key(index.toString()),
//                 duration: '15 hrs 30 mins',
//                 flightNumber: _trips[index].vehicleDetails!,
//                 availableLuggageWeight:
//                     _trips[index].availableLuggageWeight.toString(),
//                 ratePerKg: _trips[index].ratePerKg.toString(),
//                 customerId: _trips[index].customerId!,
//                 buddyCustomerId: widget.buddy.customer!.id!,

class UpcomingTripCard extends StatelessWidget {
  final TripDetails trip;
  final String currentTripId;
  final int index;
  const UpcomingTripCard(
      {Key? key,
      required this.trip,
      required this.index,
      required this.currentTripId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = trip.travelDate;

    String fromDate = DateFormat('EEEE, d MMM').format(date!);
    var reachDate = trip.travelDate;

    String toDate = DateFormat('EEEE, d MMM').format(date);

    return Stack(
      children: [
        Card(
          color: Colors.white,
          elevation: 5,
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                width: trip.id == currentTripId && index == 0 ? 6 : 1,
                color: trip.id == currentTripId && index == 0
                    ? AppTheme.appYellow
                    : Colors.grey[300]!),
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(color: AppTheme.appGrey, fontSize: 10),
                      ),
                      Text(trip.startFrom!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      SizedBox(height: 10),
                      Text(trip.travelTime!.substring(0, 5),
                          style:
                              TextStyle(color: AppTheme.appGrey, fontSize: 10)),
                      // Text(day,
                      //     style:
                      //         TextStyle(color: AppTheme.appGrey, fontSize: 10)),
                      Text(fromDate,
                          style:
                              TextStyle(color: AppTheme.appGrey, fontSize: 10))
                    ],
                  ),
                ),
                VerticalDivider(),
                Transform.translate(
                  offset: Offset(0.0, -8),
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Icon(Icons.flag_outlined, color: Colors.green),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/images/flight.png'),
                        ),
                        Text(trip.vehicleNo!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12)),
                        SizedBox(height: 6),

                        Text(trip.travelTime!.substring(0, 5) + " Hours",
                            style: TextStyle(fontSize: 12)),
                        SizedBox(height: 3),
                        Text('${trip.availableLuggageWeight} Kg Available',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.appGrey)),
                        SizedBox(height: 3),
                        Text('${trip.ratePerKg} \$/Kg',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.appGrey))
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(color: AppTheme.appGrey, fontSize: 10),
                      ),
                      Text("${trip.destination}",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Text(trip.reachDate.toString().substring(10, 16),
                          style:
                              TextStyle(color: AppTheme.appGrey, fontSize: 10)),
                      // Text(day,
                      //     style:
                      //         TextStyle(color: AppTheme.appGrey, fontSize: 10)),
                      Text(toDate,
                          style:
                              TextStyle(color: AppTheme.appGrey, fontSize: 10))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: 95),
            alignment: Alignment.center,
            height: 50.w,
            width: 50.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.appYellow),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/svg/send)_icon.svg',
                    height: 25,
                    width: 25,
                  ),
                ),
                Text(
                  'Click',
                  style: TextStyle(fontSize: 9.sp),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
