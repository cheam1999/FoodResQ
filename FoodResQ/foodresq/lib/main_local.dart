import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodresq/utilities/user_shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'env.dart';
import 'main_common.dart';

// Global userID hard code
//int userID = 1;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  var url = Platform.isAndroid
      ? 'http://192.168.0.102:8000/api/'
      //? 'http://10.0.2.2:8000/foodresq-api/'
      : 'http://localhost/foodresq-api/';

  BuildEnvironment.init(flavor: BuildFlavor.local, baseUrl: url);
  assert(env != null);

  await UserSharedPreferences.init();

  runApp(ProviderScope(child: MyApp()));
}
