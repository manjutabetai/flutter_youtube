import 'package:flutter/material.dart';
import 'package:flutter_todo/db/db_helper.dart';
import 'package:flutter_todo/service/theme_service.dart';
import 'package:flutter_todo/ui/home_page.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
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
