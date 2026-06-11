import "package:amplify_flutter/amplify_flutter.dart";
import "package:flutter/material.dart";
import "package:ClassViz/util/dialog_box.dart";
import "package:ClassViz/util/custom_cards.dart";

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController dropdownController = TextEditingController();

  final items = ["🧠 Academics", "💪 Chores", "❤️ Socials", "🏋️ Physical"];

  @override
  void dispose() {
    controller.dispose();
    dropdownController.dispose();
    super.dispose();
  }

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
      initialDate: selectedDateTo ?? selectedDateFrom ?? DateTime.now(),
      firstDate: selectedDateFrom ?? DateTime.now(),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      setState(() {
        selectedDateTo = picked;
      });
    }
  }

  Future<void> saveTaskToAPI() async {
    // Validate required fields
    final name = controller.text.trim();
    final category = dropdownController.text.trim();
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

    final start = DateTime(
      selectedDateFrom!.year,
      selectedDateFrom!.month,
      selectedDateFrom!.day,
      fromTime.hour,
      fromTime.minute,
    );

    final end = DateTime(
      selectedDateTo!.year,
      selectedDateTo!.month,
      selectedDateTo!.day,
      toTime.hour,
      toTime.minute,
    );

    // Validate chronology
    if (!end.isAfter(start)) {
      errors.add("End date/time must be after start date/time.");
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$errors")));
    } else {
      final input = {
        'name': controller.text,
        'category': dropdownController.text,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ Failed to save task: ${response.errors.first.message}',
              ),
            ),
          );
        }
      } catch (e) {
        print('Mutation failed: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error saving task: $e')));
      }
    }
  }

  /*Future<void> uploadTaskToS3() async {
    final taskData =
        '''
          Task: ${controller.text}
          Category: ${dropdownController.text}
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Add Task",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Name
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Task Name",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category
              Center(
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: items.map((category) {
                      final selected = dropdownController.text == category;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            dropdownController.text = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: selected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Difficulty",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              difficultyRating = index + 1;
                            });
                          },
                          child: Icon(
                            Icons.star,
                            size: 26,
                            color: index < difficultyRating
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Time Intensity",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              timeRating = index + 1;
                            });
                          },
                          child: Icon(
                            Icons.bolt_rounded,
                            size: 26,
                            color: index < timeRating
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _timeTile(
                      icon: Icons.schedule,
                      label: "From",
                      value: fromTime.format(context),
                      onTap: () => selectTimeFrom(context),
                    ),

                    _timeTile(
                      icon: Icons.flag,
                      label: "To",
                      value: toTime.format(context),
                      onTap: () => selectTimeTo(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _timeTile(
                      icon: Icons.calendar_today,
                      label: "Start Date",
                      value: selectedDateFrom != null
                          ? "${selectedDateFrom!.day}/${selectedDateFrom!.month}/${selectedDateFrom!.year}"
                          : "Select",
                      onTap: () => selectDateFrom(context),
                    ),

                    _timeTile(
                      icon: Icons.event,
                      label: "Due Date",
                      value: selectedDateTo != null
                          ? "${selectedDateTo!.day}/${selectedDateTo!.month}/${selectedDateTo!.year}"
                          : "Select",
                      onTap: () => selectDateTo(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await saveTaskToAPI();
                    if (context.mounted) Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Save Task",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
            const SizedBox(width: 12),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
