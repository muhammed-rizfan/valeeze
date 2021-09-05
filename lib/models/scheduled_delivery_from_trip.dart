class ScheduledDeliveryFromTrip {
  String? id;
  String? deliveryItemId;
  String? tripDetailId;
  int? scheduledStatusId;
  String? createdAt;
  String? updatedAt;
  DeliveryItem? deliveryItem;
  TripDetail? tripDetail;
  ScheduledStatus? scheduledStatus;

  ScheduledDeliveryFromTrip(
      {this.id,
      this.deliveryItemId,
      this.tripDetailId,
      this.scheduledStatusId,
      this.createdAt,
      this.updatedAt,
      this.deliveryItem,
      this.tripDetail,
      this.scheduledStatus});

  ScheduledDeliveryFromTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryItemId = json['delivery_item_id'];
    tripDetailId = json['trip_detail_id'];
    scheduledStatusId = json['scheduled_status_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryItem = json['delivery_item'] != null
        ? new DeliveryItem.fromJson(json['delivery_item'])
        : null;
    tripDetail = json['trip_detail'] != null
        ? new TripDetail.fromJson(json['trip_detail'])
        : null;
    scheduledStatus = json['scheduled_status'] != null
        ? new ScheduledStatus.fromJson(json['scheduled_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['delivery_item_id'] = this.deliveryItemId;
    data['trip_detail_id'] = this.tripDetailId;
    data['scheduled_status_id'] = this.scheduledStatusId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deliveryItem != null) {
      data['delivery_item'] = this.deliveryItem!.toJson();
    }
    if (this.tripDetail != null) {
      data['trip_detail'] = this.tripDetail!.toJson();
    }
    if (this.scheduledStatus != null) {
      data['scheduled_status'] = this.scheduledStatus!.toJson();
    }
    return data;
  }
}

class DeliveryItem {
  String? id;
  String? customerId;
  String? mobileNumber;
  int? itemId;
  String? itemName;
  String? itemImage;
  String? itemValue;
  int? itemWeight;
  String? itemFrom;
  String? itemTo;
  int? deliveryStatusId;
  String? createdAt;
  String? updatedAt;
  Customer? customer;

  DeliveryItem(
      {this.id,
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
      this.customer});

  DeliveryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    mobileNumber = json['mobile_number'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    itemValue = json['item_value'];
    itemWeight = json['item_weight'];
    itemFrom = json['item_from'];
    itemTo = json['item_to'];
    deliveryStatusId = json['delivery_status_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['mobile_number'] = this.mobileNumber;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['item_image'] = this.itemImage;
    data['item_value'] = this.itemValue;
    data['item_weight'] = this.itemWeight;
    data['item_from'] = this.itemFrom;
    data['item_to'] = this.itemTo;
    data['delivery_status_id'] = this.deliveryStatusId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? phone;
  String? name;
  String? country;
  String? deviceId;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
      this.phone,
      this.name,
      this.country,
      this.deviceId,
      this.createdAt,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    country = json['country'];
    deviceId = json['device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['country'] = this.country;
    data['device_id'] = this.deviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TripDetail {
  String? id;
  String? customerId;
  String? startFrom;
  String? destination;
  String? travelDate;
  String? reachDate;
  String? vehicleDetails;
  int? availableLuggageWeight;
  int? ratePerKg;
  String? ticket;
  int? deliveryStatusId;
  String? createdAt;
  String? updatedAt;
  Customer? customer;

  TripDetail(
      {this.id,
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
      this.customer});

  TripDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    startFrom = json['start_from'];
    destination = json['destination'];
    travelDate = json['travel_date'];
    reachDate = json['reach_date'];
    vehicleDetails = json['vehicle_details'];
    availableLuggageWeight = json['available_luggage_weight'];
    ratePerKg = json['rate_per_kg'];
    ticket = json['ticket'];
    deliveryStatusId = json['delivery_status_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['start_from'] = this.startFrom;
    data['destination'] = this.destination;
    data['travel_date'] = this.travelDate;
    data['reach_date'] = this.reachDate;
    data['vehicle_details'] = this.vehicleDetails;
    data['available_luggage_weight'] = this.availableLuggageWeight;
    data['rate_per_kg'] = this.ratePerKg;
    data['ticket'] = this.ticket;
    data['delivery_status_id'] = this.deliveryStatusId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class ScheduledStatus {
  int? id;
  String? status;
  String? createdAt;
  String? updatedAt;

  ScheduledStatus({this.id, this.status, this.createdAt, this.updatedAt});

  ScheduledStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
