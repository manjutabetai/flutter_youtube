import 'package:flutter/material.dart';
import 'package:flutter_todo/service/notification_services.dart';
import 'package:flutter_todo/service/theme_service.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestAndroidPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const Column(
        children: [
          Text(
            'Theme Data',
            style: TextStyle(
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          NotifyHelper().displayNotification(
              title: 'テーマを変更しました', body: Get.isDarkMode ? "ライトモード" : "ダークモード");
          NotifyHelper().scheduledNotification();
        },
        child: const Icon(
          Icons.nightlight_rounded,
          size: 20,
        ),
      ),
      actions: const [
        Icon(
          Icons.person,
          size: 20,
        )
      ],
    );
  }
}
