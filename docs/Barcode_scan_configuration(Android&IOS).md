### Android

[Barcode_scan](https://pub.dev/packages/barcode_scan)

For Android, you must do the following before you can use the plugin:

- Ajoutez les droits d'utilisation de l'appareil photo dans votre AndroidManifest.xml
  
  `<uses-permission android:name="android.permission.CAMERA" />`

- Ce plugin est écrit en Kotlin. Par conséquent, vous devez ajouter le support Kotlin à votre projet.. Voir [installez Kotlin](https://kotlinlang.org/docs/tutorials/kotlin-android.html#installing-the-kotlin-plugin).

Editez votre `android/build.gradle` pour qu'il soit comme ci-dessous :

```groovy
buildscript {
    ext.kotlin_version = '1.3.61'
    // ...
    dependencies {
        // ...
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
// ...
```

Editez votre `android/app/build.gradle` pour qu'il soit comme ci-dessous :

```groovy
apply plugin: 'kotlin-android'
// ...

android {
    // ...
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.RuneoDriverFlutter"
        minSdkVersion 18
        targetSdkVersion 28
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
// ...
}
// ...
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    // ...
}
```

### iOS

Pour utiliser sur iOS, vous devez ajouter la description de l'utilisation de la caméra à votre Info.plist

```xml
<dict>
    <!-- ... -->
    <key>NSCameraUsageDescription</key>
    <string>Camera permission is required for barcode scanning.</string>
    <!-- ... -->
</dict>
```
