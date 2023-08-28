import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            label.split("|")[0],
            style: titleStyle,
          ),
          backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          )),
      body: Container(
        child: Center(
          child: Text(
            label.split("|")[1],
            style: subTitleStyle,
          ),
        ),
      ),
    );
  }
}
