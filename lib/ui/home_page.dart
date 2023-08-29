import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_todo/controller/task_controller.dart';
import 'package:flutter_todo/service/notification_services.dart';
import 'package:flutter_todo/service/theme_service.dart';
import 'package:flutter_todo/ui/add_task_bar.dart';
import 'package:flutter_todo/ui/description_screen.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:flutter_todo/ui/widget/button.dart';
import 'package:flutter_todo/ui/widget/task_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestAndroidPermissions();
    notifyHelper.requestPermission();
    notifyHelper.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [_addTaskBar(), _addDateBar(), _showTasks()],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];

            if (task.repeat == 'Daily') {
              // print(task.startTime.toString());
              DateTime date =
                  DateFormat("HH:mm").parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              int hour = int.parse(myTime.split(":")[0]);
              int minutes = int.parse(myTime.split(":")[1]);
              notifyHelper.scheduledNotification(hour, minutes, task);

              return Card(
                child: InkWell(
                  onTap: () {
                    Get.to(() => DescriptionPage(task: task));
                  },
                  child: TaskTile(task),
                ),
              );
            } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
    }));
  }

  _buttomSheetButton({
    required String label,
    required Function() onTap,
    required Color clr,
    required BuildContext context,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.sizeOf(context).width * .9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            color: isClose ? Colors.transparent : clr,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.sizeOf(context).height * 0.24
          : MediaQuery.sizeOf(context).height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(children: [
        Container(
          height: 8,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
        ),
        const Spacer(),
        task.isCompleted == 1
            ? Container()
            : _buttomSheetButton(
                label: "Task Completed",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);

                  Get.back();
                },
                clr: bluisClr,
                context: context,
              ),
        const SizedBox(
          height: 20,
        ),
        _buttomSheetButton(
          label: "Delete Task",
          onTap: () {
            _taskController.delete(task);

            Get.back();
          },
          clr: Colors.red[300]!,
          context: context,
        ),
        _buttomSheetButton(
          label: "Close",
          onTap: () {
            Get.back();
          },
          clr: Colors.white,
          context: context,
          isClose: true,
        ),
      ]),
    ));
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        selectionColor: primaryClr,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(
                    DateTime.now(),
                  ),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: '+ Add Tas',
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          NotifyHelper().displayNotification(
              title: 'テーマを変更しました', body: Get.isDarkMode ? "ライトモード" : "ダークモード");
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_rounded,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            notifyHelper.sendPushMessage();
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            child: const CircleAvatar(
              backgroundImage: AssetImage('images/man.png'),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
