import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict_project/main.dart';
import 'package:ict_project/pages/home_page.dart';

import 'forgot.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool obscurePassword = true; // Initially obscure password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/login1.png",
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  GlassContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone number is required!';
                                } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                                  return 'Enter a valid phone number';
                                } else {
                                  return null;
                                }
                              },
                              controller: idController,
                              decoration: inputDeco('Phone Number', Icons.phone),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required!';
                                } else if (!(value.length >= 6)) {
                                  return 'Password must have at least 6 characters';
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
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.white70, width: .8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.white60, width: .8),
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                prefixIcon: Icon(Icons.lock, color: Color(
                                    0xFFB9D4D1)),
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
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    String username = storeClass.store!.getString('username') ?? '';
                                    String pass = storeClass.store!.getString('password') ?? '';
                                    if (username == idController.text.trim() &&
                                        pass == passController.text.trim()) {
                                      await storeClass.store!.setBool('isLogin', true);
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ));
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Color(0xec0c2d3d),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: Text(
                                  'L O G   I N',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Don’t Have An Account? Sign Up',
                                  style: GoogleFonts.nunito(
                                    color: Color(0xD3FFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const Forgot()),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      'forgot password?',
                                      style: GoogleFonts.nunito(
                                        color: Color(0xD3FFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //   'Forgot Password?',
                                //   style: GoogleFonts.nunito(
                                //     color: Colors.white,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),


                                const SizedBox(width: 20),
                              ],
                            ),
                            const SizedBox(height: 40),
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
    return Container(
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
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}

InputDecoration inputDeco(String hint, [IconData? icon]) {
  return InputDecoration(
    filled: true,
    fillColor: Color(0xfc115a65),
    contentPadding: const EdgeInsets.all(15),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD00909), width: .8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white70, width: .8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white60, width: .8),
    ),
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white70,
    ),
    prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
  );
}
