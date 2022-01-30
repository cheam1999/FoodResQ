import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodresq/utilities/user_shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodresq/local_notification_service.dart';

import 'env.dart';
import 'main_common.dart';

// Global userID hard code
//int userID = 1;
// Future<void> backgroundHandler(RemoteMessage message) async{
//   print(message.data.toString());
//   print(message.notification!.title);
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Firebase.initializeApp();
  // var messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
  //   messaging.getToken().then((value){
  //       print(value);
  //   });
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  var url = Platform.isAndroid
      //? 'http://192.168.0.102:8000/api/'
      ? 'http://10.0.2.2:8000/api/'
      : 'http://localhost/foodresq-api/';

  BuildEnvironment.init(flavor: BuildFlavor.local, baseUrl: url);
  assert(env != null);

  await UserSharedPreferences.init();

  runApp(ProviderScope(child: MyApp()));
}
