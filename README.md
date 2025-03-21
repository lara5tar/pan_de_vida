# pan_de_vida

A new Flutter project.

- Error de namespace
com.yanisalfian.flutterphonedirectcaller

~/.pub-cache/hosted/pub.dev/flutter_phone_direct_caller-2.1.1/android

Ejemplo:
- C:\Users\Ana\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_phone_direct_caller-2.1.1\android

Abrir el build.gradle y tiene que quedar así:


android {
    namespace 'com.yanisalfian.flutterphonedirectcaller' <--- Esta linea
    compileSdkVersion 31

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17 <-- version de tu java
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        minSdkVersion 16
        targetSdkVersion 31
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
}

<!> IMPORTANT <!>
SET JAVA VERSION 17
flutter config --jdk-dir /usr/lib/jvm/java-17-openjdk/bin/java