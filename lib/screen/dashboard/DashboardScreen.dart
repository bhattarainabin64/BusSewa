import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/api/FireHelpher.dart';

import 'package:roadway_core/api/helpher_methods.dart';
import 'package:roadway_core/api/push_notification.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/address.dart';
import 'package:roadway_core/model/nearby_drivers.dart';

import 'package:snack/snack.dart';
import '../../dataprovider/appdata.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> imgList = [
    'assets/images/promo1.png',
    'assets/images/promo2.png',
  ];

  int _current = 0;

  GoogleMapController? _controller;
  LatLng? driverpostion;

  List driverpostionlist = [];
  String? busname;
  var arrivaltime = "";
  String? time;
  final Completer<GoogleMapController> _controllermap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  @override
  void initState() {
    PushNotificationService.initialize(context);
    PushNotificationService.getToken();
    createMarker();
    getCurrentPositon();
    super.initState();
  }

  Set<Marker> _markers = {};
  BitmapDescriptor markerImage = BitmapDescriptor.defaultMarker;
  bool nearbyDriverKeysLoaded = false;

  void createMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/car_1.png')
        .then((icon) => {markerImage = icon});
  }

  Future<void> _getAddress(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      address1 = placemarks[2].name;
      address2 = placemarks[0].locality;
      Provider.of<AppData>(context, listen: false)
          .updateAddress(address1!, address2!);
    } catch (e) {
      print('this is the error $e');
    }
  }

  void updateDriversOnMap() {
    Set<Marker> tempMarkers = <Marker>{};
    for (NearbyDrivers driver in FireHelpher.nearbyDriversList) {
      LatLng driverPosition =
          LatLng(driver.latitude as double, driver.longitude as double);
      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: markerImage,
        rotation: HelpherMethods.generateRandomNumber(360),
        infoWindow: InfoWindow(title: 'Driver ${driver.key}'),
      );
      tempMarkers.add(marker);
    }
    setState(() {
      _markers = tempMarkers;
    });
  }

  void getCurrentPositon() async {
    LocationPermission permission = await Geolocator.checkPermission();
    startGeofireListner();
    if (permission == LocationPermission.denied) {
      print("permission denied forever");
      Future<LocationPermission> asked = Geolocator.requestPermission();

      // request permission again

    } else {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      _getAddress(currentPosition!);
      Address pickUpAddress = Address(latitude: 0.0, longitude: 0.0);
      LatLng currentLatLng = LatLng(currentPosition!.latitude,
          currentPosition!.longitude); // add to curent location

      pickUpAddress.latitude = currentPosition!.latitude;
      pickUpAddress.longitude = currentPosition!.longitude;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpAddress(pickUpAddress);
      Provider.of<AppData>(context, listen: false)
          .updateCurrentLatLng(currentLatLng);

      _markers.add(
        Marker(
          draggable: true,
          markerId: const MarkerId("1"),
          position:
              LatLng(currentPosition!.latitude, currentPosition!.longitude),
          onDragEnd: (value) => print(value.latitude),
          infoWindow: const InfoWindow(title: ""),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 14);
      final GoogleMapController controller = _controller!;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {});
    }
  }

  void startGeofireListner() {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    Geofire.initialize('driverAvailable');
    Geofire.queryAtLocation(27.698997475959793, 85.37693867805122, 20)
        ?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];
            LatLng position =
                LatLng(currentPosition!.latitude, currentPosition!.longitude);

            updateToPickup(
                LatLng(nearbyDrivers.latitude as double,
                    nearbyDrivers.longitude as double),
                position);

            FireHelpher.nearbyDriversList.add(nearbyDrivers);
            if (nearbyDriverKeysLoaded) {
              print('adeeeeeeeeeeeeeeeeeeeees');
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelpher.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];

            print("driverrrrrrrrrrr positionnnn 222 ");
            print(driverpostion);
            FireHelpher.updateNearbyLocation(nearbyDrivers);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
  }

  void updateToPickup(LatLng driverLocation, LatLng position) async {
    print("dricer latlonggggggggggggggggg");
    print(driverLocation);

    var thisDetails =
        await HelpherMethods.getDirectionDetails(driverLocation, position);

    if (thisDetails == null) {
      return;
    }
    setState(() {
      time = "saja bus reach in ${thisDetails.durationText}";
    });
  }

  @override
  Widget build(BuildContext context) {
    String? firstaddress =
        Provider.of<AppData>(context, listen: false).address1;
    String? secondaddress = Provider.of<AppData>(context).address2;
    String? username = Provider.of<AppData>(context).first_name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 20, left: 25),
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child(
                      'user/${FirebaseAuth.instance.currentUser!.uid}/isRider')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DatabaseEvent? data = snapshot.data;
                  if (data!.snapshot.value == true) {
                    return CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          Navigator.pushNamed(context, "/rider_dashboard");
                        });
                  } else if (data.snapshot.value == false) {
                    return CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          const SnackBar(
                                  content: Text(
                                      'Please verify to turn ON the rider mode!'))
                              .show(context);
                        });
                  }
                }
                return CupertinoSwitch(value: false, onChanged: (value) {});
              },
            )),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Welcome $username!",
                style: const TextStyle(
                    color: Color.fromARGB(255, 121, 34, 139),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              // upgrade to pro icon
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/choose_verf_category");
                },
                child: const Icon(
                  Icons.bus_alert,
                  color: Color.fromARGB(255, 10, 13, 0),
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Your current location,",
                style: TextStyle(
                    color: Color.fromARGB(255, 21, 181, 23),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 13, 0, 0),
                    size: 28,
                  ),
                  Flexible(
                    child: Text(
                      '$firstaddress',
                      maxLines: 1,
                      style: GoogleFonts.baloo2(
                          // overflow: TextOverflow.ellipsis,
                          color: Color.fromARGB(255, 224, 50, 91),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 470,
              // child: GoogleMapsScreen(controller: _controllermap),
              child: GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  markers: _markers),
            ),
            SizedBox(
              height: 30,
            ),
            // Text("${time}"),
            // StreamBuilder(
            //   stream: FirebaseDatabase.instance
            //       .ref()
            //       .child('driverAvailable')
            //       .onValue,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       Map<dynamic, dynamic> data =
            //           snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            //       print(data.keys);
            //       // use for loop for keys
            //       return SizedBox(
            //         height: 100,
            //         child: ListView.builder(
            //             itemCount: data.length,
            //             shrinkWrap: true,
            //             itemBuilder: (context, index) {

            //               String userid = data.keys.elementAt(index);
            //               // DatabaseReference usrRef = FirebaseDatabase.instance
            //               //     .ref('user/${userid}/firstName');
            //               // usrRef.once().then((DatabaseEvent snapshot) {

            //               // setState(() {
            //               //    busname = snapshot.snapshot.value.toString();
            //               // });
            //               // });
            //               return Row(
            //                 children: [
            //                   ElevatedButton(
            //                       style: ElevatedButton.styleFrom(
            //                         backgroundColor:
            //                             Color.fromARGB(255, 57, 22, 83),
            //                       ),
            //                       onPressed: () {},
            //                       child: Text(
            //                         "Bus Name: $userid",
            //                         style: GoogleFonts.baloo2(
            //                             color: Colors.white,
            //                             fontSize: 18,
            //                             fontWeight: FontWeight.bold),
            //                       )),
            //                 ],
            //               );
            //             }),
            //       );
            //     }
            //     return const Text('');
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
