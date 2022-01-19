import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(url, {Function? cantLaunchAction}) async {
  // if (await canLaunch(url)) {
  await launch(url);
  // } else {
  //   if (cantLaunchAction != null) cantLaunchAction();
  //   print('Could not launch $url');
  //   // throw 'Could not launch $url';
  // }
}
