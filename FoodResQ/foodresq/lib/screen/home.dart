import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodresq/constants/colour_constant.dart';
import 'package:foodresq/screen/ingredient.dart';
import 'package:foodresq/screen/introduction.dart';
import 'package:foodresq/screen/profile.dart';
import 'package:foodresq/screen/recipe.dart';


class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> _screens = [
    IntroductionScreen(),
    
  ];

  @override
  void initState() {
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
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        //physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColourConstant.kTextColor2,
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
        onPressed: () {
          // TODO Snap photo
          print("pressed");
        },
        backgroundColor: ColourConstant.kButtonColor,
        elevation: 5.0,
        child: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
