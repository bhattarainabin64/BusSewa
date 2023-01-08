import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/screen/profile/viewkyc.dart';

import '../../dataprovider/appdata.dart';

class RiderProfile extends StatefulWidget {
  const RiderProfile({super.key});

  @override
  State<RiderProfile> createState() => _RiderProfileState();
}

class _RiderProfileState extends State<RiderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Stack(children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${Provider.of<AppData>(context).pofilepic}"),
                                  radius: 42,
                                  backgroundColor:
                                      const Color.fromARGB(255, 187, 186, 186),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {},
                                    ),
                                  )),
                            ]),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                   Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      Provider.of<AppData>(context).first_name.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child(
                                            'user/${FirebaseAuth.instance.currentUser!.uid}/isRider')
                                        .onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        DatabaseEvent? data = snapshot.data;
                                        if (data!.snapshot.value == true) {
                                          return const Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                          );
                                        }
                                        // if snapshot.data.value is null then show 0

                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            color: const Color.fromARGB(
                                                255, 244, 242, 242),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                                top: 2,
                                                bottom: 2),
                                            child: Text(
                                              "Unverified",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: const Color.fromARGB(
                                          255, 244, 242, 242),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                          top: 2,
                                          bottom: 2),
                                      child: Text(
                                        "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: const Color.fromARGB(
                                          255, 244, 242, 242),
                                    ),
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0,
                                              right: 4,
                                              top: 2,
                                              bottom: 2),
                                          child: Text(
                                            "5.0",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.star,
                                            color:
                                                Color.fromARGB(255, 12, 12, 12),
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: const Color.fromARGB(
                                        255, 244, 242, 242),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Update Profile Info",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
              const SizedBox(
                height: 9,
              ),
              const Divider(
                color: Color.fromARGB(255, 191, 190, 190),
                thickness: 2,
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.directions_bike,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.black,
                    ),
                    title: 'BA 84 9P 1223',
                    subtitle: "Update your vehicle info",
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, '/choose_verf_category');
                    },
                    icons: Icons.payment,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.black,
                    ),
                    title: 'Payment Methods',
                    subtitle: "Khalti. 9811245372",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.time_to_leave,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.black,
                    ),
                    title: 'Trip History',
                    subtitle: "0 Trip",
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewKYC(),
                        ),
                      );
                    },
                    icons: Icons.account_box,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.black,
                    ),
                    title: 'View KYC',
                    subtitle: "Edit your details",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.settings,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.black,
                    ),
                    title: 'Settings',
                    subtitle: "Manage your account",
                  ),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 18.0),
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: const []),
              // ),
            ],
          ),
        ),
      
    );
  }
}

