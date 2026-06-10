import "package:flutter/material.dart";
import "package:ClassViz/util/bottom_app_bar.dart";
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/models/Topic.dart';
import "package:ClassViz/pages/chat_page.dart";
import "package:ClassViz/util/custom_cards.dart";

class SubjectPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String? subjectColor;
  const SubjectPage({
    super.key,
    required this.subjectName,
    required this.subjectId,
    required this.subjectColor,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Topic> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await Amplify.DataStore.query(
      Topic.classType,
      where: Topic.SUBJECTID.eq(widget.subjectId),
    );
    setState(() {
      _topics = topics;
    });
  }

  void _addTopic() async {
    String? newTopic = await showDialog<String>(
      context: context,
      builder: (context) {
        String temp = "";
        return AlertDialog(
          title: Text("Add Topic", style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Topic name"),
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
    if (newTopic != null && newTopic.trim().isNotEmpty) {
      final topic = Topic(name: newTopic.trim(), subjectID: widget.subjectId);
      await Amplify.DataStore.save(topic);
      _loadTopics();
    }
  }

  void _deleteTopic(int index) async {
    await Amplify.DataStore.delete(_topics[index]);
    _loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myAppBar().bottomAppBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
                  Expanded(
                    child: Text(
                      widget.subjectName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                Expanded(
                  child: _topics.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 60,
                                color: Colors.white24,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No topics yet",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Create your first topic to begin learning",
                                style: TextStyle(color: Colors.white38),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 120),
                          itemCount: _topics.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    subjectName: widget.subjectName,
                                    topicName: _topics[index].name,
                                  ),
                                ),
                              );
                            },
                            child: GlassCard(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _topics[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  // Container(
                                  //   width: 8,
                                  //   height: 8,
                                  //   decoration: BoxDecoration(
                                  //     color: Theme.of(
                                  //       context,
                                  //     ).colorScheme.primary,
                                  //     shape: BoxShape.circle,
                                  //   ),
                                  // ),
                                  const SizedBox(width: 16),

                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red[300],
                                    ),
                                    onPressed: () => _deleteTopic(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // sits above bottom nav
            child: Center(
              child: GestureDetector(
                onTap: _addTopic,
                child: GlassCard(
                  borderRadius: BorderRadius.circular(999),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Create Topic",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
