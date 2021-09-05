// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<SingleDeliveryItem> singleDeliveryItemFromJson(String str) =>
    List<SingleDeliveryItem>.from(
        json.decode(str).map((x) => SingleDeliveryItem.fromJson(x)));

String singleDeliveryItemToJson(List<SingleDeliveryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleDeliveryItem {
  SingleDeliveryItem({
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
    this.description,
    this.deliveryStatusId,
    this.createdAt,
    this.updatedAt,
    this.item,
  });

  String? id;
  String? customerId;
  String? mobileNumber;
  int? itemId;
  dynamic? itemName;
  dynamic? itemImage;
  String? itemValue;
  int? itemWeight;
  String? itemFrom;
  String? itemTo;
  dynamic? description;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Item? item;

  factory SingleDeliveryItem.fromJson(Map<String, dynamic> json) =>
      SingleDeliveryItem(
        id: json["id"],
        customerId: json["customer_id"],
        mobileNumber: json["mobile_number"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemImage: json["item_image"],
        itemValue: json["item_value"],
        itemWeight: json["item_weight"],
        itemFrom: json["item_from"],
        itemTo: json["item_to"],
        description: json["description"],
        deliveryStatusId: json["delivery_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "mobile_number": mobileNumber,
        "item_id": itemId,
        "item_name": itemName,
        "item_image": itemImage,
        "item_value": itemValue,
        "item_weight": itemWeight,
        "item_from": itemFrom,
        "item_to": itemTo,
        "description": description,
        "delivery_status_id": deliveryStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "item": item?.toJson(),
      };
}

class Item {
  Item({
    this.id,
    this.item,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? item;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        item: json["item"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item": item,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
