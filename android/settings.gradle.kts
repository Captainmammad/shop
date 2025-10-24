pluginManagement {
    val flutterSdkPath = run {
        val props = java.util.Properties()
        file("local.properties").inputStream().use { props.load(it) }
        val sdk = props.getProperty("flutter.sdk")
        require(sdk != null) { "flutter.sdk not set in local.properties" }
        sdk
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url = uri("https://maven.myket.ir") } // اختیاری
    }

    plugins {
        id("com.android.application") version "8.2.1" apply false
        id("com.google.gms.google-services") version "4.3.15" apply false
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://maven.myket.ir") } // اختیاری
    }
}

rootProject.name = "shop"
include(":app")  // این خط باید در انتهای فایل باشد
