import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/models/customer_model.dart';

class Api {
  /// Adding customer
  static Future<bool> addCustomer(
      String name, String customerNumber, String customerCountry) async {
    bool success = false;
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    Map requestBody = {
      "name": name,
      "deviceId": Constants.DEVICE_ID,
      "phone": customerNumber,
      "country": customerCountry
    };

    var jsonBody = json.encode(requestBody);
    log('json body in add customer api $jsonBody');

    try {
      var res = await http.post(
        Uri.parse(Constants.BASE_URL + 'addCustomer'),
        body: jsonBody,
        headers: headers,
      );

      log('response    ' + res.body);

      if (res.body.toString().contains('Cusomer added successfully')) {
        // String customerId = jsonDecode(res.body)[0]['id'];
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // preferences.setString('custId', customerId);
        // log('cust id stored in prefs in  API');
        log('user created');
        success = true;
      } else {
        //await showAlert("Something went wrong Please login again");
        success = false;
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
    return success;
  }

  /// Create customer profile
  static Future<bool> createCustomerProfile(Map<String, dynamic> body) async {
    bool success = false;

    log('body in API $body');
    // Map<String, String> headers = {
    //   'Content-Type': 'multipart/form-data',
    // };
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
    };

    var jsonBody = json.encode(body);
    log('json body in API $jsonBody');

    try {
      var res = await http.post(
        Uri.parse(Constants.BASE_URL + 'addCustomerProfile'),
        body: body,
        headers: headers,
      );

      log('response    ' + res.body);

      if (res.body.toString().contains('Cusomer profile added successfully')) {
        log('profile created');
        success = true;
      } else {
        print('error crating customer Profile');
        //await showAlert("Something went wrong Please login again");
        success = false;
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
    return success;
  }

  /// Get Single Customer Details \

  static Future<Customer> getCustomerFromPhone(String customerNumber) async {
    Customer customer = Customer();
    try {
      var res = await http.get(Uri.parse(
          Constants.BASE_URL + 'getCustomerFromPhone/$customerNumber'));

      //log('response    ' + res.body);

      customer = Customer.fromJson(jsonDecode(res.body)[0]);
      log(customer.id!);
    } catch (e) {
      print(e);
    }
    return customer;
  }

  /// Add a new Trip

  static Future<bool> addTrip(Map<String, dynamic> body) async {
    bool success = false;

    log('body in API $body');
    // Map<String, String> headers = {
    //   'Content-Type': 'multipart/form-data',
    // };
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
    };

    var jsonBody = json.encode(body);
    log('json body in API $jsonBody');

    try {
      var res = await http.post(
        Uri.parse(Constants.BASE_URL + 'addTripDetails'),
        body: body,
        headers: headers,
      );

      log('response    ' + res.body);

      if (res.body.toString().contains('Cusomer profile added successfully')) {
        log('profile created');
        success = true;
      } else {
        print('error adding Trip');
        //await showAlert("Something went wrong Please login again");
        success = false;
      }
      print(res.body);
    } catch (e) {
      print(e);
    }
    return success;
  }
}
