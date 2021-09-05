// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Buddies> buddiesFromJson(String str) =>
    List<Buddies>.from(json.decode(str).map((x) => Buddies.fromJson(x)));

String welcomeToJson(List<Buddies> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buddies {
  Buddies({
    this.id,
    this.customerId,
    this.startFrom,
    this.destination,
    this.travelDate,
    this.reachDate,
    this.vehicleDetails,
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
  String? startFrom;
  String? destination;
  DateTime? travelDate;
  DateTime? reachDate;
  String? vehicleDetails;
  int? availableLuggageWeight;
  int? ratePerKg;
  String? ticket;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;

  factory Buddies.fromJson(Map<String, dynamic> json) => Buddies(
        id: json["id"],
        customerId: json["customer_id"],
        startFrom: json["start_from"],
        destination: json["destination"],
        travelDate: DateTime.parse(json["travel_date"]),
        reachDate: DateTime.parse(json["reach_date"]),
        vehicleDetails: json["vehicle_details"],
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
        "vehicle_details": vehicleDetails,
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
    this.customerProfile,
  });

  String? id;
  String? phone;
  String? name;
  String? country;
  String? deviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<CustomerProfile>? customerProfile;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        phone: json["phone"],
        name: json["name"],
        country: json["country"],
        deviceId: json["device_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerProfile: List<CustomerProfile>.from(
            json["customer_profile"].map((x) => CustomerProfile.fromJson(x))),
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
  String? document;
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
