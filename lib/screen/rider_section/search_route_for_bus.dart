import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/dataprovider/appdata.dart';
import 'package:roadway_core/widgets/location_list_tile.dart';
import '../../model/address.dart';

class Addroute extends StatefulWidget {
  const Addroute({super.key});

  @override
  State<Addroute> createState() => _AddrouteState();
}

class _AddrouteState extends State<Addroute> {
  late FocusNode startFocusNode = FocusNode();
  late FocusNode endFocusNode = FocusNode();
  TextEditingController seach_destination = TextEditingController();
  TextEditingController pickup = TextEditingController();
  String? address;
  String? address2;
  Timer? _debounce;
  List<AutocompletePrediction> predictions = [];
  List<AutocompletePrediction> predictions2 = [];
  late GooglePlace googlePlace;

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.queryAutocomplete.get(
      value,
      radius: 30000,
      language: "ne",
      // offset: -3,
      location: const LatLon(27.7172, 85.300140),
    );

    print('xxl $result');

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String apiKey = 'AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';
    googlePlace = GooglePlace(apiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    address = Provider.of<AppData>(context).address1;
    address2 = Provider.of<AppData>(context).address2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Confirm the destination address",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: "Brand-Bold",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    CupertinoSearchTextField(
                      controller: pickup..text = "$address, $address2",
                      focusNode: startFocusNode,
                      prefixIcon: const Icon(Icons.pin_drop_outlined),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 12),
                      prefixInsets: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 12),
                      // controller: textController,
                      placeholder: 'Pickup Location',
                      onChanged: ((value) {}),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CupertinoSearchTextField(
                      controller: seach_destination,
                      focusNode: endFocusNode,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            if (_debounce?.isActive ?? false) {
                              _debounce!.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 0), () {
                              if (value.isNotEmpty) {
                                autoCompleteSearch(value);
                              } else {
                                setState(() {
                                  predictions = [];
                                });
                              }
                            });
                          }
                        });
                      },
                      prefixIcon: const Icon(Icons.pin_drop),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 12),
                      prefixInsets: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 12),
                      placeholder: 'Search destination',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // decoration
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.1,
                      0.1,
                    ),
                  ),
                ],
              ),

              child: ListView.builder(
                  shrinkWrap: true,
                  primary: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return LocationListTile(
                      location: predictions[index].description.toString(),
                      press: () {
                        if (endFocusNode.hasFocus) {
                          setState(() {
                            Address destinationAddress =
                                Address(latitude: 0.0, longitude: 0.0);
                            destinationAddress.placeName =
                                predictions[index].description.toString();
                            Provider.of<AppData>(context, listen: false)
                                .updateDestinationAddress(destinationAddress);
                            seach_destination.text =
                                predictions[index].description.toString();
                            predictions = [];
                            Navigator.pushNamed(
                                context, '/riderDashboardScreen');
                          });
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
