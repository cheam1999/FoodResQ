import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CircleAvatar(
        child: Image.asset('assets/graphics/app_icon.png'),
      )
    );
  }
}