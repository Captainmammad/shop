// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shop/routes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _currentPasswordcontroller = TextEditingController();
  final _newPasswordcontroller = TextEditingController();
  final _repeatPasswordcontroller = TextEditingController();

  bool loading = false;

  String get currentpass => _currentPasswordcontroller.text.trim();
  String get newpass => _newPasswordcontroller.text.trim();
  String get repeatpass => _repeatPasswordcontroller.text.trim();

  void showMessage(String message, {Color color = Colors.redAccent}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void changePassword(String newpass, String repeatpass, currentpass) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => loading = false);
      showMessage("No user logged in");
      return;
    }

    final cred = EmailAuthProvider.credential(
      email: user.email.toString(),
      password: currentpass,
    );

    user
        .reauthenticateWithCredential(cred)
        .then((value) {
          if (newpass != repeatpass) {
            setState(() => loading = false);
            showMessage("Passwords do not match");
            return;
          }

          user
              .updatePassword(newpass)
              .then((_) {
                setState(() => loading = false);
                showMessage("Password changed ✅", color: Colors.green);
                Get.offAll(
                  HomePage(initialTab: 2, message: "Password changed ✅"),
                );
              })
              .catchError((error) {
                setState(() => loading = false);
                showMessage("invalid new password");
              });
        })
        .catchError((e) {
          setState(() => loading = false);
          showMessage("Passwords do not match");
        });
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
                          "Change password",
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
                                width: height * 0.3,
                                child: Lottie.asset(
                                  'assets/chaingpass.json',
                                  fit: BoxFit.contain,
                                  animate: true,
                                  repeat: true,
                                  reverse: false,
                                ),
                              ),
                              SizedBox(height: height * 0.00),
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
                                      "Change your password to continue.",
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

                              // current password
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _currentPasswordcontroller,
                                  obscureText: true,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Current password",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.password_sharp,
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

                              // new password
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _newPasswordcontroller,
                                  obscureText: true,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "New password",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.add_box_rounded,
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

                              // repeat password
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _repeatPasswordcontroller,
                                  obscureText: true,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Repeat password",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.repeat_on,
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

                              SizedBox(height: height * 0.015),

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
                                            changePassword(
                                              newpass,
                                              repeatpass,
                                              currentpass,
                                            );
                                          },
                                          child: Text(
                                            "Change password",
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
