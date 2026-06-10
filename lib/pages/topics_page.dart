import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class TopicPage extends StatefulWidget {
  final String subjectName;
  final String topicName;
  const TopicPage({
    super.key,
    required this.subjectName,
    required this.topicName,
  });

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late final InMemoryChatController _chatController;

  final _currentUser = const User(id: 'user');
  final _botUser = const User(id: 'bot');

  final StringBuffer _botBuffer = StringBuffer();

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 16, 50),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 16, 50),
        elevation: 0,
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.grey[400]),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Academic tutor',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${widget.subjectName} · ${widget.topicName}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Chat(
        chatController: _chatController,
        currentUserId: _currentUser.id,
        resolveUser: _resolveUser,
        onMessageSend: _onMessageSend,
        backgroundColor: Color.fromARGB(255, 20, 16, 50),
        theme: ChatTheme.light(),
      ),
    );
  }

  Future<User?> _resolveUser(UserID id) async {
    if (id == _currentUser.id) return _currentUser;
    if (id == _botUser.id) return _botUser;
    return null;
  }

  void _onMessageSend(String text) {
    if (text.isEmpty) return;

    final userMessage = Message.text(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: _currentUser.id,
      createdAt: DateTime.now(),
      text: text,
    );

    _chatController.insertMessage(userMessage);
    _insertBotResponse(text);
  }

  void _insertBotResponse(String userText) {
    _botBuffer.clear();
    int previousLength = 0;

    final botMessage = Message.text(
      id: 'bot-${DateTime.now().millisecondsSinceEpoch}',
      authorId: _botUser.id,
      createdAt: DateTime.now(),
      text: '',
    );

    _chatController.insertMessage(botMessage);

    var currentMessage = botMessage;

    Gemini.instance.promptStream(parts: [Part.text(userText)]).listen((event) {
      final currentOutput = event?.output ?? '';
      final newChunk = currentOutput.substring(previousLength);
      _botBuffer.write(newChunk);
      previousLength = currentOutput.length;

      final updatedMessage = Message.text(
        id: currentMessage.id,
        authorId: _botUser.id,
        createdAt: currentMessage.createdAt,
        text: _botBuffer.toString(),
      );

      _chatController.updateMessage(currentMessage, updatedMessage);

      currentMessage = updatedMessage;
    });
  }
}
