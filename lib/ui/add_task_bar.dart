import 'package:flutter/material.dart';
import 'package:flutter_todo/controller/task_controller.dart';
import 'package:flutter_todo/models/task.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:flutter_todo/ui/widget/button.dart';
import 'package:flutter_todo/ui/widget/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 6;
  String _selectedRepeat = 'None';

  final List<int> _remindList = [5, 10, 15, 20];
  final List<String> _repeatList = ["None", "Daily", "Week", "Monthly"];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    print(_startTime);
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              // title
              MyInputField(
                title: 'Title',
                hint: 'add your title',
                controller: _titleController,
              ),
              // Note
              MyInputField(
                title: 'Note',
                hint: 'enter note here',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDataFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      icon: const Icon(Icons.access_time_rounded),
                      onPressed: () {
                        _getTimeFromUser(isStart: true);
                      },
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      icon: const Icon(Icons.access_time_rounded),
                      onPressed: () {
                        _getTimeFromUser(isStart: false);
                      },
                    ),
                  ))
                ],
              ),
              // Remind
              MyInputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: _remindList.map<DropdownMenuItem<String>>((int e) {
                    return DropdownMenuItem(
                        value: e.toString(), child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              // Repeat
              MyInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: _repeatList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),

              // Color
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPallet(),
                    MyButton(label: "Add Task", onTap: () => _validateDate()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();

      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "Al fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDB() async {
    Task task = Task(
      color: _selectedColor,
      date: DateFormat.yMd().format(_selectedDate),
      endTime: _endTime,
      startTime: _startTime,
      note: _noteController.text,
      title: _titleController.text,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      isCompleted: 0,
    );
    int id = await _taskController.addTask(task: task);
  }

  Column _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : Container()),
              ),
            );
          }),
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(4),
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/man.png'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _getDataFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2024));
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {}
  }

  _getTimeFromUser({required bool isStart}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime != null) {
      String time = formatTime(pickedTime);
      if (pickedTime == null) {
      } else if (isStart) {
        setState(() {
          _startTime = time;
        });
      } else if (!isStart) {
        setState(() {
          _endTime = time;
        });
      }
    }
  }

  String formatTime(pickedTime) {
    String formatTime = pickedTime.format(context);
    return formatTime;
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}
