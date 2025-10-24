import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:shop/routes/profile.dart';

class HomePage extends StatelessWidget {
  final int initialTab;
  final String? message;

  const HomePage({
    super.key,
    this.initialTab = 1,
    this.message,
  }); // 2 یعنی تب Profile

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(initialTab: initialTab, message: message),
    );
  }
}

class Home extends StatefulWidget {
  final int initialTab;
  final String? message;
  const Home({super.key, this.initialTab = 1, this.message});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentPage;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialTab;
    _pageController = PageController(initialPage: _currentPage);

    // نمایش پیام در تب Profile بعد از فریم اول
    if (widget.message != null && _currentPage == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.message!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Container(color: Colors.blue),
          Container(
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4281FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        "Sing out",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(color: Colors.greenAccent.shade700, child: ProfilePage()),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.shopping_bag),
            title: Text('shop'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
            activeTitleColor: Colors.blue.shade600,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColorOpacity: 0.1,
            activeColor: Colors.greenAccent.shade700,
          ),
        ],
      ),
    );
  }
}
