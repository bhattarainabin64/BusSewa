// global variable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? address1;
String? address2;
StreamSubscription<Position>? homeTabPositionStream;

User? currentUser = FirebaseAuth.instance.currentUser;

String? uuid;
StreamSubscription<Position>? ridePositionStream;

DatabaseReference? rideRef;

Position? currentPosition;

String status = '';
String request_status = '';

String mapAPIKEY = 'AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';

String serverKey =
    'key=AAAAzfB5cac:APA91bG6phSeKptccUpMHhsY7L3H9xUPOIaHeE5zIE0MbF-bDw4Mg-ZKOhtU9g4ZYagdS5Rj-ELFLE3jjOUS2vuStfFFigKX5qm_4awSwmJ4ufX0M9JUsp9Uyxb5vFy6bM71Gw5GCp0A';

String tripStatusDisplay = 'is arriving';
String? totalFare = "";
String? biketotalFare = "";
