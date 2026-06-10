import "package:flutter/material.dart";
import "package:ClassViz/util/custom_bottom_nav.dart";
import 'package:ClassViz/pages/subject_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/models/Subject.dart';
import "package:ClassViz/util/custom_cards.dart";

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Subject> _subjects = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndSubjects();
  }

  Future<void> _loadUserAndSubjects() async {
    final user = await Amplify.Auth.getCurrentUser();
    setState(() {
      _userId = user.userId;
    });
    final subjects = await Amplify.DataStore.query(
      Subject.classType,
      where: Subject.USERID.eq(_userId),
    );
    setState(() {
      _subjects = subjects;
    });
  }

  void _addSubject() async {
    String temp = "";
    String? newSubject = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Subject", style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Subject name"),
            style: TextStyle(color: Colors.white),
            onChanged: (value) => temp = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, temp),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
    if (newSubject != null && newSubject.trim().isNotEmpty && _userId != null) {
      // Assign a default color if needed
      final colorString = Colors
          .primaries[_subjects.length % Colors.primaries.length]
          .value
          .toString();
      final subject = Subject(
        name: newSubject.trim(),
        userID: _userId!,
        color: colorString,
      );
      await Amplify.DataStore.save(subject);
      _loadUserAndSubjects();
    }
  }

  void _deleteSubject(int index) async {
    await Amplify.DataStore.delete(_subjects[index]);
    _loadUserAndSubjects();
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return Colors.blue[100]!;
    try {
      return Color(int.parse(colorString));
    } catch (_) {
      return Colors.blue[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subjects & projects',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tomes',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: _addSubject,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: _subjects.isEmpty
                        ? Center(
                            child: Text(
                              "No tomes yet!",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              itemCount: _subjects.length + 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                if (index == _subjects.length) {
                                  return GestureDetector(
                                    onTap: _addSubject,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[800]!,
                                          width: 2,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 32,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'New tome',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final subject = _subjects[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubjectPage(
                                          subjectId: subject.id,
                                          subjectName: subject.name,
                                          subjectColor: subject.color,
                                        ),
                                      ),
                                    );
                                  },
                                  child: TomeCard(
                                    title: subject.name,
                                    topicCount: 0,
                                    backgroundColor: _parseColor(subject.color),
                                    onDelete: () => _deleteSubject(index),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
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
                currentIndex: 3,
                onTap: (index) {
                  if (index == 0) Navigator.pushNamed(context, "/homepage");
                  if (index == 1) Navigator.pushNamed(context, "/taskspage");
                  if (index == 2) _addSubject();
                  if (index == 4) Navigator.pushNamed(context, "/profilepage");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
