import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/routes/email.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';
import 'package:shop/routes/password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart'; // اضافه شد

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  String? imageUrl; // URL تصویر از Supabase
  bool isUploading = false;
  String? cachedFilePath;

  @override
  void initState() {
    super.initState();
    loadCachedOrServerImage();
  }

  // بارگذاری عکس از کش یا سرور
  Future<void> loadCachedOrServerImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final cacheDir = await getTemporaryDirectory();
    cachedFilePath = '${cacheDir.path}/profile_${currentUser.uid}.png';
    final cachedFile = File(cachedFilePath!);

    if (await cachedFile.exists()) {
      setState(() {
        image = cachedFile;
      });
    } else if (currentUser.photoURL != null &&
        currentUser.photoURL!.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(currentUser.photoURL!));
        if (response.statusCode == 200) {
          await cachedFile.writeAsBytes(response.bodyBytes);
          imageUrl = currentUser.photoURL;
          FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
          setState(() {
            image = cachedFile;
          });
        }
      } catch (e) {
        debugPrint('Error fetching image from server: $e');
      }
    }

    // همیشه imageUrl هم ست کن
  }

  Widget avatarWidget(double size) {
    if (image != null) {
      return Image.file(image!, fit: BoxFit.cover, width: size, height: size);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            Image.asset("assets/avatar.png", width: size, height: size),
      );
    } else {
      return Image.asset(
        "assets/avatar.png",
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      final filePath = File(pickedFile.path);
      setState(() {
        image = filePath;
      });

      await uploadImageToSupabase(filePath);
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  Future<void> uploadImageToSupabase(File file) async {
    setState(() => isUploading = true);
    final fileName =
        'profile_pics/${DateTime.now().millisecondsSinceEpoch}.png';
    try {
      // حذف کش قدیمی
      if (cachedFilePath != null) {
        final cachedFile = File(cachedFilePath!);
        if (await cachedFile.exists()) {
          await cachedFile.delete();
        }
      }

      // آپلود تصویر جدید
      await Supabase.instance.client.storage
          .from('profile_pics')
          .upload(fileName, file);
      String publicUrl = Supabase.instance.client.storage
          .from('profile_pics')
          .getPublicUrl(fileName);

      if (publicUrl.isEmpty) {
        final signedUrl = await Supabase.instance.client.storage
            .from('profile_pics')
            .createSignedUrl(fileName, 3600);
        // ignore: unnecessary_null_comparison
        if (signedUrl != null && signedUrl.isNotEmpty) publicUrl = signedUrl;
      }

      if (publicUrl.isEmpty) throw 'Unable to obtain public or signed URL.';

      setState(() {
        imageUrl = publicUrl;
        image = null; // پاک کردن کش تصویر قبلی
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(publicUrl);
        await user.reload();
      }

      // ذخیره فایل جدید در کش گوشی
      if (cachedFilePath != null) {
        final cachedFile = File(cachedFilePath!);
        await cachedFile.writeAsBytes(await file.readAsBytes());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload completed successfully.')),
      );
    } catch (e) {
      debugPrint('Error uploading image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> signOut() async {
    // پاک کردن کش هنگام خروج
    if (cachedFilePath != null) {
      final cachedFile = File(cachedFilePath!);
      if (await cachedFile.exists()) await cachedFile.delete();
    }
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: () => Get.offAll(HomePage()),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: height * 0.035,
                          ),
                        ),
                        SizedBox(width: height * 0.02),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: height * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.24,
                      child: Column(
                        children: [
                          Container(
                            width: height * 0.17,
                            height: height * 0.17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: pickImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: avatarWidget(height * 0.17),
                                    ),
                                    if (isUploading)
                                      const Positioned.fill(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                'User',
                            style: TextStyle(
                              fontSize: height * 0.035,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 0),
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
                              SizedBox(height: height * 0.05),
                              // password
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30.0,
                                  left: 30,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(PasswordPage());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF3F5FB),
                                    ),
                                    width: double.infinity,
                                    height: height * 0.08,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                bottom: 5,
                                                right: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xFFE6EDFA),
                                              ),
                                              height: double.infinity,
                                              width: 60,
                                              child: Icon(
                                                Icons.lock_open_rounded,
                                                color: const Color(0xFF4281FF),
                                                size: height * 0.025,
                                              ),
                                            ),
                                            Text(
                                              "Password",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.018,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // email
                              SizedBox(height: height * 0.02),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30.0,
                                  left: 30,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(EmailPage());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF3F5FB),
                                    ),
                                    width: double.infinity,
                                    height: height * 0.08,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                bottom: 5,
                                                right: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xFFE6EDFA),
                                              ),
                                              height: double.infinity,
                                              width: 60,
                                              child: Icon(
                                                Icons.email_outlined,
                                                color: const Color(0xFF4281FF),
                                                size: height * 0.025,
                                              ),
                                            ),
                                            Text(
                                              "Email Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.018,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Support
                              SizedBox(height: height * 0.02),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30.0,
                                  left: 30,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF3F5FB),
                                    ),
                                    width: double.infinity,
                                    height: height * 0.08,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                bottom: 5,
                                                right: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xFFE6EDFA),
                                              ),
                                              height: double.infinity,
                                              width: 60,
                                              child: Icon(
                                                Icons.phone_in_talk_outlined,
                                                color: const Color(0xFF4281FF),
                                                size: height * 0.025,
                                              ),
                                            ),
                                            Text(
                                              "Support",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.018,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Sign out
                              SizedBox(height: height * 0.02),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30.0,
                                  left: 30,
                                ),
                                child: GestureDetector(
                                  onTap: signOut,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF3F5FB),
                                    ),
                                    width: double.infinity,
                                    height: height * 0.08,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                bottom: 5,
                                                right: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xFFE6EDFA),
                                              ),
                                              height: double.infinity,
                                              width: 60,
                                              child: Icon(
                                                Icons.logout_outlined,
                                                color: const Color(0xFF4281FF),
                                                size: height * 0.025,
                                              ),
                                            ),
                                            Text(
                                              "Sign Out",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.018,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
