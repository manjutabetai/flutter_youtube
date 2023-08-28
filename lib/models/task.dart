class Task {
  int? id;
  String? note;
  String? title;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.color,
    this.date,
    this.endTime,
    this.id,
    this.isCompleted,
    this.note,
    this.remind,
    this.repeat,
    this.startTime,
    this.title,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    title = json['title'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    remind = json['remind'];
    endTime = json['endTime'];
    color = json['color'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'title': title,
        'isCompleted': isCompleted,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'color': color,
        'remind': remind,
        'repeat': repeat,
      };
}
