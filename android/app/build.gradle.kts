import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Carrega key.properties (arquivo esperado na raiz do projeto)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// Lê as propriedades de forma segura
val storeFilePath: String? = keystoreProperties.getProperty("storeFile")
val storePasswordProp: String? = keystoreProperties.getProperty("storePassword")
val keyAliasProp: String? = keystoreProperties.getProperty("keyAlias")
val keyPasswordProp: String? = keystoreProperties.getProperty("keyPassword")

android {
    namespace = "com.example.socioquest"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.socioquest"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            println("storeFilePath: $storeFilePath")
            println("storePasswordProp: $storePasswordProp")
            println("keyAliasProp: $keyAliasProp")
            println("keyPasswordProp: $keyPasswordProp")

            if (storeFilePath == null || storePasswordProp == null || keyAliasProp == null || keyPasswordProp == null) {
                throw GradleException(
                    "Keystore properties missing or incomplete. " +
                    "Verifique o arquivo key.properties na raiz do projeto e as chaves: " +
                    "storeFile, storePassword, keyAlias, keyPassword"
                )
            }

            storeFile = file(storeFilePath)
            storePassword = storePasswordProp
            keyAlias = keyAliasProp
            keyPassword = keyPasswordProp
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
