android {
    namespace = "com.mho.shop"
    compileSdk = 33

    defaultConfig {
        applicationId = "com.mho.shop"
        minSdk = flutter.minSdkVersion
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {
            storeFile = file("C:/Users/Mho.ziaee/Documents/code/flutter/shop/upload-keystore.jks")
            storePassword = "@Mho1389"
            keyAlias = "upload"
            keyPassword = "@Mho1389"
        }
        create("debug") {
            storeFile = file("C:/Users/Mho.ziaee/Documents/code/flutter/shop/upload-keystore.jks")
            storePassword = "@Mho1389"
            keyAlias = "upload"
            keyPassword = "@Mho1389"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

repositories {
    google()
    mavenCentral()
    flatDir {
        dirs("libs") // مسیر فایل‌های JAR محلی
    }
}

dependencies {
    implementation(fileTree("dir" to "libs", "include" to listOf("*.jar")))

    implementation(name = "apkzlib-8.6.0", ext = "jar")
    implementation(name = "protos-31.6.0", ext = "jar")
    implementation(name = "core-proto-0.0.9-alpha02", ext = "jar")
    implementation(name = "signflinger-8.6.0", ext = "jar")
    implementation(name = "zipflinger-8.6.0", ext = "jar")
    implementation(name = "annotations-31.6.0", ext = "jar")
}
