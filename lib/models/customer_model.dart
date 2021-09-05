// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String welcomeToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  List<dynamic>? customerProfile;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        phone: json["phone"],
        name: json["name"],
        country: json["country"],
        deviceId: json["device_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerProfile:
            List<dynamic>.from(json["customer_profile"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "name": name,
        "country": country,
        "device_id": deviceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer_profile": List<dynamic>.from(customerProfile!.map((x) => x)),
      };
}
