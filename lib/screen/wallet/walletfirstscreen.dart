import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadway_core/model/khalti_qr-model.dart';
import 'package:roadway_core/widgets/custom_button.dart';

import '../../dataprovider/appdata.dart';
import '../../model/wallet_qr_model.dart';

class WalletFirstScreen extends StatefulWidget {
  const WalletFirstScreen({super.key});

  @override
  State<WalletFirstScreen> createState() => _WalletFirstScreenState();
}

class _WalletFirstScreenState extends State<WalletFirstScreen> {
  File? img;
  File? imgk;
  String? loadamount = '0';

  Future _loadImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      final path = 'wallet/qr/${image!.name}';

      if (image != null) {
        setState(() {
          img = File(image.path);
        });
        _qrAdd();
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick Image $e');
    }
  }

  Future _loadImagekhalti(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      final path = 'wallet/qr/${image!.name}';

      if (image != null) {
        setState(() {
          imgk = File(image.path);
        });
        _khaltiqrAdd();
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick Image $e');
    }
  }

  UploadTask? uploadTask;

  // firebase registration code
  Future _qrAdd() async {
    String? urlDownload;
    final path = 'wallet/qr/_${DateTime.now()}.png';
    final file = File(img!.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => null);
      urlDownload = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image $e');
    }
    Provider.of<AppData>(context, listen: false)
        .updateEsewaQrUrl(urlDownload.toString());
    final user = qrInfo(
      qr_pic: urlDownload,
    );
    final json = user.toJson();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      final riderVerification =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);

      await riderVerification.update({
        'esewa_vpayment': json,
      });
      // Navigator.pushNamed(context, '/rider_verf_2');
      // isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  Future _khaltiqrAdd() async {
    String? urlDownload;

    final path = 'wallet/qr_khalti/_${DateTime.now()}.png';
    final file = File(imgk!.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => null);
      urlDownload = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image $e');
    }
    final user = qrInfo_khalti(
      khalti_pic: urlDownload,
    );
    final json = user.toJson();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      final riderVerification =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);

      await riderVerification.update({
        'khalti_vpayment': json,
      });
      print('doneeeeeeeeeeeeeeeeeeeeeee');
      // Navigator.pushNamed(context, '/rider_verf_2');
      // isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        child: CupertinoActionSheet(
          title: const Text('Choose one option'),

          // message: const Text('Message'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: GestureDetector(
                  onTap: () {
                    _loadImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: const Text('Esewa')),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: GestureDetector(
                  onTap: () {
                    _loadImagekhalti(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: const Text('Khalti')),
            ),
            CupertinoActionSheetAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as delete or exit and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? esewaWalletUrl = Provider.of<AppData>(context).esewa_wallet_url;

    String? khaltiWalletUrl = Provider.of<AppData>(context).khalti_wallet_url;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 380.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 12),
                          child: Text(
                            ' Roadway Cash',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0, left: 16),
                          child: StreamBuilder(
                            stream: FirebaseDatabase.instance
                                .ref()
                                .child(
                                    'user/${FirebaseAuth.instance.currentUser!.uid}/wallet')
                                .onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                DatabaseEvent? data = snapshot.data;
                                if (data!.snapshot.value == null) {
                                  return const Text(
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                      'रू 0.00');
                                }
                                // if snapshot.data.value is null then show 0

                                return Text(
                                  // convert data.snapshot.value to rupees by dividing by 100

                                  "रू ${((double.parse(data.snapshot.value.toString())) / 100).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return const Text('..');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: Text(
                  "Top up your cash",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  "Pay with",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/esewapay.png'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Load from eSewa",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.add_circle_rounded)
              ]),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/khaltipay.png'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Load from Khalti",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/loadbalance');
                    },
                    child: const Icon(Icons.add_circle_rounded))
              ]),
              const Divider(
                thickness: 1,
                height: 60,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  child: const Text(
                    "Add manual payments",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: const Color.fromARGB(255, 241, 240, 240),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Add new",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showActionSheet(context);
                                  },
                                  child: const Icon(Icons.add_circle_rounded),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8, right: 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Image.asset(
                                          'assets/images/esewa.png'),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text(
                                      "Esewa QR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 143, 141, 141)),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showEsewaMyDialog();
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    child: Image.asset('assets/images/qr.png'),
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Image.asset(
                                          'assets/images/khalti.jpg'),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text(
                                      "Khalti QR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 143, 141, 141)),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showMyKhaltiDialog();
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    child: Image.asset('assets/images/qr.png'),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  paywuthKhaltiApp() {
    KhaltiScope.of(context).pay(
        config: PaymentConfig(
            amount: int.parse(loadamount.toString()),
            productIdentity: "productid",
            productName: "productname"),
        preferences: [PaymentPreference.khalti],
        onSuccess: onSuccss,
        onFailure: onFailure);
  }

  void onSuccss(PaymentSuccessModel success) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference walletRef =
          FirebaseDatabase.instance.ref().child('user/${user!.uid}/wallet');
      DatabaseEvent event = await walletRef.once();
      if (event.snapshot.value != null) {
        double oldBalance = double.parse(event.snapshot.value.toString());
        double updatewalletbalance = (success.amount.toDouble()) + oldBalance;
        walletRef.set(updatewalletbalance.toStringAsFixed(2));
        // HelpherMethods.fetchwalletbalance(context);
      } else {
        double updatewalletbalance = (success.amount.toDouble());
        walletRef.set(updatewalletbalance.toStringAsFixed(2));
        // HelpherMethods.fetchwalletbalance(context);
      }
    } catch (e) {
      print('xerro : $e');
    }

    // try {
    //   User? user = FirebaseAuth.instance.currentUser;
    //   final wallet =
    //       FirebaseFirestore.instance.collection('user').doc(user!.uid);
    //   final amount = Khaltiwallet(
    //     amount: success.amount.toString(),
    //   );
    //   final json = amount.toJson();

    //   await wallet.update({
    //     'wallet_balance': json,
    //   });
    //   print('doneeeeeeeeeeeeeeeeeeeeeee');
    //   // Navigator.pushNamed(context, '/rider_verf_2');
    //   // isLoading = false;
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  void onFailure(PaymentFailureModel failure) {
    SnackBar snackBar = SnackBar(
      content: Text("${failure.message} "),
    );
  }

  Future<void> _showEsewaMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uploaded Esewa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image(
                    height: 300,
                    width: 300,
                    image: NetworkImage(
                        "${Provider.of<AppData>(context).esewa_wallet_url}"))

                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyKhaltiDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uploaded Khalti'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image(
                    height: 300,
                    width: 300,
                    image: NetworkImage(
                        "${Provider.of<AppData>(context).khalti_wallet_url}"))

                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showRequestingbootomModel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: SingleChildScrollView(
                child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    child: Container(
                      height: 55,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: TextField(
                        onChanged: ((value) {
                          setState(() {
                            loadamount = value;
                          });
                        }),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter the load amount in paisa",
                          hintStyle: TextStyle(color: Colors.grey.shade700),
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
                  CustomButton(
                    text: "Load amount",
                    loading: false,
                    onPressed: () {
                      paywuthKhaltiApp();
                    },
                  )
                ],
              ),
            )),
          );
        });
  }
}
