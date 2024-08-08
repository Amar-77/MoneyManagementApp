import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict_project/pages/home_page.dart';
import 'package:ict_project/pages/login.dart';

import '../main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4a9591), Color(0xff043941)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SpendWise',
                    style: GoogleFonts.grandHotel(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Image.asset(
                    "assets/images/login1.png",
                    height: 300,
                  ),
                  GlassContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone no is required!';
                                } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                    .hasMatch(value)) {
                                  return 'Enter a valid phone number';
                                } else {
                                  return null;
                                }
                              },
                              controller: idController,
                              decoration: inputDeco('Phone Number', Icons.phone, ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required!';
                                } else if (!(value.length >= 6)) {
                                  return 'Password must have at least 6 letters';
                                } else {
                                  return null;
                                }
                              },
                              controller: passController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfc115a65),
                                contentPadding: const EdgeInsets.all(15),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(color: Colors.white70, width: .8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(color: Colors.white60, width: .8),
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xE8B9D4D1),
                                ),
                                prefixIcon: Icon(Icons.lock, color: Color(0xE8B9D4D1)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {

                                    await storeClass.store!.setString('username', idController.text.trim());
                                    await storeClass.store!.setString('password', passController.text.trim());

                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xec0c2d3d),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    'R E G I S T E R',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Already Have Account? Login',
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffffffff),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;

  const GlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: child,
      ),
    );
  }
}

InputDecoration inputDeco(String hint, IconData icon) {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xfc115a65),
    contentPadding: const EdgeInsets.all(15),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Colors.white70, width: .8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Colors.white60, width: .8),
    ),
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white70,
    ),
    prefixIcon: Icon(icon, color: Colors.white70),
  );
}
