import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/customcard.dart';

class ChooseVehicleScreen extends StatefulWidget {
  const ChooseVehicleScreen({super.key});

  @override
  State<ChooseVehicleScreen> createState() => _ChooseVehicleScreenState();
}

class _ChooseVehicleScreenState extends State<ChooseVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upgrade to Driver Mode"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Choose your Vehilce type",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            CustomCard(
              title: "Bus",
              subtitle: "Active your Driver as Bus",
              icon: Icons.bus_alert,
              onPressed: () {
                Navigator.pushNamed(context, '/rider_verf_1');
              },
            ),
            CustomCard(
              title: "Tampoo",
              subtitle: "Active your driver as Tampoo",
              icon: Icons.drive_eta,
              onPressed: () {},
            ),
            CustomCard(
              title: "Other Vehicle",
              subtitle: "Active rider as service provider",
              icon: Icons.airport_shuttle,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
