plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.stowise.stowise_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "dev.stowise.stowise_mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Flavors (ADR-0008): dev aponta para a API local e aceita HTTP; prod usa a URL de demonstração (HTTPS).
    // resValue define o nome do app por flavor (AGP novo exige ligar o recurso).
    buildFeatures {
        resValues = true
    }

    flavorDimensions += "ambiente"
    productFlavors {
        create("dev") {
            dimension = "ambiente"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Stowise Dev")
            manifestPlaceholders["usaHttp"] = "true"
        }
        create("prod") {
            dimension = "ambiente"
            resValue("string", "app_name", "Stowise")
            manifestPlaceholders["usaHttp"] = "false"
        }
    }

    buildTypes {
        release {
            // APK de demonstração: assinado com a chave de debug (não vai para a loja).
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
