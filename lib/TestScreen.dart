import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:roadway_core/model/driver_model/driver_trip_details.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child('user/2aJiO6SoSLdKgrFfpUTNV6AWHxw2/rating');
    return Scaffold(
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final Object? values = snapshot.data!.snapshot.value;
          if (values != null) {
            return const Text('data');
          }
          return const Text('No data');
        },
      ),
    );
  }
}
