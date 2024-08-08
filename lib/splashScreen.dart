import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF047D6F),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff4a9591), Color(0xff043941)],
          ),
        ),
        child: Center(
          child: LottieBuilder.asset('assets/Lottie/ani.json'),
        ),
      ),
    );
  }
}
