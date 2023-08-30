import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task?.title ?? "",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey[200],
                    size: 18,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${task!.startTime} - ${task!.endTime}",
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 12, color: Colors.grey[100])),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                task?.note ?? "",
                style: GoogleFonts.lato(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey)),
              )
            ],
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          )
        ]),
      ),
    );
  }

  Color _getBGClr(int no) {
    Color result;
    switch (no) {
      case 0:
        result = bluisClr;
      case 1:
        result = pinkClr;
      case 2:
        result = yellowClr;
      default:
        result = bluisClr;
    }
    return result;
  }
}

// String switchCase(String value) {
//   String result;
//   switch (value) {
//     case 'a':
//       result = 'aa';
//     case 'b' || 'c':
//       result = 'bb';
//     default:
//       result = 'zz';
//   }
//   return result;
// }
