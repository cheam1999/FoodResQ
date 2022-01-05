import 'package:flutter/material.dart';
import 'package:foodresq/screen/introduction.dart';
import 'package:foodresq/utilities/size_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartScreen extends ConsumerStatefulWidget {
  static String routeName = "/start";
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  // PageController _pageController = PageController();
  // int _selectedIndex = 0;

  // List<Widget> _screens = [IngredientScreen(), SelectIngredientPage(), ProfileScreen()];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //final authControllerState = ref.watch(authControllerProvider);

    //hardcode
    isLoading = false;

    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : IntroductionScreen();
    // authControllerState.isLogin
    //     ? HomeScreen()
    //     : IntroductionScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
