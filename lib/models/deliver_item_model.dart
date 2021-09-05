// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<DeliverItem> deliverItemsFromJson(String str) => List<DeliverItem>.from(
    json.decode(str).map((x) => DeliverItem.fromJson(x)));

String welcomeToJson(List<DeliverItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliverItem {
  DeliverItem({
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
  ItemFrom? itemFrom;
  String? itemTo;
  int? deliveryStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ItemClass? item;

  factory DeliverItem.fromJson(Map<String, dynamic> json) => DeliverItem(
        id: json["id"],
        customerId: json["customer_id"],
        mobileNumber: json["mobile_number"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemImage: json["item_image"],
        itemValue: json["item_value"],
        itemWeight: json["item_weight"],
        itemFrom: itemFromValues.map[json["item_from"]],
        itemTo: json["item_to"],
        deliveryStatusId: json["delivery_status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        item: ItemClass.fromJson(json["item"]),
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
        "item_from": itemFromValues.reverse[itemFrom],
        "item_to": itemTo,
        "delivery_status_id": deliveryStatusId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "item": item?.toJson(),
      };
}

class ItemClass {
  ItemClass({
    this.id,
    this.item,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  ItemEnum? item;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ItemClass.fromJson(Map<String, dynamic> json) => ItemClass(
        id: json["id"],
        item: itemEnumValues.map[json["item"]]!,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item": itemEnumValues.reverse[item],
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum ItemEnum { PHONE }

final itemEnumValues = EnumValues({"Phone": ItemEnum.PHONE});

enum ItemFrom { CNN, DXB, MCT }

final itemFromValues =
    EnumValues({"CNN": ItemFrom.CNN, "DXB": ItemFrom.DXB, "MCT": ItemFrom.MCT});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
