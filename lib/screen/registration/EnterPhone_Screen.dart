import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/dataprovider/appdata.dart';

import '../../widgets/custom_button.dart';
import 'package:snack/snack.dart';

class EnterPhoneScreen extends StatefulWidget {
  const EnterPhoneScreen({super.key});
  static String verify = "";
  static String phoneNumber = "";
  static Function()? phoneVerification;
  @override
  State<EnterPhoneScreen> createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  var phoneNumber = "";
  var resenToken;
  bool isLoading = false;
  _navigateToScreen(bool isLogin) {
    if (isLogin) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      const SnackBar(content: Text('Session has been experied!')).show(context);
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  phoneVerification(String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+977$phone',
      timeout: const Duration(seconds: 30),
      forceResendingToken: resenToken,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          const SnackBar(content: Text('Invalid Phone Number')).show(context);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        Provider.of<AppData>(context, listen: false)
            .setVerification(verificationId);

        EnterPhoneScreen.verify = verificationId;
        Navigator.pushNamed(context, '/verify_otp');
        SnackBar(content: Text('OTP has been sent to +977 $phone'))
            .show(context);
        setState(() {
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Image.asset(
                'assets/images/bussewa-login.png',
                height: 400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continue with phone number',
                    style: GoogleFonts.baloo2(
                        color: Color.fromARGB(233, 14, 81, 181),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 5),
            // Text form field with curved border
      
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(left: 20, right: 0),
                    child: TextField(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "+977",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 97, 27, 147)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      height: 55,
                      margin: const EdgeInsets.only(left: 0, right: 23),
                      child: TextFormField(
                        maxLength: 10,
      
                        // validator phone number
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter phone number';
                          } else if (value.length < 10) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
      
                        keyboardType: TextInputType.phone,
      
                        onChanged: (value) {
                          phoneNumber = value;
                          EnterPhoneScreen.phoneNumber = value;
                        },
      
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          hintText: "98########",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 121, 34, 139)),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              loading: isLoading,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.wifi) {
                    phoneVerification(phoneNumber);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                    const SnackBar(content: Text('No internet connection'))
                        .show(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
