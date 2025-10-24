
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:shop/routes/login.dart';
import 'package:get/get.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("this is a email page")));
  }
}
