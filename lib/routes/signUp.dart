import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

bool isValidUsername(String username) {
  return username.isNotEmpty; // Check if username is not empty
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  bool loading = false;

  String get user => _usernamecontroller.text.trim();
  String get email => _emailcontroller.text.trim();
  String get password => _passwordcontroller.text.trim();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp(String email, String password, String username) async {
    setState(() {
      loading = true;
    });

    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // بروزرسانی نام کاربری و reload
        await user.updateDisplayName(username);
        await user.reload();

        setState(() {
          loading = false;
        });

        Get.offAll(HomePage()); // حالا می‌توانید به HomePage بروید
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      String message = "An unknown error occurred ❌";
      if (e.code == 'email-already-in-use') {
        message = "The email is already in use ❌";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak ❌";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format ❌";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
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
                          "Sign up.",
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
                                      "Create your account to get started.",
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

                              // --- فیلد یوزرنیم ---
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _usernamecontroller,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.02,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
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

                              // --- فیلد ایمیل ---
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: height * 0.02),
                                  decoration: InputDecoration(
                                    hintText: "E-mail",
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

                              // --- فیلد پسورد ---
                              Container(
                                height: height * 0.055,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: TextField(
                                  controller: _passwordcontroller,
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

                              SizedBox(height: height * 0.015),

                              // --- دکمه ثبت نام ---
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
                                            if (isValidEmail(email) &&
                                                password.isNotEmpty) {
                                              signUp(email, password, user);
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
                                            "Sign up",
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

                              // --- لینک ورود ---
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "I'm already a member ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: height * 0.016,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(LoginPage());
                                      },
                                      child: Text(
                                        "Sign in",
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
