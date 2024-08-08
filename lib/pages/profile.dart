import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'bills.dart'; // Import the Bills page

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Function to show warning dialog before clearing history
  Future<void> _showClearHistoryDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // User must choose an option
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff84c1b3),
          title: Text('Clear History'),
          content: Text('Are you sure you want to clear all history? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Color(0xff054952)),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Clear',style: TextStyle(color: Color(0xff054952))),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _clearHistory(); // Clear history
              },
            ),
          ],
        );
      },
    );
  }

  // Function to clear history and reset values
  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all the keys from SharedPreferences
    final allKeys = prefs.getKeys();

    // Define keys related to login and sign-up that should not be cleared
    final protectedKeys = {'login', 'signup'};

    // Remove keys that are not protected
    for (var key in allKeys) {
      if (!protectedKeys.contains(key)) {
        await prefs.remove(key);
      }
    }

    // Optionally, you could show a confirmation snack bar or navigate to a different page
    // For example, showing a snack bar:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('History cleared successfully')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade700, Colors.teal.shade400],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg1.jpg',
              fit: BoxFit.cover,
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(),
            ),



            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4.0,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 95,
                                        backgroundImage: AssetImage('assets/images/pic.jpg'),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Person x',
                                        style: TextStyle(
                                            fontFamily: 'Lobster',
                                            color: Color(0xFF2A0253),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'More Options'.toUpperCase(),
                                        style: const TextStyle(
                                            color: Color(0xFF0C2D3D),
                                            fontSize: 18,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 150,
                                      child: Divider(
                                        height: 10,
                                        thickness: 1,
                                        color: Color(0xFF0C2D3D),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const Bills(),
                                          ),
                                        );
                                      },
                                      child: const Card(
                                        elevation: 8,
                                        color: Color(0xFF00292F),
                                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.cloud_upload,
                                            color: Colors.white,
                                          ),
                                          title: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              '     Upload Bills',
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                                        );
                                        print("Card tapped");
                                      },
                                      child: const Card(
                                        elevation: 8,
                                        color: Color(0xFF054952),
                                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.account_circle_outlined,
                                            color: Colors.white,
                                          ),
                                          title: Padding(
                                            padding: EdgeInsets.only(left: 0, right: 0),
                                            child: Text(
                                              '   Add another account',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const Card(
                                      elevation: 8,
                                      color: Color(0xFF016C73),
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.dark_mode_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            '       Themes',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Card(
                                      elevation: 8,
                                      color: Color(0xFF418891),
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.security_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Security & Privacy',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showClearHistoryDialog(context),
                                      child: const Card(
                                        elevation: 8,
                                        color: Color(0xFF65AFAA),
                                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.history_outlined,
                                            color: Colors.white,
                                          ),
                                          title: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              '     Clear History',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                                        );
                                      },
                                      child: const Card(
                                        elevation: 8,
                                        color: Color(0xffb2c3c3),
                                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.exit_to_app_outlined,
                                            color: Colors.white,
                                          ),
                                          title: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              '     Sign Out',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            children: [
                              Center(child: Text("Follow us on:",style: TextStyle(color: Color(
                                  0xffa7b4be)),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Color(0xfffd00b2),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Color(0xff0453e1),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Color(0xff1ed660),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.linkedin,
                                    color: Color(0xff0060fd),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.github,
                                    color: Color(0xff1b171b),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.twitter,
                                    color: Color(0xff0f100f),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
