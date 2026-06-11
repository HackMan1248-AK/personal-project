import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:ClassViz/pages/add_task_page.dart';
import 'package:intl/intl.dart';
import "package:flutter/material.dart";
import "package:ClassViz/models/Task.dart";
import "package:ClassViz/util/misc.dart";
import "package:ClassViz/util/progress_indicators.dart";
import "package:ClassViz/util/custom_bottom_nav.dart";
import "package:ClassViz/util/custom_cards.dart";
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/models/ModelProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Task> tasks = [];
  bool isLoading = false;
  int coins = 0;

  double? knowledge;
  double? charisma;
  double? strength;
  double? persistence;

  double level = 0.00;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchTasks();
    fetchLevels();
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchLevels();
      fetchTasks();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchLevels();
      fetchTasks();
    }
  }

  double findDecimal(double val) {
    double levelDecimal = val;
    while (levelDecimal > 1) {
      levelDecimal--;
    }
    return levelDecimal;
  }

  Future<void> fetchLevels() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final sub = attributes
        .firstWhere((a) => a.userAttributeKey.key == 'sub')
        .value;
    try {
      final request = GraphQLRequest<String>(
        document: '''query listUsers {
        listUsers {
          items {
            id
            knowledge
            charisma
            strength
            persistence
            level
            _version
          }
        }
      }''',
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        final Map<String, dynamic> decoded = jsonDecode(response.data!);
        final List items = decoded['listUsers']['items'];
        for (var item in items) {
          if (item["id"] == sub) {
            final listOf = [
              item["knowledge"],
              item["charisma"],
              item["persistence"],
              item["strength"],
            ];
            double sum = 0.00;
            for (var x in listOf) {
              sum += x;
            }
            sum /= 4;
            setState(() {
              knowledge = listOf[0] * 100;
              charisma = listOf[1] * 100;
              persistence = listOf[2] * 100;
              strength = listOf[3] * 100;
              level = sum;
            });

            // Update the level in the listUsers table
            final updateRequest = GraphQLRequest<String>(
              document: '''
                mutation UpdateUser(\$input: UpdateUserInput!) {
                  updateUser(input: \$input) {
                    id
                    level
                  }
                }
              ''',
              variables: {
                "input": {
                  "id": item["id"],
                  "level": sum,
                  "_version": item["_version"],
                },
              },
            );
            await Amplify.API.mutate(request: updateRequest).response;
          }
        }
      } else {
        setState(() {
          tasks = [];
        });
      }

      if (response.hasErrors) {
        print(response.errors);
      }
    } catch (e) {
      print(e.toString());
    }
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
              completed
              createdAt
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
            .where((task) => task.completed != true)
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
      //setState(() => isLoading = false);
      print("Failed to fetch tasks: ${e.toString()}");
    }
  }

  double getPriority(Task task) {
    final now = DateTime.now();
    final difficulty = (task.difficulty ?? 1).toDouble();
    final timeIntensive = (task.timeIntensive ?? 1).toDouble();
    final due = Misc().parseDueDateTime(
      task.toDate?.getDateTime(),
      task.toTime,
    );
    final timeLeft = due.difference(now).inSeconds;
    if (timeLeft <= 0) return -1;
    return (difficulty * timeIntensive) / timeLeft;
  }

  Task? getMostImportantTask(List<Task> tasks) {
    if (tasks.isEmpty) return null;
    final sorted = List<Task>.from(tasks);
    sorted.sort((a, b) => getPriority(b).compareTo(getPriority(a)));
    for (final task in sorted) {
      if (getPriority(task) > 0) return task;
    }
    return null;
  }

  Task? getUpcomingTask(List<Task> tasks) {
    if (tasks.isEmpty) return null;

    final now = DateTime.now();
    Task? highestPriorityTask;
    double highestPriority = double.infinity;

    for (final task in tasks) {
      if (task.toDate == null || task.toTime == null) continue;
      final timeRegExp = RegExp(r'^(\d{1,2}):(\d{2})\s*([AP]M)$');
      final match = timeRegExp.firstMatch(task.toTime!);
      if (match == null) continue;

      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final dueDate = task.toDate!.getDateTime().add(
        Duration(hours: hour, minutes: minute),
      );
      if (dueDate.isBefore(now)) continue;

      final secondsToDue = dueDate.difference(now).inSeconds.toDouble();
      if (secondsToDue <= 0) continue;

      if (secondsToDue < highestPriority) {
        highestPriority = secondsToDue;
        highestPriorityTask = task;
      }
    }

    return highestPriorityTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Color.fromARGB(100, 54, 228, 170),
                      // // Color.fromARGB(255, 255, 255, 255),
                      // Color(0xFF141032),
                      Colors.black,
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 28),
                          FutureBuilder<AuthUser>(
                            future: Amplify.Auth.getCurrentUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return FutureBuilder<List<AuthUserAttribute>>(
                                  future: Amplify.Auth.fetchUserAttributes(),
                                  builder: (context, attrSnapshot) {
                                    if (attrSnapshot.hasData) {
                                      final name = attrSnapshot.data!
                                          .firstWhere(
                                            (attr) =>
                                                attr.userAttributeKey.key ==
                                                'name',
                                            orElse: () =>
                                                const AuthUserAttribute(
                                                  userAttributeKey:
                                                      CognitoUserAttributeKey
                                                          .name,
                                                  value: 'User',
                                                ),
                                          )
                                          .value;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: XPProgressBar(
                                          current:
                                              (level * 1000).toInt() % 1000,
                                          total: 1000,
                                          label: name,
                                        ),
                                      );
                                    }
                                    return Text('Hello');
                                  },
                                );
                              }
                              return Text('Hello');
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    // Today's Focus Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Focus",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    isLoading
                        ? Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          )
                        : _buildFocusTaskCard(getMostImportantTask(tasks)),
                    SizedBox(height: 28),
                    // Attributes Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Attributes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          AttributeCard(
                            label: 'Academics',
                            value: (knowledge ?? 0).toInt(),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          AttributeCard(
                            label: 'Physical',
                            value: (strength ?? 0).toInt(),
                            color: const Color.fromARGB(255, 76, 175, 80),
                          ),
                          const SizedBox(height: 12),
                          AttributeCard(
                            label: 'Socials',
                            value: (charisma ?? 0).toInt(),
                            color: const Color.fromARGB(255, 244, 67, 54),
                          ),
                          const SizedBox(height: 12),
                          AttributeCard(
                            label: 'Chores',
                            value: (persistence ?? 0).toInt(),
                            color: const Color.fromARGB(255, 255, 152, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    // Up Next Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Up Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/taskspage"),
                            child: Text(
                              'See All >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    ...tasks
                        .take(3)
                        .map((task) => _buildUpcomingTaskCard(task)),
                    SizedBox(height: 20),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: CustomBottomNav(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 1) {
                    Navigator.pushNamed(context, "/taskspage");
                  }
                  if (index == 2) {
                    _showAddTaskModal(context);
                  }
                  if (index == 3) {
                    Navigator.pushNamed(context, "/projectspage");
                  }
                  if (index == 4) {
                    Navigator.pushNamed(context, "/profilepage");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusTaskCard(Task? task) {
    if (task == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Text(
                'No focus tasks right now!',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getCategoryLabel(task.category),
            style: TextStyle(
              fontSize: 11,
              color: _getCategoryColor(task.category),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            task.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(
                _getCategoryColor(task.category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTaskCard(Task task) {
    final color = _getCategoryColor(task.category);

    return QuestCard(
      title: task.name,
      category: _getCategoryLabel(task.category),
      timeRange: '${task.fromTime ?? 'N/A'} - ${task.toTime ?? 'N/A'}',
      difficulty: task.difficulty ?? 1,
      intensity: task.timeIntensive ?? 1,
      progress: 0,
      total: 100,
      categoryColor: color,
      borderColor: color,
      completed: task.completed,
    );
  }

  String _getGreeting() {
    return DateFormat('EEEE, MMM d').format(DateTime.now());
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
    showDialog(context: context, builder: (context) => AddTaskPage());
  }
}