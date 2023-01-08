import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadway_core/global_variable.dart';
import 'package:roadway_core/model/address.dart';
import 'package:roadway_core/model/directiondetails.dart';
import 'package:roadway_core/model/user_history.dart';

class AppData extends ChangeNotifier {
  String? address1 = "";
  String? address2 = "";

  // make update addres function and retrun name
  updateAddress(String placeName1, String placeName2) {
    address1 = placeName1;
    address2 = placeName2;
    notifyListeners();
  }

  // update payment method
  String? paymentMethod = "";
  void updatePaymentMethod(String payment) {
    print("String? paymentMethod = ""String? paymentMethod = "" method is $payment");
    paymentMethod = payment;
    notifyListeners();
  }

  // update ride id
  String? rideId;
  void updateRideId(String id) {
    rideId = id;
    notifyListeners();
  }

  // make update addres function and retrun name
  Address? pickUpAddress;
  void updatePickUpAddress(Address pickUp) {
    pickUpAddress = pickUp;
    notifyListeners();
  }

  // let pick up latitute and longitute
  LatLng? currentPosition = LatLng(0.0, 0.0);
  void updateCurrentLatLng(LatLng pos) {
    // sset pick up latitute and longitute
    currentPosition = LatLng(pos.latitude, pos.longitude);
    notifyListeners();
  }

  Address? destinationAddress;
  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  // create function whchich accept direction details
  // and return fare
  void carestimatedFare(DirectionDetails details) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 30;
    double timeFare = (details.durationValue! / 60) * 5.50;

    double totalfare = basefare + distancefare + timeFare;
    totalFare = totalfare.truncate().toString();
    notifyListeners();
  }

  void bikeEstimatedFare(DirectionDetails details) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 10;
    double timeFare = (details.durationValue! / 60) * 3.50;

    double totalfare = basefare + distancefare + timeFare;
    biketotalFare = totalfare.truncate().toString();
    notifyListeners();
  }

  String? first_name = "";
  String? last_name = "";
  String? full_name = "";

  void setName(String firstname, String lastname) {
    first_name = firstname;
    last_name = lastname;
    full_name = "$firstname $lastname";

    notifyListeners();
  }

  String? pofilepic =
      "https://i.pinimg.com/736x/e2/7c/87/e27c8735da98ec6ccdcf12e258b26475.jpg";
  void setProfilePic(String? profileurl) {
    pofilepic = profileurl;
    notifyListeners();
  }

  String? esewa_wallet_url =
      "https://fisnikde.com/wp-content/uploads/2019/01/broken-image.png";

  void getWalletQrpic(String? esewaurl) {
    esewa_wallet_url = esewaurl;
    notifyListeners();
  }

  String? khalti_wallet_url =
      "https://fisnikde.com/wp-content/uploads/2019/01/broken-image.png";
  void getkhaltiurl(String? khaltiurl) {
    khalti_wallet_url = khaltiurl;
    notifyListeners();
  }

  var verification = "";
  void setVerification(String ver) {
    verification = ver;
  }

  // driver pick up location
  LatLng? driverPickUpLocation;
  void updateDriverPickUpLocation(LatLng pos) {
    driverPickUpLocation = LatLng(pos.latitude, pos.longitude);
    notifyListeners();
  }

  String earnings = "0";
  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  String historylength = "0";
  void updateHistoryLength(String newHistoryLength) {
    historylength = newHistoryLength;
    notifyListeners();
  }

  List<String> triphistorykeys = [];
  void updateTripHistoryKeys(List<String> newTripHistoryKeys) {
    triphistorykeys = newTripHistoryKeys;
    notifyListeners();
  }

  List<History> triphistory = [];
  void updateTripHistory(History newTripHistory) {
    triphistory.add(newTripHistory);
    notifyListeners();
  }

  String? esewa_qr_url = "";
  void updateEsewaQrUrl(String newEsewaQrUrl) {
    esewa_qr_url = newEsewaQrUrl;
    notifyListeners();
  }

  String? wallet_balance = "0.00";
  void updateWalletBalance(String newWalletBalance) {
    wallet_balance = newWalletBalance;
    notifyListeners();
  }

  String? set_request_id = "";
  void updateSetRequestId(String newSetRequestId) {
    set_request_id = newSetRequestId;
    notifyListeners();
  }

  int ? load_amount = 0;
  void updateLoadAmount(int? newLoadAmount) {
    load_amount = int.parse(newLoadAmount.toString());
    notifyListeners();
  }

  LatLng? load_latlang;
  void updateLoadLatLangtime(LatLng ? newLoadLatLang) {
    load_latlang = LatLng(newLoadLatLang!.latitude, newLoadLatLang.longitude);
    notifyListeners();
  }
  



  // String? total_reward = "0";
  // void updateTotalReward(String newTotalReward) {
  //   total_reward = newTotalReward;
  //   print("rewardddddddddddddddddddddddddddddd");
  //   print(total_reward);
  //   notifyListeners();
  // }
}
