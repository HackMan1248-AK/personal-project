import 'package:amplify_flutter/amplify_flutter.dart';

class Task {
  final String name;
  final String category;
  final double difficulty;
  final double timeIntensity;
  final String fromDate;
  final String fromTime;
  final String toDate;
  final String toTime;
  final TemporalDateTime createdAt;

  Task({
    required this.name,
    required this.category,
    required this.difficulty,
    required this.timeIntensity,
    required this.fromDate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.createdAt,
  });

  factory Task.fromTextFile(String content) {
    final lines = content.split('\n');
    String getValue(String label) => lines
        .firstWhere(
          (line) => line.trim().startsWith(label),
          orElse: () => "$label Not set",
        )
        .split(": ")
        .last
        .trim();

    return Task(
      name: getValue("Task"),
      category: getValue("Category"),
      difficulty: double.tryParse(getValue("Difficulty")) ?? 0,
      timeIntensity: double.tryParse(getValue("Time Intensive")) ?? 0,
      fromDate: getValue("From Date"),
      fromTime: getValue("From Time"),
      toDate: getValue("To Date"),
      toTime: getValue("To Time"),
      createdAt: TemporalDateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "category": category,
    "difficulty": difficulty,
    "timeIntensity": timeIntensity,
    "fromDate": fromDate,
    "fromTime": fromTime,
    "toDate": toDate,
    "toTime": toTime,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    name: json["name"],
    category: json["category"],
    difficulty: json["difficulty"],
    timeIntensity: json["timeIntensity"],
    fromDate: json["fromDate"],
    fromTime: json["fromTime"],
    toDate: json["toDate"],
    toTime: json["toTime"],
    createdAt: TemporalDateTime.now(),
  );
}
