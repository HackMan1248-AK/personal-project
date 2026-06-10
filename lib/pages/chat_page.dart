import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:markdown_widget/markdown_widget.dart';
// import 'package:flutter_math_fork/flutter_math.dart';

class ChatPage extends StatefulWidget {
  final String subjectName;
  final String topicName;

  const ChatPage({
    super.key,
    required this.subjectName,
    required this.topicName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const String geminiApiKey =
      "AQ.Ab8RN6KPOxGEVwq3a5pMGGxRZadgzn2P_XSK0JFDPd3FAqaCTQ";

  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  late final String _systemPrompt;

  @override
  void initState() {
    super.initState();

    _systemPrompt =
        '''
You are an academic tutor specializing in
${widget.subjectName} and ${widget.topicName}.

Rules:
- Answer only questions related to these topics.
- Use an academic tone.
- Explain concepts thoroughly.
- Refuse unrelated requests.
- If a question is outside the selected topic, politely redirect the user.
''';
  }

  List<Map<String, String>> get visibleMessages => _messages;

  Future<void> sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"role": "user", "content": text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final conversation = StringBuffer();

      conversation.writeln(_systemPrompt);
      conversation.writeln();

      for (final msg in _messages) {
        conversation.writeln("${msg["role"]}: ${msg["content"]}");
      }

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$geminiApiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": conversation.toString()},
              ],
            },
          ],
        }),
      );

      // print("Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final data = jsonDecode(response.body);

      final aiReply = data["candidates"][0]["content"]["parts"][0]["text"];

      setState(() {
        _messages.add({"role": "assistant", "content": aiReply});
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message["role"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isUser
            ? Text(
                message["content"] ?? "",
                style: const TextStyle(color: Colors.white),
              )
            : MarkdownWidget(data: message["content"] ?? "", shrinkWrap: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subjectName} • ${widget.topicName}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: visibleMessages.length,
              itemBuilder: (context, index) {
                return buildMessage(visibleMessages[index]);
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Ask an academic question...",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
