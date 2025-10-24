import 'package:flutter/material.dart';
import 'package:shop/routes/handel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // اضافه کردن پکیج Supabase

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // مطمئن شوید که این خط قبل از راه‌اندازی اپلیکیشن است
  await Supabase.initialize(
    url: 'https://uuzikxatufwxxrasrhku.supabase.co', // URL پروژه Supabase شما
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1emlreGF0dWZ3eHhyYXNyaGt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg5NTE1NjUsImV4cCI6MjA3NDUyNzU2NX0.QZWpBL01RM3JRfBriXs1jg4ezbxKr0EXuu0ki6Y-PzY', // کلید آنون شما
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: Handel());
  }
}
