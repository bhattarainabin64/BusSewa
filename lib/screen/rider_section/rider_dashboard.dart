import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/api/helpher_methods.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/directiondetails.dart';
import 'package:roadway_core/model/places_model.dart';

import 'package:sliding_switch/sliding_switch.dart';
import 'package:snack/snack.dart';

import '../../dataprovider/appdata.dart';
import '../../model/nearby_drivers.dart';

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  List<Features> lstplaces = [];
  GoogleMapController? _animatecontroller;
  TextEditingController seach_destination = TextEditingController();
  bool isLoading = false;
  double rideBottonSheet = 0;
  double searchSheet = 50;
  double requestsheet = 0;
  late DatabaseReference rideRef;
  String? address;
  String? address2;
  String? appState = 'NORMAL';
  double bottomPaddingOfMap = 0;
  double tripSheetHeight = 0;
  bool isRequestingLocationDetails = false;

  DetailsResult? startPosition;
  DetailsResult? endPosition;
  String search = "";
  late FocusNode startFocusNode = FocusNode();
  late FocusNode endFocusNode = FocusNode();
  late GooglePlace googlePlace;
  List<Placemark> placemarks = [];
  List<AutocompletePrediction> predictions = [];
  List<AutocompletePrediction> predictions2 = [];

  //  source lat and long
  LatLng _sourceLocation = const LatLng(0.0, 0.0);
  LatLng _destinationLocation = const LatLng(0.0, 0.0);
  DirectionDetails tripDirectionDetails = DirectionDetails();

  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> _polylines = {};

  List<NearbyDrivers>? availableDrivers;
  String? fullname;
  String selectedVehicle = 'CAB';
  String selectedPayment = 'WALLET';

  // markers list
  Set<Marker> _markers = {};
  bool nearbyDriverKeysLoaded = false;
  // initial location of the map view
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  StreamSubscription<DatabaseEvent>? rideSubscription;

  showTripSheet() {
    setState(() {
      tripSheetHeight = 400;
    });
  }

  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();

  List<Widget> lstWidget = [
    const RiderDashboardScreen(),
    const RiderDashboardScreen(),
    const RiderDashboardScreen(),
  ];

  DatabaseReference? trigRequestRef;
  LatLng _currentLocation = const LatLng(0.0, 0.0);
  late GoogleMapController controller;

  void getCurrentPositon() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("permission denied forever");
    } else {
      _currentLocation =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 14);
      controller = await _controller!.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentPositon();
    getDirection();
    HelpherMethods.getHistoryInfo(context);
    HelpherMethods.getHistoryData(context);

    // setswichonlineoffline();
  }

  String? userId;

  void _goOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    userId = currentUser!.uid;
    Geofire.initialize('driverAvailable');
    //use firestore to set location

    Geofire.setLocation(
        userId!, _currentLocation.latitude, _currentLocation.longitude);
    await FirebaseFirestore.instance.collection('busdata').doc(userId!).set({
      'bus_information': {
        'latitude': _currentLocation.latitude,
        'longitude': _currentLocation.longitude,
        'source_point': // ignore: use_build_context_synchronously
            Provider.of<AppData>(context, listen: false).pickUpAddress,
        'destination_point':
            Provider.of<AppData>(context, listen: false).destinationAddress,
      }
    });

    trigRequestRef = FirebaseDatabase.instance.ref('user/$userId/newRide');
    trigRequestRef!.set('waiting');
    trigRequestRef!.onValue.listen((event) {});
  }

  void goOffline() {
    Geofire.removeLocation(currentUser!.uid);
    homeTabPositionStream!.cancel();
    trigRequestRef!.onDisconnect();
    trigRequestRef!.remove();
    trigRequestRef = null;
  }

  void _getLocatonLiveUpdates() {
    homeTabPositionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isOnline) {
        Geofire.setLocation(userId!, position.latitude, position.longitude);
        FirebaseFirestore.instance.collection('bus').doc(userId!).update({
          'bus_information': {
            'latitude': _currentLocation.latitude,
            'longitude': _currentLocation.longitude,
          }
        });
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickUpAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    // get latitute and longitude from address
    var getDestLatLng = await locationFromAddress(destination!.placeName!);
    // set destination lat and long
    var destLatLng =
        LatLng(getDestLatLng[0].latitude, getDestLatLng[0].longitude);
    // get latitute and longitude from address
    var pickLatLng = LatLng(pickup!.latitude, pickup.longitude);

    var thisDetails =
        await HelpherMethods.getDirectionDetails(pickLatLng, destLatLng);

    Provider.of<AppData>(context, listen: false).carestimatedFare(thisDetails!);
    Provider.of<AppData>(context, listen: false).bikeEstimatedFare(thisDetails);

    setState(() {
      isLoading = true;
      tripDirectionDetails = thisDetails;
      isLoading = false;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      for (var point in results) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _polylines.clear();
    setState(() {
      // set destination lat and long
      _destinationLocation = destLatLng;
      Polyline polyline = Polyline(
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(255, 11, 2, 35),
          jointType: JointType.round,
          points: polylineCoordinates,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap);

      _polylines.add(polyline);
    });

    // set marker
    Marker startMarker = Marker(
      markerId: const MarkerId("start"),
      position: _sourceLocation,
      infoWindow: InfoWindow(title: pickup.placeName, snippet: "My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination"),
      position: _destinationLocation,
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: "Destination"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(startMarker);
      _markers.add(destinationMarker);
    });

    LatLngBounds bounds;

    if (pickLatLng.latitude > destLatLng.latitude &&
        pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(southwest: destLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destLatLng.longitude),
          northeast: LatLng(destLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destLatLng.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickLatLng, northeast: destLatLng);
    }

    // animate camera to fit bounds
    _animatecontroller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 140),
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller!.complete(controller);
              },
              polylines: _polylines,
              markers: _markers,
            ),
          ),
          Container(
            height: 130,
            width: double.infinity,
            color: Colors.black45,
          ),
          // button

          Positioned(
              top: 40,
              left: 60,
              child: SlidingSwitch(
                textOff: 'Offline',
                textOn: 'Online',
                colorOn: Colors.green,
                value: isOnline,
                width: 250,
                onChanged: (bool value) {
                  if (value == true) {
                    _goOnline();
                    _getLocatonLiveUpdates();
                    setState(() {
                      isOnline = true;
                    });
                    const SnackBar(content: Text('You are ONLINE now!'))
                        .show(context);
                  } else {
                    goOffline();
                    setState(() {
                      isOnline = false;
                    });
                    const SnackBar(content: Text('You are OFFLINE now!'))
                        .show(context);
                  }
                },
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
              ))
        ],
      ),
    );
  }
}
