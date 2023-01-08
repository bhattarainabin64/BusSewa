import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';
import '../../dataprovider/appdata.dart';
import 'editprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamed(context, '/enter_phone');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? username = Provider.of<AppData>(context).full_name;
    FirebaseAuth auth = FirebaseAuth.instance;
    String phone = auth.currentUser!.phoneNumber.toString();

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        title: const Text(
          "Profile & Privacy",
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Stack(children: [
                            Container(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${Provider.of<AppData>(context).pofilepic}"),
                                // backgroundImage:
                                //     AssetImage('assets/images/logo.png'),
                                radius: 37,
                                backgroundColor:
                                    const Color.fromARGB(255, 187, 186, 186),
                              ),
                            ),
                            Positioned(
                                bottom: 2,
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditProfilePage()));
                                    },
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
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "$username",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
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
                                        255, 255, 255, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, top: 2, bottom: 2),
                                    child: Text(
                                      phone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),

            const SizedBox(
              height: 10,
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.drive_eta,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Driver Mode',
                  subtitle: "Verify to turn ON",
                  trailing: getVerified(),
                ),
                SettingsItem(
                  onTap: () {
                    Navigator.pushNamed(context, '/choose_verf_category');
                  },
                  icons: Icons.upgrade,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Upgrade to Driver',
                  subtitle: "Register as a BusSewa Driver!",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.fingerprint,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Security & Privacy',
                  subtitle: "Own your security",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.notifications,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Alerts & Permissions',
                  subtitle: "Manage your permission",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.language,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Language',
                  subtitle: "English",
                ),
              ],
            ),

            // vupertino button
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: CupertinoButton(
                onPressed: () {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Alert!",
                    message: "Are you sure wanna to log out?",
                    confirmButtonText: "Confirm",
                    cancelButtonText: "Cancel",
                    onTapCancel: () {
                      Navigator.pop(context);
                    },
                    onTapConfirm: () {
                      _signOut();
                    },
                    panaraDialogType: PanaraDialogType.error,
                    barrierDismissible:
                        false, // optional parameter (default is true)
                  );
                },
                color: Colors.black,
                child: const Text("Log out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget for the drawer
  Widget getVerified() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child('user/${FirebaseAuth.instance.currentUser!.uid}/isRider')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DatabaseEvent? data = snapshot.data;
          if (data!.snapshot.value == true) {
            return Switch(
                value: false,
                onChanged: (value) {
                  Navigator.pushNamed(context, "/rider_dashboard");
                });
          } else if (data.snapshot.value == false) {
            return Switch(
                value: false,
                onChanged: (value) {
                  const SnackBar(
                          content:
                              Text('Please verify to turn ON the rider mode!'))
                      .show(context);
                });
          }
        }
        return Switch(value: false, onChanged: (value) {});
      },
    );
  }
}
