import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_todo/ui/notified_page.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

//　initializeTimeZones　を持っている。
import 'package:timezone/data/latest.dart' as tz;
import '../models/task.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    _configureLocalTimezone();
    // this is for latest iOS settings

    //* 初期化時には許可を求めない（ダイアログ出さない）
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  void selectNotification(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => NotifiedPage(label: payload!));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    Get.dialog(const Text('welcome'));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestPermission();
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.note,
        _convertTime(hour, minutes),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" "${task.note}|");

    ///
//             この文章は、特定の日時とタイムゾーンに基づいて通知をスケジュールする方法について説明しています。

// 通知を表示するために、プラグインはプラットフォームチャネルを介して yyyy-mm-dd hh:mm:ss フォーマットで時刻を渡す必要があります。したがって、最高の精度は秒単位です。

// `androidAllowWhileIdle` パラメータは、デバイスが低電力のアイドルモードにある場合でも、通知を正確な時間に表示するかどうかを決定します。このパラメータは非推奨であり、将来のメジャーリリースで削除される予定です。代わりに、同じ機能を提供する `androidScheduledMode` パラメータが使用される予定です。

// `uiLocalNotificationDateInterpretation` は、iOSバージョン10より古いバージョン用で、タイムゾーンのサポートが限られているため、スケジュールされた日時が絶対時間か壁掛け時計の時間かを決定するためのものです。

// `matchDateTimeComponents` パラメータが指定されている場合、特定の日時コンポーネントに一致する再発通知をスケジュールすることを意味します。`DateTimeComponents.time` を指定すると、毎日同じ時間に通知が行われます。一方、`DateTimeComponents.dayOfWeekAndTime` を指定すると、同じ曜日と時間に毎週通知が行われます。これは、iOS/macOSでカレンダートリガーを使用して再発通知をスケジュールする方法に似ています。ただし、このパラメータが指定されている場合、`scheduledDate` が最初の通知が表示される日時を表すわけではないことに注意してください。例えば、現在の日時が 2020-10-19 11:00 であり、`scheduledDate` が 2020-10-21 10:00 で、`matchDateTimeComponents` の値が `DateTimeComponents.time` の場合、次に通知が表示されるのは 2020-10-20 10:00 です。
    ///
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print('now:$now');
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    print('scheduled$scheduleDate');
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  void _configureLocalTimezone() async {
    tz.initializeTimeZones();
    String localTimeZoneName =
        await FlutterTimezone.getLocalTimezone(); // ローカルタイムゾーンの名前を取得

    tz.setLocalLocation(tz.getLocation(localTimeZoneName));
  }
}
