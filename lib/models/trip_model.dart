// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<FullCustomerData> fullDataFromJson(String str) =>
    List<FullCustomerData>.from(
        json.decode(str).map((x) => FullCustomerData.fromJson(x)));

String welcomeToJson(List<FullCustomerData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FullCustomerData {
  FullCustomerData({
    this.id,
    this.phone,
    this.name,
    this.country,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.customerProfile,
    this.tripDetail,
  });

  String? id;
  String? phone;
  String? name;
  String? country;
  String? deviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<CustomerProfile>? customerProfile;
  List<TripDetails>? tripDetail;

  factory FullCustomerData.fromJson(Map<String, dynamic> json) =>
      FullCustomerData(
        id: json["id"],
        phone: json["phone"],
        name: json["name"],
        country: json["country"],
        deviceId: json["device_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerProfile: List<CustomerProfile>.from(
            json["customer_profile"].map((x) => CustomerProfile.fromJson(x))),
        tripDetail: List<TripDetails>.from(
            json["trip_detail"].map((x) => TripDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "name": name,
        "country": country,
        "device_id": deviceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer_profile":
            List<dynamic>.from(customerProfile!.map((x) => x.toJson())),
        "trip_detail": List<dynamic>.from(tripDetail!.map((x) => x.toJson())),
      };
}

class CustomerProfile {
  CustomerProfile({
    this.id,
    this.customerId,
    this.avtar,
    this.biodata,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.document,
    this.travellerType,
    this.profileStatusId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? customerId;
  dynamic? avtar;
  String? biodata;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? postcode;
  dynamic? document;
  String? travellerType;
  int? profileStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CustomerProfile.fromJson(Map<String, dynamic> json) =>
      CustomerProfile(
        id: json["id"],
        customerId: json["customer_id"],
        avtar: json["avtar"],
        biodata: json["biodata"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"],
        document: json["document"],
        travellerType: json["traveller_type"],
        profileStatusId: json["profile_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "avtar": avtar,
        "biodata": biodata,
        "address1": address1,
        "address2": address2,
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "document": document,
        "traveller_type": travellerType,
        "profile_status_id": profileStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class TripDetails {
  TripDetails({
    this.id,
    this.customerId,
    this.mode,
    this.vehicleName,
    this.vehicleNo,
    this.startFrom,
    this.destination,
    this.travelDate,
    this.reachDate,
    this.travelTime,
    this.availableLuggageWeight,
    this.ratePerKg,
    this.remainingLugWeight,
    this.pickupDate,
    this.pickupTime1,
    this.pickupTime2,
    this.ticket,
    this.deliveryStatusId,
    this.createdAt,
    this.updatedAt,
    this.scheduledDeliveryDetails,
  });

  String? id;
  String? customerId;
  int? mode;
  String? vehicleName;
  String? vehicleNo;
  String? startFrom;
  String? destination;
  DateTime? travelDate;
  DateTime? reachDate;
  String? travelTime;
  int? availableLuggageWeight;
  int? ratePerKg;
  int? remainingLugWeight;
  DateTime? pickupDate;
  String? pickupTime1;
  String? pickupTime2;
  String? ticket;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ScheduledLuggageDeliveryDetail>? scheduledDeliveryDetails;

  factory TripDetails.fromJson(Map<String, dynamic> json) => TripDetails(
        id: json["id"],
        customerId: json["customer_id"],
        mode: json["mode"],
        vehicleName: json["vehicle_name"],
        vehicleNo: json["vehicle_no"],
        startFrom: json["start_from"],
        destination: json["destination"],
        travelDate: DateTime.parse(json["travel_date"]),
        reachDate: DateTime.parse(json["reach_date"]),
        travelTime: json["travel_time"],
        availableLuggageWeight: json["available_luggage_weight"],
        ratePerKg: json["rate_per_kg"],
        remainingLugWeight: json["remaining_lug_weight"],
        pickupDate: DateTime.parse(json["pickup_date"]),
        pickupTime1: json["pickup_time1"],
        pickupTime2: json["pickup_time2"],
        ticket: json["ticket"],
        deliveryStatusId: json["delivery_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        scheduledDeliveryDetails: List<ScheduledLuggageDeliveryDetail>.from(
            json["scheduled_delivery_details"]
                .map((x) => ScheduledLuggageDeliveryDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        // "customer_id": customerId,
        // "start_from": startFrom,
        // "destination": destination,
        // "travel_date": travelDate?.toIso8601String(),
        // "reach_date": reachDate?.toIso8601String(),
        // "vehicle_details": vehicleDetails,
        // "available_luggage_weight": availableLuggageWeight,
        // "rate_per_kg": ratePerKg,
        // "ticket": ticket == null ? null : ticket,
        // "delivery_status_id": deliveryStatusId,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
        // "scheduled_delivery_details": List<dynamic>.from(
        //     scheduledDeliveryDetails!.map((x) => x.toJson())),
      };
}

class ScheduledLuggageDeliveryDetail {
  ScheduledLuggageDeliveryDetail({
    this.id,
    this.deliveryItemId,
    this.tripDetailId,
    this.scheduledStatusId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? deliveryItemId;
  String? tripDetailId;
  int? scheduledStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ScheduledLuggageDeliveryDetail.fromJson(Map<String, dynamic> json) =>
      ScheduledLuggageDeliveryDetail(
        id: json["id"],
        deliveryItemId: json["delivery_item_id"],
        tripDetailId: json["trip_detail_id"],
        scheduledStatusId: json["scheduled_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_item_id": deliveryItemId,
        "trip_detail_id": tripDetailId,
        "scheduled_status_id": scheduledStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
