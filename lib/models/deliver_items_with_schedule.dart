// class DeliveryItemsWithSchedule {
//   List<DeliveryItem>? deliveryItem;

//   DeliveryItemsWithSchedule({this.deliveryItem});

//   DeliveryItemsWithSchedule.fromJson(Map<String, dynamic> json) {
//     if (json['delivery_item'] != null) {
//       deliveryItem = [];
//       json['delivery_item'].forEach((v) {
//         deliveryItem?.add(new DeliveryItem.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.deliveryItem != null) {
//       data['delivery_item'] =
//           this.deliveryItem?.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class DeliveryItem {
//   String? id;
//   String? customerId;
//   String? mobileNumber;
//   int? itemId;
//   dynamic? itemName;
//   String? itemImage;
//   String? itemValue;
//   int? itemWeight;
//   String? itemFrom;
//   String? itemTo;
//   int? deliveryStatusId;
//   String? createdAt;
//   String? updatedAt;
//   List<ScheduledDeliveryDetails>? scheduledDeliveryDetails;

//   DeliveryItem(
//       {this.id,
//       this.customerId,
//       this.mobileNumber,
//       this.itemId,
//       this.itemName,
//       this.itemImage,
//       this.itemValue,
//       this.itemWeight,
//       this.itemFrom,
//       this.itemTo,
//       this.deliveryStatusId,
//       this.createdAt,
//       this.updatedAt,
//       this.scheduledDeliveryDetails});

//   DeliveryItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     customerId = json['customer_id'];
//     mobileNumber = json['mobile_number'];
//     itemId = json['item_id'];
//     itemName = json['item_name'];
//     itemImage = json['item_image'];
//     itemValue = json['item_value'];
//     itemWeight = json['item_weight'];
//     itemFrom = json['item_from'];
//     itemTo = json['item_to'];
//     deliveryStatusId = json['delivery_status_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['scheduled_delivery_details'] != null) {
//       scheduledDeliveryDetails = [];
//       json['scheduled_delivery_details'].forEach((v) {
//         scheduledDeliveryDetails?.add(new ScheduledDeliveryDetails.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['customer_id'] = this.customerId;
//     data['mobile_number'] = this.mobileNumber;
//     data['item_id'] = this.itemId;
//     data['item_name'] = this.itemName;
//     data['item_image'] = this.itemImage;
//     data['item_value'] = this.itemValue;
//     data['item_weight'] = this.itemWeight;
//     data['item_from'] = this.itemFrom;
//     data['item_to'] = this.itemTo;
//     data['delivery_status_id'] = this.deliveryStatusId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.scheduledDeliveryDetails != null) {
//       data['scheduled_delivery_details'] =
//           this.scheduledDeliveryDetails?.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class ScheduledDeliveryDetails {
//   String? id;
//   String? deliveryItemId;
//   String? tripDetailId;
//   int? scheduledStatusId;
//   String? createdAt;
//   String? updatedAt;
//   ScheduledStatus? scheduledStatus;
//   TripDetail? tripDetail;

//   ScheduledDeliveryDetails(
//       {this.id,
//       this.deliveryItemId,
//       this.tripDetailId,
//       this.scheduledStatusId,
//       this.createdAt,
//       this.updatedAt,
//       this.scheduledStatus,
//       this.tripDetail});

//   ScheduledDeliveryDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     deliveryItemId = json['delivery_item_id'];
//     tripDetailId = json['trip_detail_id'];
//     scheduledStatusId = json['scheduled_status_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     scheduledStatus = json['scheduled_status'] != null
//         ? new ScheduledStatus.fromJson(json['scheduled_status'])
//         : null;
//     tripDetail = json['trip_detail'] != null
//         ? new TripDetail.fromJson(json['trip_detail'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['delivery_item_id'] = this.deliveryItemId;
//     data['trip_detail_id'] = this.tripDetailId;
//     data['scheduled_status_id'] = this.scheduledStatusId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.scheduledStatus != null) {
//       data['scheduled_status'] = this.scheduledStatus?.toJson();
//     }
//     if (this.tripDetail != null) {
//       data['trip_detail'] = this.tripDetail?.toJson();
//     }
//     return data;
//   }
// }

// class ScheduledStatus {
//   int? id;
//   String? status;
//   String? createdAt;
//   String? updatedAt;

//   ScheduledStatus({this.id, this.status, this.createdAt, this.updatedAt});

//   ScheduledStatus.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class TripDetail {
//   String? id;
//   String? customerId;
//   String? startFrom;
//   String? destination;
//   String? travelDate;
//   String? reachDate;
//   String? vehicleDetails;
//   int? availableLuggageWeight;
//   int? ratePerKg;
//   String? ticket;
//   int? deliveryStatusId;
//   String? createdAt;
//   String? updatedAt;
//   Customer? customer;

//   TripDetail(
//       {this.id,
//       this.customerId,
//       this.startFrom,
//       this.destination,
//       this.travelDate,
//       this.reachDate,
//       this.vehicleDetails,
//       this.availableLuggageWeight,
//       this.ratePerKg,
//       this.ticket,
//       this.deliveryStatusId,
//       this.createdAt,
//       this.updatedAt,
//       this.customer});

//   TripDetail.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     customerId = json['customer_id'];
//     startFrom = json['start_from'];
//     destination = json['destination'];
//     travelDate = json['travel_date'];
//     reachDate = json['reach_date'];
//     vehicleDetails = json['vehicle_details'];
//     availableLuggageWeight = json['available_luggage_weight'];
//     ratePerKg = json['rate_per_kg'];
//     ticket = json['ticket'];
//     deliveryStatusId = json['delivery_status_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     customer = json['customer'] != null
//         ? new Customer.fromJson(json['customer'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['customer_id'] = this.customerId;
//     data['start_from'] = this.startFrom;
//     data['destination'] = this.destination;
//     data['travel_date'] = this.travelDate;
//     data['reach_date'] = this.reachDate;
//     data['vehicle_details'] = this.vehicleDetails;
//     data['available_luggage_weight'] = this.availableLuggageWeight;
//     data['rate_per_kg'] = this.ratePerKg;
//     data['ticket'] = this.ticket;
//     data['delivery_status_id'] = this.deliveryStatusId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.customer != null) {
//       data['customer'] = this.customer?.toJson();
//     }
//     return data;
//   }
// }

// class Customer {
//   String? id;
//   String? phone;
//   String? name;
//   String? country;
//   String? deviceId;
//   String? createdAt;
//   String? updatedAt;

//   Customer(
//       {this.id,
//       this.phone,
//       this.name,
//       this.country,
//       this.deviceId,
//       this.createdAt,
//       this.updatedAt});

//   Customer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     phone = json['phone'];
//     name = json['name'];
//     country = json['country'];
//     deviceId = json['device_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['phone'] = this.phone;
//     data['name'] = this.name;
//     data['country'] = this.country;
//     data['device_id'] = this.deviceId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<DeliveryItemsWithSchedule> deliveryItemsWithScheduleFromJson(String str) =>
    List<DeliveryItemsWithSchedule>.from(
        json.decode(str).map((x) => DeliveryItemsWithSchedule.fromJson(x)));

String welcomeToJson(List<DeliveryItemsWithSchedule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryItemsWithSchedule {
  DeliveryItemsWithSchedule({
    this.deliveryItem,
  });

  List<DeliveryItem>? deliveryItem;

  factory DeliveryItemsWithSchedule.fromJson(Map<String, dynamic> json) =>
      DeliveryItemsWithSchedule(
        deliveryItem: List<DeliveryItem>.from(
            json["delivery_item"].map((x) => DeliveryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivery_item":
            List<dynamic>.from(deliveryItem!.map((x) => x.toJson())),
      };
}

class DeliveryItem {
  DeliveryItem({
    this.id,
    this.customerId,
    this.mobileNumber,
    this.itemId,
    this.itemName,
    this.itemImage,
    this.itemValue,
    this.itemWeight,
    this.itemFrom,
    this.itemTo,
    this.deliveryStatusId,
    this.createdAt,
    this.updatedAt,
    this.scheduledDeliveryDetails,
  });

  String? id;
  String? customerId;
  String? mobileNumber;
  int? itemId;
  dynamic? itemName;
  String? itemImage;
  String? itemValue;
  int? itemWeight;
  String? itemFrom;
  String? itemTo;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ScheduledDeliveryDetail>? scheduledDeliveryDetails;

  factory DeliveryItem.fromJson(Map<String, dynamic> json) => DeliveryItem(
        id: json["id"],
        customerId: json["customer_id"],
        mobileNumber: json["mobile_number"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemImage: json["item_image"] == null ? null : json["item_image"],
        itemValue: json["item_value"],
        itemWeight: json["item_weight"],
        itemFrom: json["item_from"],
        itemTo: json["item_to"],
        deliveryStatusId: json["delivery_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        scheduledDeliveryDetails: List<ScheduledDeliveryDetail>.from(
            json["scheduled_delivery_details"]
                .map((x) => ScheduledDeliveryDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "mobile_number": mobileNumber,
        "item_id": itemId,
        "item_name": itemName,
        "item_image": itemImage == null ? null : itemImage,
        "item_value": itemValue,
        "item_weight": itemWeight,
        "item_from": itemFrom,
        "item_to": itemTo,
        "delivery_status_id": deliveryStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "scheduled_delivery_details": List<dynamic>.from(
            scheduledDeliveryDetails!.map((x) => x.toJson())),
      };
}

class ScheduledDeliveryDetail {
  ScheduledDeliveryDetail({
    this.id,
    this.deliveryItemId,
    this.tripDetailId,
    this.scheduledStatusId,
    this.createdAt,
    this.updatedAt,
    this.scheduledStatus,
    this.tripDetail,
  });

  String? id;
  String? deliveryItemId;
  String? tripDetailId;
  int? scheduledStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ScheduledStatus? scheduledStatus;
  TripDetail? tripDetail;

  factory ScheduledDeliveryDetail.fromJson(Map<String, dynamic> json) =>
      ScheduledDeliveryDetail(
        id: json["id"],
        deliveryItemId: json["delivery_item_id"],
        tripDetailId: json["trip_detail_id"],
        scheduledStatusId: json["scheduled_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        scheduledStatus: ScheduledStatus.fromJson(json["scheduled_status"]),
        tripDetail: TripDetail.fromJson(json["trip_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_item_id": deliveryItemId,
        "trip_detail_id": tripDetailId,
        "scheduled_status_id": scheduledStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "scheduled_status": scheduledStatus?.toJson(),
        "trip_detail": tripDetail?.toJson(),
      };
}

class ScheduledStatus {
  ScheduledStatus({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ScheduledStatus.fromJson(Map<String, dynamic> json) =>
      ScheduledStatus(
        id: json["id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class TripDetail {
  TripDetail({
    this.id,
    this.customerId,
    this.startFrom,
    this.destination,
    this.travelDate,
    this.reachDate,
    this.vehicleName,
    this.vehicleNo,
    this.pickupDate,
    this.pickupTime1,
    this.pickupTime2,
    this.remainingLugWeight,
    this.mode,
    this.travelTime,
    this.availableLuggageWeight,
    this.ratePerKg,
    this.ticket,
    this.deliveryStatusId,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  String? id;
  String? customerId;
  int? mode;
  String? startFrom;
  String? destination;
  DateTime? travelDate;
  DateTime? reachDate;
  String? travelTime;
  String? vehicleName;
  String? vehicleNo;
  int? availableLuggageWeight;
  int? remainingLugWeight;
  String? pickupDate;
  String? pickupTime1;
  String? pickupTime2;
  int? ratePerKg;
  String? ticket;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;

  factory TripDetail.fromJson(Map<String, dynamic> json) => TripDetail(
        id: json["id"],
        customerId: json["customer_id"],
        startFrom: json["start_from"],
        destination: json["destination"],
        travelDate: DateTime.parse(json["travel_date"]),
        reachDate: DateTime.parse(json["reach_date"]),
        vehicleName: json["vehicle_name"],
        vehicleNo: json['vehicle_no'],
        mode: json['mode'],
        pickupDate: json['pickup_date'],
        pickupTime1: json['pickup_time1'],
        pickupTime2: json['pickup_time2'],
        remainingLugWeight: json['remaining_lug_weight'],
        travelTime: json['travel_time'],
        availableLuggageWeight: json["available_luggage_weight"],
        ratePerKg: json["rate_per_kg"],
        ticket: json["ticket"],
        deliveryStatusId: json["delivery_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "start_from": startFrom,
        "destination": destination,
        "travel_date": travelDate?.toIso8601String(),
        "reach_date": reachDate?.toIso8601String(),
        "vehicle_name": vehicleName,
        "vehicle_no": vehicleNo,
        "mode": mode,
        "travel_time": travelTime,
        "pickup_time1": pickupTime1,
        "pickup_time2": pickupTime2,
        "pickup_date": pickupDate,
        "remaining_lug_weight": remainingLugWeight,
        "available_luggage_weight": availableLuggageWeight,
        "rate_per_kg": ratePerKg,
        "ticket": ticket,
        "delivery_status_id": deliveryStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer": customer?.toJson(),
      };
}

class Customer {
  Customer({
    this.id,
    this.phone,
    this.name,
    this.country,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? phone;
  String? name;
  String? country;
  String? deviceId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        phone: json["phone"],
        name: json["name"],
        country: json["country"],
        deviceId: json["device_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "name": name,
        "country": country,
        "device_id": deviceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
