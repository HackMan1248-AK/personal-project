import 'dart:convert';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/models/Task.dart';
import 'package:ClassViz/pages/edit_task.dart';
import 'package:ClassViz/util/custom_bottom_nav.dart';
import 'package:ClassViz/util/custom_cards.dart';
import 'package:ClassViz/util/misc.dart';
import 'package:ClassViz/models/ModelProvider.dart';
import 'package:ClassViz/util/dialog_box.dart';
import 'package:ClassViz/pages/home_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];
  bool isLoading = false;
  Timer? _refreshTimer;
  bool showCompleted = false;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchTasks();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTasks() async {
    setState(() => isLoading = true);
    try {
      final request = GraphQLRequest<String>(
        document: '''query ListTasks {
        listTasks(filter: {_deleted: {ne: true } }) {
          items {
            id
            name
            category
            difficulty
            timeIntensive
            fromTime
            toTime
            fromDate
            toDate
            createdAt
            completed
            _version
          }
        }
      }''',
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) print(response.errors);
      if (response.data != null) {
        final Map<String, dynamic> decoded = jsonDecode(response.data!);
        final List items = decoded['listTasks']['items'];
        final fetchedTasks = items
            .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        setState(() {
          tasks = fetchedTasks;
          isLoading = false;
        });
      } else {
        setState(() {
          tasks = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      dialogBox("Failed to fetch tasks: ${e.toString()}", context);
      print(e.toString());
    }
  }

  Future<void> deleteTask(String id, int version) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
        mutation DeleteTask(\$id: ID!, \$version: Int!) {
          deleteTask(input: { id: \$id, _version: \$version }) {
            id
            _deleted
            _version
          }
        }
      ''',
        variables: {'id': id, 'version': version},
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.errors.isNotEmpty) {
        dialogBox("Delete failed: ${response.errors}", context);
      }
      if (response.data != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task has been deleted')));
        await fetchTasks();
      } else {
        dialogBox("Delete failed: No response from backend.", context);
      }
    } catch (e) {
      dialogBox("Failed to delete task: ${e.toString()}", context);
      print(e.toString());
    }
  }

  Future<void> updateTaskCompletion(Task task, bool completed) async {
    try {
      final rawCategory = task.category ?? '';
      var category = rawCategory
          .replaceAll(RegExp(r'^[^\w]+'), '')
          .trim()
          .toLowerCase();

      switch (category) {
        case "academics":
          category = "knowledge";
          break;
        case "chores":
          category = "persistence";
          break;
        case "socials":
          category = "charisma";
          break;
        case "physical":
          category = "strength";
          break;
      }

      final sum =
          Misc().taskFormula(task.difficulty ?? 1, task.timeIntensive ?? 1) /
          100;

      final attributes = await Amplify.Auth.fetchUserAttributes();
      final sub = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'sub')
          .value;

      // Step 1: Fetch current stat value and _version
      final getUserResponse = await Amplify.API
          .query(
            request: GraphQLRequest<String>(
              document:
                  '''
          query GetUser(\$id: ID!) {
            getUser(id: \$id) {
              id
              $category
              _version
            }
          }
        ''',
              variables: {'id': sub},
            ),
          )
          .response;

      final data = jsonDecode(getUserResponse.data!)['getUser'];
      if (data == null) {
        print("❌ User not found.");
        return;
      }

      final currentValue = (data[category] ?? 0) as num;
      final currentVersion = data['_version'];

      // Step 2: Apply addition or subtraction
      num newValue = completed ? currentValue + sum : currentValue - sum;

      if (newValue < 0) newValue = 0;

      // Step 3: Build mutation input
      final input = {'id': sub, '_version': currentVersion, category: newValue};

      // Step 4: Send update mutation
      final updateResponse = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document:
                  '''
          mutation UpdateUser(\$input: UpdateUserInput!) {
            updateUser(input: \$input) {
              id
              $category
              _version
            }
          }
        ''',
              variables: {'input': input},
            ),
          )
          .response;

      if (updateResponse.errors.isNotEmpty) {
        print("❌ Error: ${updateResponse.errors}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }

    try {
      final request = GraphQLRequest<String>(
        document: '''
        mutation UpdateTask(\$input: UpdateTaskInput!) {
          updateTask(input: \$input) {
            id
            completed
            _version
          }
        }
      ''',
        variables: {
          "input": {
            "id": task.id,
            "completed": completed,
            "_version": task.version,
          },
        },
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.errors.isNotEmpty) {
        dialogBox("Failed to update the task: ${response.errors}", context);
        print(response.errors);
      }
      if (response.data != null) {
        await fetchTasks();
      }
    } catch (e) {
      dialogBox("Failed to update task: ${e.toString()}", context);
      print(e.toString());
    }
  }

  // String _formatDuration(Duration d) {
  //   if (d.inDays > 0) return "${d.inDays}d ${d.inHours % 24}h";
  //   if (d.inHours > 0) return "${d.inHours}h ${d.inMinutes % 60}m";
  //   if (d.inMinutes > 0) return "${d.inMinutes}m";
  //   return "${d.inSeconds}s";
  // }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    double getPriority(Task task) {
      final difficulty = (task.difficulty ?? 1).toDouble();
      final timeIntensive = (task.timeIntensive ?? 1).toDouble();
      final due = task.toDate?.getDateTime() ?? DateTime(2100);
      final timeLeft = due.difference(now).inSeconds;
      if (timeLeft <= 0) return -1;
      return (difficulty * timeIntensive) / timeLeft;
    }

    tasks.sort((a, b) {
      final timeRegExp = RegExp(r'^(\d{1,2}):(\d{2})\s*([AP]M)$');
      RegExpMatch? match = timeRegExp.firstMatch(a.toTime!);

      int hour = 0;
      int minute = 0;
      String period = 'AM';

      if (match != null) {
        hour = int.parse(match.group(1)!);
        minute = int.parse(match.group(2)!);
        period = match.group(3)!;
      }

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final aDue = a.toDate!.getDateTime().add(
        Duration(hours: hour, minutes: minute),
      );
      match = timeRegExp.firstMatch(b.toTime!);

      hour = 0;
      minute = 0;
      period = 'AM';

      if (match != null) {
        hour = int.parse(match.group(1)!);
        minute = int.parse(match.group(2)!);
        period = match.group(3)!;
      }

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      final bDue = b.toDate?.getDateTime() ?? DateTime(2100);

      final aOverdue = aDue.isBefore(now);
      final bOverdue = bDue.isBefore(now);

      if (aOverdue && !bOverdue) return 1;
      if (!aOverdue && bOverdue) return -1;
      if (aOverdue && bOverdue) {
        return aDue.compareTo(bDue);
      }

      final aPriority = getPriority(a);
      final bPriority = getPriority(b);
      return bPriority.compareTo(aPriority);
    });

    final displayedTasks = tasks.where((task) {
      if (showCompleted) {
        return task.completed == true;
      }
      return task.completed != true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/homepage"),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'All Quests',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showCompleted = !showCompleted;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: showCompleted
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: showCompleted
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 0.4)
                                  : Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                size: 18,
                                color: showCompleted
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                showCompleted ? "Completed" : "Active",
                                style: TextStyle(
                                  color: showCompleted
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Sorted by priority',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 12),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : displayedTasks.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 24),
                          Center(
                            child: Text(
                              "No quests yet!",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: displayedTasks.length,
                          itemBuilder: (context, index) {
                            final task = displayedTasks[index];
                            return QuestCard(
                              title: task.name,
                              category: _getCategoryLabel(task.category),
                              timeRange:
                                  '${task.fromTime ?? 'N/A'} - ${task.toTime ?? 'N/A'}',
                              difficulty: task.difficulty ?? 1,
                              intensity: task.timeIntensive ?? 1,
                              progress: 0,
                              total: 100,
                              categoryColor: _getCategoryColor(task.category),
                              borderColor: _getCategoryColor(task.category),
                              completed: task.completed,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskPage(task: task),
                                  ),
                                );

                                fetchTasks();
                              },

                              onComplete: () {
                                updateTaskCompletion(task, !(task.completed));
                              },
                              onDelete: () => deleteTask(task.id, task.version),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: CustomBottomNav(
                currentIndex: 1,
                onTap: (index) {
                  if (index == 0) Navigator.pushNamed(context, "/homepage");
                  if (index == 2) _showAddTaskModal(context);
                  if (index == 3) Navigator.pushNamed(context, "/projectspage");
                  if (index == 4) Navigator.pushNamed(context, "/profilepage");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String? category) {
    switch (category?.toLowerCase()) {
      case 'academics':
        return 'ACADEMICS';
      case 'chores':
        return 'CHORES';
      case 'socials':
        return 'SOCIALS';
      case 'physical':
        return 'PHYSICAL';
      default:
        return category?.toUpperCase() ?? 'TASK';
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'academics':
        return Theme.of(context).colorScheme.primary;
      case 'chores':
        return Color.fromARGB(255, 255, 152, 0);
      case 'socials':
        return Color.fromARGB(255, 244, 67, 54);
      case 'physical':
        return Color.fromARGB(255, 76, 175, 80);
      default:
        return Colors.grey;
    }
  }

  void _showAddTaskModal(BuildContext context) {
    showDialog(context: context, builder: (context) => AddTaskModal());
  }
}
