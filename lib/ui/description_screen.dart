import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/widget/task_tile.dart';

import '../models/task.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(cardContent.title),
        backgroundColor: Colors.white.withOpacity(0),
      ),
      body: Center(
        child: Hero(
          tag: task.id.toString(),
          child: TaskTile(task),
        ),
      ),
    );
  }
}
