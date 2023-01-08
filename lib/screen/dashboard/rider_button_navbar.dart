import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:roadway_core/screen/profile/ridersprofile.dart';

import 'package:roadway_core/screen/rider_section/rider_dashboard.dart';
import 'package:roadway_core/screen/rider_section/search_route_for_bus.dart';

class RiderNavbar extends StatefulWidget {
  const RiderNavbar({Key? key}) : super(key: key);

  @override
  State<RiderNavbar> createState() => _RiderNavbarState();
}

class _RiderNavbarState extends State<RiderNavbar> {
  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const Addroute(),
    const RiderDashboardScreen(),
    const RiderProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 40), label: 'Add Route'),
          BottomNavigationBarItem(
              icon: Icon(Icons.motorcycle, size: 40), label: 'Ride'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40), label: 'Account'),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 194, 192, 192),
        selectedItemColor: const Color.fromARGB(255, 24, 24, 24),
        elevation: 10,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: lstWidget[_selectedIndex],
    );
  }
}
