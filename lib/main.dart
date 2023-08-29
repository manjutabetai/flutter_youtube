import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/db/db_helper.dart';
import 'package:flutter_todo/firebase_options.dart';
import 'package:flutter_todo/service/theme_service.dart';
import 'package:flutter_todo/ui/home_page.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message $message");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        home: const MyHomePage());
  }
}
