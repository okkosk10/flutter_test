plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")   // ✅ kotlin-android 대신 최신 이름
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ Firebase 플러그인
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.example.ui_practice"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.ui_practice"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")

            // 개발 모드에서는 둘 다 끄기 (안정)
            isMinifyEnabled = false
            isShrinkResources = false
        }

        debug {
            // debug 빌드도 shrinkResources 끄기
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Firebase BOM (버전 통합)
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // Firebase 종속성
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-messaging")
}
