// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://maven.myket.ir") } // اختیاری
        flatDir {
            dirs("libs") // اضافه کردن مسیر پوشه libs برای فایل‌های JAR محلی
        }
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.6.0")
        classpath("com.google.gms:google-services:4.3.15")
        classpath(kotlin("gradle-plugin", version = "2.1.0"))
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://maven.myket.ir") } // اختیاری
        flatDir {
            dirs("libs") // اضافه کردن مسیر پوشه libs برای فایل‌های JAR محلی
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
