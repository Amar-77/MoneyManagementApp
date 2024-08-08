import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      home: SplashScreenHandler(),
    );
  }
}

class SplashScreenHandler extends StatefulWidget {
  @override
  _SplashScreenHandlerState createState() => _SplashScreenHandlerState();
}

class _SplashScreenHandlerState extends State<SplashScreenHandler> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    await storeClass.getStorage();
    final bool login = storeClass.store!.getBool('isLogin') ?? false;
    final String signUp = storeClass.store!.getString('username') ?? 'null';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => (signUp != 'null')
            ? (login)
            ? const HomePage()
            : const LoginPage()
            : const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen();
  }
}

class GetStorage {
  late SharedPreferences? store;

  Future<void> getStorage() async {
    store = await SharedPreferences.getInstance();
  }
}

final GetStorage storeClass = GetStorage();
