import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/deliver_items_with_schedule.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/status/accept_request.dart';
import 'package:valeeze/screens/status/confirm_request.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:valeeze/utils/constants.dart';

class TransportersFromSchedule extends StatefulWidget {
  final List<ScheduledDeliveryDetail> scheduledDeliveries;
  final String status;
  final String customerId;
  final DeliveryItem deliveryItem;
  const TransportersFromSchedule(
      {Key? key,
      required this.status,
      required this.customerId,
      required this.deliveryItem,
      required this.scheduledDeliveries})
      : super(key: key);

  @override
  _TransportersFromScheduleState createState() =>
      _TransportersFromScheduleState();
}

class _TransportersFromScheduleState extends State<TransportersFromSchedule> {
  List<FullCustomerData> fullCustomerData = [];
  CustomerProfile customerProfile = CustomerProfile();
  late String customerName;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadCustomer();
  }

  loadCustomer() async {
    String id = widget.customerId;
    var res = await http.get(Uri.parse(Constants.BASE_URL + 'getCustomer/$id'));
    fullCustomerData = fullDataFromJson(res.body);
    customerName = fullCustomerData[0].name!;
    customerProfile = fullCustomerData[0].customerProfile![0];
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '${widget.status} Movers',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              padding: EdgeInsets.only(left: 24),
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        body: loading
            ? Center(child: CircularProgressIndicator())
            : AnimatedContent(
                show: true,
                leftToRight: 5.0,
                topToBottom: 0.0,
                time: 1700,
                child: _buildBuddies(),
              ));
  }

  _buildBuddies() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.scheduledDeliveries.length,
          itemBuilder: (context, index) {
            return BuddiesCardFromSchdeule(
              deliveryDetail: widget.scheduledDeliveries[index],
              customerData: fullCustomerData[0],
              deliveryItem: widget.deliveryItem,
            );
          }),
    );
  }
}

class BuddiesCardFromSchdeule extends StatelessWidget {
  final ScheduledDeliveryDetail? deliveryDetail;
  final FullCustomerData customerData;
  final DeliveryItem deliveryItem;

  const BuddiesCardFromSchdeule(
      {Key? key,
      required this.customerData,
      required this.deliveryItem,
      required this.deliveryDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color gradient1 = Color.fromRGBO(236, 237, 243, 1);
    final Color gradient2 = Color.fromRGBO(255, 255, 255, 1);
    // var date = buddy?.travelDate;
    // String fromDate = DateFormat('EEEE, d MMM').format(date!);
    // var fromList = fromDate.split(',');

    // var date2 = buddy?.reachDate;
    // String toDate = DateFormat('EEEE, d MMM').format(date); //
    // var toList = toDate.split(',');
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(left: 25, right: 25, top: 25),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradient1, gradient2],
              ),
            ),
            height: 160,
            child: ListTile(
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (context) => ConfirmRequest(
                          scheduledDeliveryDetail: deliveryDetail!,
                          scheduleDeliveryDetailId: deliveryDetail!.id!,
                          customerData: customerData,
                          deliverItem: deliveryItem,
                        ));
                if (customerData != null) {
                  Navigator.push(context, route);
                }
              },
              // leading:
              //
              // Container(
              //   // margin: EdgeInsets.only(top: 30),
              //   height: 80,
              //   width: 80,
              //   decoration:
              //       BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
              // ),

              // leading: CircleAvatar(
              //   radius: 50,
              //   backgroundImage:
              //       AssetImage('assets/images/video_thumbnail.png'),
              // ),
              title: FittedBox(
                child: SizedBox(
                  height: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(right: 15, left: 0),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/video_thumbnail.png'),
                                fit: BoxFit.cover),
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                      ),
                      // CircleAvatar(
                      //   radius: 20,
                      //   backgroundImage:
                      //       AssetImage('assets/images/video_thumbnail.png'),
                      // ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              deliveryDetail!.tripDetail!.customer!.name!,
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    //  alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                        'assets/svg/weight.svg',
                                        color: AppTheme.appYellow,
                                        semanticsLabel: 'weight'),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    ' ${deliveryDetail!.tripDetail!.availableLuggageWeight.toString()} Kg available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    //  alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                        'assets/svg/money.svg',
                                        color: AppTheme.appYellow,
                                        semanticsLabel: 'money'),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    ' ${deliveryDetail!.tripDetail!.ratePerKg.toString()} \$/Kg',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star,
                                    color: AppTheme.appYellow, size: 15),
                                Icon(Icons.star, color: Colors.grey, size: 15),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Icon(Icons.flag, color: Colors.green),
                                  Container(
                                    height: 20.w,
                                    width: 20.w,
                                    child:
                                        Image.asset('assets/images/flight.png'),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'B777 - EK225',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 15),

                      VerticalDivider(
                        color: Colors.grey[200],
                        thickness: 0.8,
                        width: 0.8,
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 0),
                        height: 150,
                        width: 20,
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              // trailing: Container(
              //   alignment: Alignment.center,
              //   height: 150,
              //   width: 20,
              //   color: Colors.teal,
              //   child: Center(child: Icon(Icons.arrow_forward_ios)),
              // ),
            ),
          ),
        )
      ],
    );
  }
}
