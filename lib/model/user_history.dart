import 'package:firebase_database/firebase_database.dart';

class History {
  String? pickup_address;
  String? destination_address;
  String? rider_name;
  String? created_at;
  String? payment_method;
  String? status;
  History({
    this.pickup_address,
    this.destination_address,
    this.rider_name,
    this.created_at,
    this.payment_method,
    this.status,
  });
  // to json
  Map<dynamic, dynamic> toJson() {
    return {
      'pickup_address': pickup_address,
      'destination_address': destination_address,
      'rider_name': rider_name,
      'created_at': created_at,
      'payment_method': payment_method,
      'status': status,
    };
  }

  static gethistory(Map<dynamic, dynamic> json) {
    return History(
      pickup_address: json['pickup_address'],
      destination_address: json['destination_address'],
      rider_name: json['rider_name'],
      created_at: json['created_at'],
      payment_method: json['payment_method'],
      status: json['status'],
    );
  }
  
}
