import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:roadway_core/api/FireHelpher.dart';

import 'package:roadway_core/dataprovider/appdata.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/nearby_drivers.dart';

class CurrentUser {
  static getCurrentUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    uuid = auth.currentUser!.uid;

    final doc = FirebaseFirestore.instance
        .collection('user')
        .doc(uuid)
        .snapshots()
        .listen((userData) {
      var json = userData.data() as Map<String, dynamic>;

      Provider.of<AppData>(context, listen: false).setName(
          json['user_information']['firstName'],
          json['user_information']['lastName']);

    
    });
  }

  // static void startGeofireListnerforlatlang(context) {
  
  //   print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  //   Geofire.initialize('driverAvailable');
  //   Geofire.queryAtLocation(27.698997475959793, 85.37693867805122, 20)
  //       ?.listen((map) {
  //     if (map != null) {
  //       var callBack = map['callBack'];
  //       switch (callBack) {
  //         case Geofire.onKeyEntered:
  //           NearbyDrivers nearbyDrivers = NearbyDrivers();
  //           nearbyDrivers.key = map['key'];
  //           nearbyDrivers.latitude = map['latitude'];
  //           nearbyDrivers.longitude = map['longitude'];

  //           print("driverrrrrrrrrrr positionnnn111 ");
           
  //           LatLng  driverpostion = LatLng(nearbyDrivers.latitude as double,
  //                 nearbyDrivers.longitude as double);

  //           Provider.of<AppData>(context, listen: false)
  //               .updateLoadLatLangtime(driverpostion);
            
       
            

  //           // FireHelpher.nearbyDriversList.add(nearbyDrivers);

  //           break;

  //         case Geofire.onKeyExited:
  //           FireHelpher.removeFromList(map['key']);

  //           break;

  //         case Geofire.onKeyMoved:
  //           NearbyDrivers nearbyDrivers = NearbyDrivers();
  //           nearbyDrivers.key = map['key'];
  //           nearbyDrivers.latitude = map['latitude'];
  //           nearbyDrivers.longitude = map['longitude'];

  //           print("driverrrrrrrrrrr positionnnn 222 ");

  //           // FireHelpher.updateNearbyLocation(nearbyDrivers);

  //           break;

  //         case Geofire.onGeoQueryReady:
  //           break;
  //       }
  //     }
  //   });
  // }
  // static fetchrewardpoints(context) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     DatabaseReference fetchReward =
  //         FirebaseDatabase.instance.ref().child('user/${user!.uid}/wallet');
  //     DatabaseEvent event = await fetchReward.once();
  //     if (event.snapshot.value != null) {
  //       String totalReward = event.snapshot.value.toString();
  //       Provider.of<AppData>(context, listen: false)
  //           .updateTotalReward(totalReward);
  //     } else {}
  //   } catch (e) {
  //     print('xerro : $e');
  //   }
  // }
}
