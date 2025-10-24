// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shop/routes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/routes/signUp.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  String get email => _emailController.text.trim();
  bool loading = false;
  Future? ResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()));
        },
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
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: height * 0.035,
                          ),
                        ),
                        SizedBox(width: height * 0.02),
                        Text(
                          "Reset password",
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
                              SizedBox(height: height * 0.06),
                              SizedBox(
                                width: height * 0.4,
                                child: Lottie.asset(
                                  'assets/resetpass.json',
                                  fit: BoxFit.contain,
                                  animate: true,
                                  repeat: true,
                                  reverse: false,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
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
                                      "Set a new password to continue.",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.04),

                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email_rounded,
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

                              // submit button
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
                                            setState(() {
                                              loading = true;
                                            });
                                            ResetPassword(email);
                                          },
                                          child: Text(
                                            "Password recovery",
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
