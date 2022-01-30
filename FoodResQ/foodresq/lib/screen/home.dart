import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/controller/auth_repository.dart';
import 'package:foodresq/models/push_notification.dart';
import 'package:foodresq/screen/add_ingredient.dart';
import 'package:foodresq/screen/ingredient_listing.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/select_ingredient.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodresq/local_notification_service.dart';
import 'package:overlay_support/overlay_support.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class _HomeScreenState extends State<HomeScreen> {

  //Initialize values
  late final FirebaseMessaging _messaging;

  //model 
  PushNotification? _notificationInfo;

  //register notification
  void registerNotification() async{
    await Firebase.initializeApp();
    //instance for firebase messaging
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      print("User granted the permission");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
        });

        if(_notificationInfo != null){
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.white,
            foreground: Colors.black,
            duration: Duration(seconds: 10)
          );
        }
      });
    }
    else{
      print("Permission declined by user");
    }
  }

  //check initial method that we receive
  checkForInitialMessage() async{
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = 
      await FirebaseMessaging.instance.getInitialMessage();
      
    if(initialMessage != null){
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body']
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> _screens = [
    IngredientListingPage(),
    SelectIngredientPage(),
    ProfileScreen()
  ];

  @override
  void initState() {
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body']
      );

      setState(() {
        _notificationInfo = notification;
      });
    });
    //normal notification
    registerNotification();

    //when app is in terminated state
    checkForInitialMessage();

    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        //physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColourConstant.kButtonColor,
        unselectedItemColor: ColourConstant.kGreyColor,
        // backgroundColor: Colors.white,
        // elevation: 30,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedLabelStyle: TextStyle(height: 1.5),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ingredients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Ingredient",
        backgroundColor: ColourConstant.kButtonColor,
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddIngredientPage(title: 'Add Ingredient')),
          );
        },
        child: Icon(
          Icons.add,
          size: 20,
          color: ColourConstant.kTextColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
