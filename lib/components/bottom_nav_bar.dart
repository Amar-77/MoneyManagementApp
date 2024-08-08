import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key,required this.onTabChange});

  @override
  Widget build(BuildContext context)
  {
    return Container
      (
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent,Colors.transparent],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 1),
        child: GNav(
            color: Colors.white,
            activeColor: Colors.teal.shade900,
            tabActiveBorder: Border.all(color: Colors.transparent),
            tabBackgroundColor: Colors.grey.shade100,
            mainAxisAlignment: MainAxisAlignment.center,
            onTabChange: (value) => onTabChange!(value),
            tabs:
            const[
              GButton(icon: Icons.home,text: 'Home',),
              GButton(icon: Icons.person,text: 'profile',),
            ])

    );

  }
}
