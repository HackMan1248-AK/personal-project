import 'package:flutter/material.dart';
import 'package:ClassViz/models/Task.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  double difficulty = 1;
  double timeIntensive = 1;

  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  DateTime? selectedDateFrom;
  DateTime? selectedDateTo;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.name);
    categoryController = TextEditingController(
      text: widget.task.category ?? '',
    );
    difficulty = (widget.task.difficulty ?? 1).toDouble();
    timeIntensive = (widget.task.timeIntensive ?? 1).toDouble();

    // Parse times and dates from the task
    fromTime = widget.task.fromTime != null
        ? _parseTimeOfDay(widget.task.fromTime!)
        : TimeOfDay.now();
    toTime = widget.task.toTime != null
        ? _parseTimeOfDay(widget.task.toTime!)
        : TimeOfDay.now();
    selectedDateFrom = widget.task.fromDate?.getDateTime();
    selectedDateTo = widget.task.toDate?.getDateTime();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTimeOfDay(String time) {
    // Handles both "HH:mm" and "h:mm a" formats
    try {
      if (time.contains('AM') || time.contains('PM')) {
        // 12-hour format with AM/PM, e.g. "2:30 PM"
        final timeParts = time.split(' ');
        final hourMinute = timeParts[0].split(':');
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);
        final period = timeParts[1].toUpperCase();
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        // 24-hour format
        final parts = time.split(":");
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      // Fallback to now if parsing fails
      return TimeOfDay.now();
    }
  }

  Future<void> selectTimeFrom(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        fromTime = picked;
      });
    }
  }

  Future<void> selectTimeTo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: toTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        toTime = picked;
      });
    }
  }

  Future<void> selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDateFrom) {
      setState(() {
        selectedDateFrom = picked;
      });
    }
  }

  Future<void> selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTo ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;
      });
    }
  }

  void saveEdits() async {
    final input = {
      'id': widget.task.id,
      'name': nameController.text,
      'category': categoryController.text,
      'difficulty': difficulty.toInt(),
      'timeIntensive': timeIntensive.toInt(),
      'fromTime': fromTime?.format(context),
      'toTime': toTime?.format(context),
      'fromDate': selectedDateFrom?.toIso8601String().split('T')[0],
      'toDate': selectedDateTo?.toIso8601String().split('T')[0],
      '_version': widget.task.version, // Use _version for conflict resolution
    };

    final request = GraphQLRequest<String>(
      document: '''
      mutation UpdateTask(\$input: UpdateTaskInput!) {
        updateTask(input: \$input) {
          id
          name
        }
      }
    ''',
      variables: {'input': input},
      authorizationMode: APIAuthorizationType.apiKey,
    );

    try {
      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task updated!')));
        Navigator.of(context).pop(true); // Return true to refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed: ${response.errors.first.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('Difficulty:', style: TextStyle(color: Colors.white)),
            RatingBar.builder(
              initialRating: difficulty,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.primary,
              ),
              unratedColor: Colors.white,
              itemSize: 24,
              onRatingUpdate: (rating) {
                setState(() {
                  difficulty = rating;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Time Intensive:', style: TextStyle(color: Colors.white)),
            RatingBar.builder(
              initialRating: timeIntensive,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.access_time,
                color: Theme.of(context).colorScheme.primary,
              ),
              itemSize: 24,
              onRatingUpdate: (rating) {
                setState(() {
                  timeIntensive = rating;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("From:", style: TextStyle(color: Colors.white)),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => selectTimeFrom(context),
                  child: Text(
                    fromTime != null ? fromTime!.format(context) : "No time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => selectDateFrom(context),
              child: Text(
                selectedDateFrom != null
                    ? "${selectedDateFrom!.day}/${selectedDateFrom!.month}/${selectedDateFrom!.year}"
                    : "No Date Selected",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("To:", style: TextStyle(color: Colors.white)),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => selectTimeTo(context),
                  child: Text(
                    toTime != null ? toTime!.format(context) : "No time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => selectDateTo(context),
              child: Text(
                selectedDateTo != null
                    ? "${selectedDateTo!.day}/${selectedDateTo!.month}/${selectedDateTo!.year}"
                    : "No date selected",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveEdits,
              child: Text('Save Changes', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
