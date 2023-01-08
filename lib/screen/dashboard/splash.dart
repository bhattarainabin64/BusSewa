import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';

class SplashScren extends StatefulWidget {
  const SplashScren({Key? key}) : super(key: key);

  @override
  State<SplashScren> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  _navigateToScreen(bool isLogin) {
    if (isLogin) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      
    }
  }

  void autoLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if (token != null) {
      _navigateToScreen(true);
    } else {
      _navigateToScreen(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/enter_phone');
    });

     autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
            'https://daddyduckinnovationlab.files.wordpress.com/2020/06/bus.gif',
            height: 900,
            width: 900),
      ),
    );
  }
}
