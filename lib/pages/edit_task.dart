import 'package:flutter/material.dart';
import 'package:ClassViz/models/Task.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/util/custom_cards.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController nameController;
  late String selectedCategory;
  final categories = [
    "🧠 Academics",
    "💪 Chores",
    "❤️ Socials",
    "🏋️ Physical",
  ];
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
    selectedCategory = widget.task.category ?? "";
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
      'category': selectedCategory,
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 50),
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Edit Task",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TASK NAME",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Task name",
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    final actualValue = category;

                    final selected = selectedCategory == actualValue;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = actualValue;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: selected
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DIFFICULTY",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                difficulty = (index + 1).toDouble();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.star_rounded,
                                size: 28,
                                color: index < difficulty
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TIME INTENSIVENESS",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                timeIntensive = (index + 1).toDouble();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.bolt_rounded,
                                size: 28,
                                color: index < timeIntensive
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDateTile(
                        "Start",
                        selectedDateFrom,
                        fromTime,
                        () => selectDateFrom(context),
                        () => selectTimeFrom(context),
                      ),

                      const SizedBox(height: 16),

                      _buildDateTile(
                        "Due",
                        selectedDateTo,
                        toTime,
                        () => selectDateTo(context),
                        () => selectTimeTo(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: saveEdits,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile(
    String title,
    DateTime? date,
    TimeOfDay? time,
    VoidCallback onDateTap,
    VoidCallback onTimeTap,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onDateTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : "Select Date",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: GestureDetector(
            onTap: onTimeTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                time?.format(context) ?? "Select Time",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
