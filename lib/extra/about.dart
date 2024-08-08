import 'package:flutter/material.dart';
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar:AppBar(backgroundColor: Colors.transparent,),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Color(0xff4a9591), Color(0xff043941)],

          ),
        ),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("MEMBERS: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
            SizedBox(height: 30,),
            Text("AMARJITH",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            Text("MADHAV",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            Text("ASHLEY",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            Text("AWIKA",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),



          ],
        ),
    ))

    );
  }
}
