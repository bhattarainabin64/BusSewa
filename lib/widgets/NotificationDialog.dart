import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadway_core/api/helpher_methods.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/driver_model/driver_trip_details.dart';

import 'package:snack/snack.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key, required this.tripDetails});

  final DriverTripDetails tripDetails;

  void checkAvailability(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text('Fetching ride details...'),
            ],
          ),
        );
      },
    );

    String thisRideId = '';
    DatabaseReference docRef =
        FirebaseDatabase.instance.ref('user/${currentUser!.uid}/newRide');
    DatabaseEvent event = await docRef.once();
    Navigator.pop(context);

    if (event.snapshot.value != null) {
      thisRideId = event.snapshot.value.toString();
    }

    if (thisRideId == tripDetails.rideID) {
      docRef.set('accepted');
      HelpherMethods.disableHomeTabLocationUpdates();
      
    } else if (thisRideId == 'cancelled') {
      const SnackBar(content: Text('Ride Cancelled')).show(context);
    } else if (thisRideId == 'timeout') {
      const SnackBar(content: Text('Ride Timed Out')).show(context);
    } else {
      const SnackBar(content: Text('Ride no longer available')).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(2),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // card
            Column(
              children: [
                // image
                Image.asset(
                  'assets/images/black_car.png',
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                ),
                // title
                Text(
                  'New Ride Alert!',
                  style: GoogleFonts.baloo2(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    // ICons
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),

                    // text
                    Text(
                      'PICKUP LOCATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // pickup location
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      tripDetails.pickupAddress!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    // ICons
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.green,
                      ),
                    ),
                    // text
                    Text(
                      'DROPOFF LOCATION',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                // pickup location
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      tripDetails.destinationAddress!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const Divider(
                  height: 2,
                  thickness: 1,
                ),

                // profile image and name
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // profile image
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    // name
                    Text(
                      tripDetails.riderName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Divider(
                  height: 2,
                  thickness: 1,
                ),

                const SizedBox(
                  height: 10,
                ),

                // total fare and payment method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // total fare
                    Column(
                      children: const [
                        Text(
                          'OFFERED',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'NPR.440',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // payment method
                    Column(
                      children: [
                        const Text(
                          'PAY BY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          tripDetails.paymentMethod!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: const [
                        Text(
                          'DISTANCE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '6.59 KM',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
                // reject and accept elevated button
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, '/newtrip');
                            checkAvailability(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
