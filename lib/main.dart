import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'api/push_notification.dart';
import 'dataprovider/appdata.dart';
import 'screen/dashboard/bottom_nav_bar.dart';
import 'screen/dashboard/rider_button_navbar.dart';
import 'screen/dashboard/search_page.dart';
import 'screen/dashboard/splash.dart';
import 'screen/profile/editprofile.dart';
import 'screen/profile/profilescreen.dart';
import 'screen/profile/ridersprofile.dart';
import 'screen/profile/viewkyc.dart';
import 'screen/registration/EnterPhone_Screen.dart';
import 'screen/registration/OtpScreen.dart';
import 'screen/registration/addational_information.dart';
import 'screen/registration/rider_registration/rider_verification_1.dart';
import 'screen/registration/rider_registration/rider_verification_2.dart';
import 'screen/registration/rider_registration/supporting_doc_3.dart';
import 'screen/rider_section/rider_dashboard.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService.getToken();

  // INITIALIZE AWESOME NOTIFICATIONS
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/launcher',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  // firebase messaging
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'Message data: ${message.notification!.body} ${message.notification!.title}');
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: message.notification!.title,
            body: message.notification!.body));
  });

  // background notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: KhaltiScope(
        enabledDebugging: true,
        publicKey: "test_public_key_bb1471963e924514a506965357fd2c02",
        builder: (context, navigatorKey) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash',
            routes: {
              '/splash':(context) => const SplashScren(),
              '/viewkyc': (context) => const ViewKYC(),
              '/enter_phone': (context) => const EnterPhoneScreen(),
              '/verify_otp': (context) => const OtpScreen(),
              '/rider_verf_1': (context) => const RiderVerificationScreen1(),
              '/user_registation': (context) => const UserRegistrationScreen(),
              '/rider_verf_3': (context) => const SupportingDoc3(),
              '/rider_verf_2': (context) => const RiderVerificationScreen2(),
              '/dashboard': (context) => const Navbar(),
              '/profile': (context) => const ProfileScreen(),
              '/rider_dashboard': (context) => const RiderNavbar(),
              '/editprofile': (context) => const EditProfilePage(),
              '/riderprofile': (context) => const RiderProfile(),
              '/search': (context) => const SearchPage(),
              '/riderDashboardScreen':(context) => const RiderDashboardScreen(),
            },
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
          );
        },
      ),
    );
  }
}
