import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/resetPassword.dart';
import 'package:shop/routes/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool loading = false;

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> login(String email, String password) async {
    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // کاربر لاگین است
        Get.to(HomePage());
        // اینجا شرط یا کد دلخواهت رو اجرا کن
      } else {
        // کاربر لاگین نیست
        Get.to(LoginPage());
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful ✅"),
          backgroundColor: Colors.green,
        ),
      );

      // You can navigate to the home page here
      // Get.to(HomePage());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      String message = "An unknown error occurred ❌";
      if (e.code == 'user-not-found') {
        message = "No user found with this email ❌";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password ❌";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format ❌";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent, // Softer red color
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFC1D1ED),
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFF4281FF)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: height * 0.035,
                        ),
                        SizedBox(width: height * 0.02),
                        Text(
                          "Log In.",
                          style: TextStyle(
                            fontSize: height * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: height * 0.4,
                                child: Lottie.asset(
                                  'assets/Login.json',
                                  fit: BoxFit.contain,
                                  animate: true,
                                  repeat: true,
                                  reverse: false,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double fontSize =
                                        constraints.maxWidth * 0.04;

                                    if (constraints.maxWidth < 400) {
                                      fontSize = constraints.maxWidth * 0.045;
                                    }
                                    if (constraints.maxWidth > 600) {
                                      fontSize = constraints.maxWidth * 0.03;
                                    }

                                    return Text(
                                      "Welcome back! Please log in to your account.",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: height * 0.025,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.015,
                                      horizontal: 20,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.008),
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: height * 0.025,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.015,
                                      horizontal: 20,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: height * 0.015),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(ResetPasswordPage());
                                      },
                                      child: Text(
                                        "Forgot password ?",
                                        style: TextStyle(
                                          color: Color(0xFF4281FF),
                                          fontSize: height * 0.015,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.019),
                              Column(
                                children: [
                                  Visibility(
                                    visible: !loading,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: height * 0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF4281FF,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (email.isNotEmpty &&
                                                password.isNotEmpty) {
                                              login(email, password);
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Invalid email or password ❌",
                                                  ),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Log In",
                                            style: TextStyle(
                                              fontSize: height * 0.022,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: loading,
                                    child: const CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.04),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account ? ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: height * 0.016,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(SignUpPage());
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                          color: Color(0xFF4281FF),
                                          fontSize: height * 0.016,
                                        ),
                                      ),
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}
