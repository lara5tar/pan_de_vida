import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'core/values/keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init(Keys.LOGIN_KEY);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      color: Colors.blue,
      // defaultTransition: Transition.,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Agregar este delegado
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

// class NotificationController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeNotifications();
//     _requestNotificationPermissions();
//   }

//   void _initializeNotifications() {
//     AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Notificaciones Básicas',
//           channelDescription: 'Canal para notificaciones básicas',
//           defaultColor: const Color(0xFF9D50DD),
//           ledColor: Colors.white,
//         ),
//       ],
//     );
//   }

//   void _requestNotificationPermissions() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//   }

//   void sendNotification() {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'basic_channel',
//         title: '¡Hola!',
//         body: 'Esta es una notificación local de prueba.',
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final NotificationController notificationController =
//       Get.put(NotificationController());

//   HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notificaciones con GetX'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             notificationController.sendNotification();
//           },
//           child: const Text('Enviar Notificación'),
//         ),
//       ),
//     );
//   }
// }
