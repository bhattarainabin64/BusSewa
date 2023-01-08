import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/api/httpservices.dart';
import 'package:roadway_core/dataprovider/appdata.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/directiondetails.dart';
import 'package:roadway_core/model/user_history.dart';

import '../model/user_history.dart';

class HelpherMethods {
  static void disableHomeTabLocationUpdates() {
    homeTabPositionStream?.pause();
    Geofire.removeLocation(uuid!);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPositionStream?.resume();
    Geofire.setLocation(
        uuid!, currentPosition!.latitude, currentPosition!.longitude);
  }

  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';

    var dio = HttpServices().getDioInstance();
    var response = await dio.get(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response.data['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response.data['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response.data['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response.data['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
        response.data['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimatedFare(DirectionDetails details, int durationValue) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 30;
    double timeFare = (details.durationValue! / 60) * 5.50;

    double totalfare = basefare + distancefare + timeFare;
    return totalfare.truncate().toInt();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

  static void showProgressDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CupertinoActivityIndicator(
          radius: 20,
          color: Colors.white,
        );
      },
    );
  }

  static sendNotification(String token, context, String? rideId) {
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };
    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination!.placeName}',
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': rideId,
    };
    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    var dio = HttpServices().getDioInstance();
    dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: bodyMap,
      options: Options(
        headers: headerMap,
      ),
    );
    print("Notification sent");
  }

  static void getHistoryInfo(context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;
    DatabaseReference earningref =
        FirebaseDatabase.instance.ref().child('user/$id/earnings');
    earningref.once().then((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('user/$id/history');
    dbRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        int historyCount = values.length;
        Provider.of<AppData>(context, listen: false)
            .updateHistoryLength(historyCount.toString());

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripHistoryKeys(tripHistoryKeys);
      }
    });
  }

  static void getHistoryData(context) async {
    var keys = Provider.of<AppData>(context, listen: false).triphistorykeys;
    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.ref().child('riderequest/$key');
      historyRef.once().then((DatabaseEvent snapshot) {
        final data = snapshot.snapshot.value;
        if (data != null) {
          Map<dynamic, dynamic> data =
              snapshot.snapshot.value as Map<dynamic, dynamic>;
          var userHistory = History.gethistory(data);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistory(userHistory);
          // print userhistory all data
          print("histooooooooooooooooooooory");
          print(userHistory.pickup_address);
          // print(userHistory!.pickup_address);
        }
      });
    }
  }

  static void fetchwalletbalance(context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference fetchWalletBalance =
          FirebaseDatabase.instance.ref().child('user/${user!.uid}/wallet');
      DatabaseEvent event = await fetchWalletBalance.once();
      if (event.snapshot.value != null) {
        double totalBalance = double.parse(event.snapshot.value.toString());
        Provider.of<AppData>(context, listen: false)
            .updateWalletBalance(totalBalance.toStringAsFixed(2));
      } else {}
    } catch (e) {
      print('xerro : $e');
    }
  }

  static void createUserRideHistory(
      String? pickupaddress, String? destinationaddress, String? fares) {
    var user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    DatabaseReference userRideHistoryRef =
        FirebaseDatabase.instance.ref().child('user/$userId/userridehistory');
    var key = userRideHistoryRef.push().key;
    Map userRideHistoryMap = {
      'pickup_address': pickupaddress,
      'destination_address': destinationaddress,
      'fares': fares,
      'status': '',
      'created_at': DateTime.now().toString(),
    };
    userRideHistoryRef.child(key!).set(userRideHistoryMap);
  }

  static void updateRideHistory() {
   
  }
}
