### Android implémentation

1. Ouvrez la [console Firebase](https://console.firebase.google.com/) et créez un nouveau projet

2. Entrez un nom pour votre projet

![](C:\Users\Mumin\Documents\Diplome\Firebase%20Console\name%20project.png)

3. Suivez l'assistant, préciser le package name doit être le même que celui qui se trouve dans `Android/app/src/main/AndroidManifest.xml`

![](C:\Users\Mumin\Documents\Diplome\Firebase%20Console\package%20name.png)

4. Placez le fichier `google-services.json` sous `Android/app`

5. Il faut ajouter le classpath de google dans `[projet]/android/build.gradle`
   
   ```kotlin
   dependencies {
       classpath 'com.android.tools.build:gradle:3.5.3'
       classpath 'com.google.gms:google-services:4.3.3' -> Checkez la version
       classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
   }
   ```

6. Il faut ajouter les services google dans `[projet]/android/app/build.gradle`

```kotlin
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services' <---
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
```

7. Remarque : lorsque vous déboguez sur Android, utilisez un appareil ou un AVD avec les services Google Play. Sinon, vous ne pourrez pas vous authentifier.
   
   (facultatif, mais recommandé) Si vous souhaitez être notifié dans votre application (via onResume et onLaunch, voir ci-dessous) lorsque l'utilisateur clique sur une notification dans la barre d'état système, incluez le filtre d'intention suivant dans le tag <activity> sous `android/app/src/main/AndroidManifest.xml`:
   
   ```xml
   <intent-filter>
       <action android:name="FLUTTER_NOTIFICATION_CLICK" />
       <category android:name="android.intent.category.DEFAULT" />
   </intent-filter>
   ```
   
   #### Possibilité de gérer les messages depuis le background
   
   Par défaut, les notifications en arrière-plan ne sont pas activées. Pour traiter les messages en arrière-plan :
   
   1. Ajoutez la dépendance `com.google.firebase:firebase-messaging` dans votre fichier app-level build.gradle qui se trouve généralement sous `<app-name>/android/app/build.gradle`.
   
   ```kotlin
   dependencies {
     // ...
   
     implementation 'com.google.firebase:firebase-messaging:<latest_version>'
   }
   ```

       Vous trouverez la dernière version [ici ("Cloud Messaging")](https://firebase.google.com/support/release-notes/android#latest_sdk_versions)

2. Créez un nouveau fichier `Application.java` sous `<app-name>/android/app/src/main/java/<app-organization-path>/` dans le même dossier où se trouve le `MainActivity.java`
   
   ```java
   package com.example.RuneoDriverFlutter; --> Le nom de votre package
   
   import io.flutter.app.FlutterApplication;
   import io.flutter.plugin.common.PluginRegistry;
   import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
   import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
   import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
   
   public class Application extends FlutterApplication implements PluginRegistrantCallback {
     @Override
     public void onCreate() {
       super.onCreate();
       FlutterFirebaseMessagingService.setPluginRegistrant(this);
     }
   
     @Override
     public void registerWith(PluginRegistry registry) {
       FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
     }
   }
   ```

### IOS implémentation

**Il faut un compte Apple Developer pour pouvoir activer les push notifications sur IOS.**

Pour intégrer ce plugin dans la partie iOS de l'application, suivez ces étapes :

1. Générer les certificats requis par Apple pour recevoir les notifications "push" en suivant [ce guide](https://firebase.google.com/docs/cloud-messaging/ios/certs) dans la documentation de Firebase. Vous pouvez sauter la section intitulée *Create the Provisioning Profil*.

2. En utilisant la [Console Firebase](https://console.firebase.google.com/), ajoutez une application iOS à votre projet : Suivez l'assistant, téléchargez le fichier `GoogleService-Info.plist` généré, ouvrez `ios/Runner.xcworkspace` avec Xcode, et dans Xcode placez le fichier dans `ios/Runner`. **Ne** suivez pas les étapes intitulées &quot;Add Firebase SDK&quot; et &quot;Add initialization code&quot; dans l'assistant Firebase.

3. Dans Xcode, sélectionnez `Runner` dans le navigateur de projet. Dans l'onglet Capabilities, activez les `Push Notifications` et les `Background Modes`, et activez le `Background Fetch` et les `Remote notifications` sous `Background Modes`.

4. Suivez les étapes dans la section "[Upload your APNs certificate](https://firebase.google.com/docs/cloud-messaging/ios/client#upload_your_apns_certificate)" de la documentation Firebase.

5. Si vous devez désactiver la méthode de swizzling effectué par le SDK iOS FCM (par exemple pour que vous puissiez utiliser ce plugin avec d'autres plugins de notification), ajoutez ce qui suit au fichier `Info.plist` de votre application.

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

Après cela, ajoutez les lignes suivantes dans la `(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` méthode qui se trouve dans `AppDelegate.m`/`AppDelegate.swift` de votre projet IOS.

Objective-C:

```objectivec
if (@available(iOS 10.0, *)) {
  [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
}
```

Swift:

```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```
