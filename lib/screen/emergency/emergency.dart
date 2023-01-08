// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:roadway_core/dataprovider/appdata.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../widgets/custom_button.dart';
// import 'package:roadway_core/global_variable.dart';
// import 'package:snack/snack.dart';

// class EmergencyScreen extends StatefulWidget {
//   const EmergencyScreen({super.key});

//   @override
//   State<EmergencyScreen> createState() => _EmergencyScreenState();
// }

// class _EmergencyScreenState extends State<EmergencyScreen> {
//   @override
//   Widget build(BuildContext context) {
//       return Center(
//       child: showBottomSheet(),
//     );
//   }
//   void showBottomSheet(){

//     showModalBottomSheet<void>(
//             context: context,
//             builder: (BuildContext context) {
//               return Container(
//                 height: 200,
//                 color: Colors.amber,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       const Text('Modal BottomSheet'),
//                       ElevatedButton(
//                         child: const Text('Close BottomSheet'),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );

//   }
// }
