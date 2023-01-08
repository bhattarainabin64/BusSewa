import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:roadway_core/widgets/custom_button.dart';

class LoadBalance extends StatefulWidget {
  const LoadBalance({Key? key}) : super(key: key);

  @override
  State<LoadBalance> createState() => _LoadBalanceState();
}

class _LoadBalanceState extends State<LoadBalance> {
  String loadamount = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Load Balance"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.26,
        child: SingleChildScrollView(
            child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: TextField(
                    onChanged: ((value) {
                      setState(() {
                        loadamount = value;
                      });
                    }),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    keyboardType: TextInputType.phone,
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
      DatabaseReference wallet_ref =
          FirebaseDatabase.instance.ref().child('user/${user!.uid}/wallet');
      DatabaseEvent event = await wallet_ref.once();
      if (event.snapshot.value != null) {
        double old_balance = double.parse(event.snapshot.value.toString());
        double updatewalletbalance = (success.amount.toDouble()) + old_balance;
        wallet_ref.set(updatewalletbalance.toStringAsFixed(2));
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/walletfirstscreen');
        // HelpherMethods.fetchwalletbalance(context);
      } else {
        double updatewalletbalance = (success.amount.toDouble());
        wallet_ref.set(updatewalletbalance.toStringAsFixed(2));
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/walletfirstscreen');
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
}
