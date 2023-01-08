import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/dataprovider/appdata.dart';
import 'package:roadway_core/model/driver_model/driver_trip_details.dart';
import 'package:roadway_core/widgets/NotificationDialog.dart';

class PushNotificationService {
  static Future<String?> initialize(context) async {
    print("Notification service started");
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotificationService.getRideID(message, context);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: message.notification!.title,
                body: message.notification!.body));
                
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('error in push notification service $e');
    }
    return "";
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  static void getToken() async {
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token;
    await firebaseMessaging.getToken().then((value) => token = value);
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.ref().child('user/$userId');
    tokenRef.update({'token': token});
    firebaseMessaging.subscribeToTopic('alldrivers');
    firebaseMessaging.subscribeToTopic('allusers');
  }

  static getRideID(message, context) {
    String rideID = '';
    rideID = message.data['ride_id'];
    fetchRideInfo(rideID, context);
  }

  static fetchRideInfo(String rideID, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CupertinoActivityIndicator(
          radius: 20,
          color: Colors.white,
        );
      },
    );

    final rideRef = FirebaseDatabase.instance.ref();
    final snapshot = await rideRef.child('riderequest/$rideID').get();
    // Navigator.pop(context);
    if (snapshot.exists) {
      print('snapshot is ${snapshot.value}');
      try {
        Object? values = snapshot.value;
        Map<dynamic, dynamic> map = values as Map<dynamic, dynamic>;

        double pickupLat = map['location']['latitude'];
        double pickupLng = map['location']['longitude'];

        // latLng
        LatLng pickupLatLng = LatLng(pickupLat, pickupLng);
        String pickupAddress = map['pickup_address'];

        // destination
        double destinationLat = map['destination']['latitude'];
        double destinationLng = map['destination']['longitude'];
        String destinationAddress = map['destination_address'];

        String paymentMethod = map['payment_method'];
        String riderName = map['rider_name'];
        String requestUserId = map['user_id'];
        print(
            "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrequest_user_id: $requestUserId");

        DriverTripDetails tripDetails = DriverTripDetails();
        tripDetails.rideID = rideID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;

        // update on provider
        Provider.of<AppData>(context, listen: false).updateDriverPickUpLocation(pickupLatLng);
        Provider.of<AppData>(context, listen: false).updateSetRequestId(requestUserId);

        AssetsAudioPlayer.newPlayer().open(
          Audio("sounds/alert.mp3"),
          autoStart: true,
          showNotification: true,
        );

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(
                  tripDetails: tripDetails,
                ));
      } catch (e) {
        print(e);
      }
    } else {
      print('snapshot is not exist');
    }
  }
}
