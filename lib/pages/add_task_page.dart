import "package:amplify_flutter/amplify_flutter.dart";
import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:ClassViz/util/dialog_box.dart";
import "package:ClassViz/util/my_button.dart";

class AddTaskPage extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController dropdownController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddTaskPage({
    super.key,
    required this.controller,
    required this.dropdownController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final items = ["🧠 Academics", "💪 Chores", "❤️ Socials", "🏋️ Physical"];

  TimeOfDay fromTime = TimeOfDay.now();
  Future<void> selectTimeFrom(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime,
    );

    if (picked != null) {
      setState(() {
        fromTime = picked;
      });
    }
  }

  TimeOfDay toTime = TimeOfDay.now();
  Future<void> selectTimeTo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: toTime,
    );

    if (picked != null) {
      setState(() {
        toTime = picked;
      });
    }
  }

  DateTime? selectedDateFrom;
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

  DateTime? selectedDateTo;
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

  Future<void> saveTaskToAPI() async {
    //local helper to convert TimeOfDay to minutes since midnight
    int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

    // Validate required fields
    final name = widget.controller.text.trim();
    final category = widget.dropdownController.text.trim();
    final diff = difficultyRating.toInt();
    final timeInt = timeRating.toInt();

    final List<String> errors = [];

    if (name.isEmpty) errors.add("Task name is required.");
    if (category.isEmpty) errors.add("Category is required.");
    if (diff < 1) errors.add("Please select a difficulty (at least 1).");
    if (timeInt < 1) errors.add("Please select time intensity (at least 1).");

    // Set both dates to today if not selected
    if (selectedDateFrom == null || selectedDateTo == null) {
      setState(() {
        selectedDateFrom = DateTime.now();
        selectedDateTo = DateTime.now();
      });
    }

    // If dates provided, validate ordering
    if (_toMinutes(fromTime) >= _toMinutes(toTime)) {
      errors.add("From time must be before To time.");
    }

    if (errors.isNotEmpty) {
      dialogBox("$errors", context);
      print(errors);
    } else {
      final input = {
        'name': widget.controller.text,
        'category': widget.dropdownController.text,
        'difficulty': difficultyRating.toInt(),
        'timeIntensive': timeRating.toInt(),
        'fromTime': fromTime.format(context),
        'toTime': toTime.format(context),
        'fromDate': selectedDateFrom?.toIso8601String().split('T')[0],
        'toDate': selectedDateTo?.toIso8601String().split('T')[0],
        'createdAt': TemporalDateTime.now().format(),
        'completed': false,
      };

      final request = GraphQLRequest<String>(
        document: '''
        mutation CreateTask(\$input: CreateTaskInput!) {
          createTask(input: \$input) {
            id
            name
          }
        }
      ''',
        variables: {'input': input},
        authorizationMode: APIAuthorizationType.userPools,
      );

      try {
        final response = await Amplify.API.mutate(request: request).response;

        if (response.errors.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Task has been saved')));
        } else {
          print('GraphQL errors: ${response.errors}');
          dialogBox(
            '❌ Failed to save task: ${response.errors.first.message}',
            context,
          );
        }
      } catch (e) {
        print('Mutation failed: $e');
        dialogBox('❌ Error saving task: $e', context);
      }
    }
  }

  /*Future<void> uploadTaskToS3() async {
    final taskData =
        '''
          Task: ${widget.controller.text}
          Category: ${widget.dropdownController.text}
          Difficulty: $difficultyRating
          Time Intensive: $timeRating
          From Date: ${selectedDateFrom?.toIso8601String() ?? 'Not selected'}
          From Time: ${fromTime.format(context)}
          To Date: ${selectedDateTo?.toIso8601String() ?? 'Not selected'}
          To Time: ${toTime.format(context)}
        ''';

    final dataBytes = utf8.encode(taskData);

    try {
      final result = Amplify.Storage.uploadData(
        path: StoragePath.fromString(
          "tasks/task_${DateTime.now().millisecondsSinceEpoch}.txt",
        ),
        data: S3DataPayload.bytes(dataBytes),
      );

      dialogBox('✅ Task uploaded with key: $result', context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task uploaded to cloud!')));
    } catch (e) {
      dialogBox('❌ Upload failed: $e', context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed')));
    }
  }*/

  double difficultyRating = 0;
  double timeRating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      content: SizedBox(
        height: MediaQuery.of(context).size.height - 40,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add A Task",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "UA",
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 190),
              child: IntrinsicWidth(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Task Name",
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 20),

            DropdownMenu(
              width: 210,
              controller: widget.dropdownController,
              dropdownMenuEntries: items.map((String items) {
                return DropdownMenuEntry(value: items, label: items);
              }).toList(),
              textStyle: TextStyle(
                fontFamily: "Orbitron",
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Difficulty: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                RatingBar.builder(
                  initialRating: difficultyRating,
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
                  itemSize: 20,
                  onRatingUpdate: (rating) {
                    setState(() {
                      difficultyRating = rating;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Time Intensive: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                RatingBar.builder(
                  initialRating: timeRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  unratedColor: Colors.white,
                  itemSize: 20,
                  onRatingUpdate: (rating) {
                    setState(() {
                      timeRating = rating;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20.0,
              ),

              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("From:"),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              selectTimeFrom(context);
                            },
                            child: Text(
                              fromTime.format(context),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          selectDateFrom(context);
                        },
                        child: Text(
                          selectedDateFrom != null
                              ? "${selectedDateFrom!.day}/${selectedDateFrom!.month}/${selectedDateFrom!.year}"
                              : DateTime.now().toString().substring(0, 10),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("To:"),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              selectTimeTo(context);
                            },
                            child: Text(
                              toTime.format(context),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          selectDateTo(context);
                        },
                        child: Text(
                          selectedDateTo != null
                              ? "${selectedDateTo!.day}/${selectedDateTo!.month}/${selectedDateTo!.year}"
                              : DateTime.now().toString().substring(0, 10),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Material(
              textStyle: TextStyle(color: Theme.of(context).primaryColorLight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    text: "Save",
                    onPressed: () async {
                      await saveTaskToAPI();
                      widget.onSave();
                      Navigator.of(context).pop();
                    },
                  ),

                  const SizedBox(width: 8),

                  MyButton(text: "Cancel", onPressed: widget.onCancel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
