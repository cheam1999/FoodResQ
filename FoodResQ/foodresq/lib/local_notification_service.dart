import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodresq/screen/ingredient_listing.dart';


class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin 
  = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context){
    final InitializationSettings initializationSettings = 
    InitializationSettings(
      android: AndroidInitializationSettings("app_icon"));

      _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? route) async{
        if(route != null){
          //Navigator.of(context).pushNamed(route);
          Navigator.pushNamedAndRemoveUntil(context, route, ModalRoute.withName('/'));
        }
      });
  }

  static void display(RemoteMessage message) async{
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "foodresq",
          "foodresq channel",
          //"this is our channel",
          importance: Importance.max,
          priority: Priority.high,
        )
      );
      
      await _notificationsPlugin.show(
        id, 
        message.notification!.title, 
        message.notification!.body, 
        notificationDetails,
        payload: message.data["route"]
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}