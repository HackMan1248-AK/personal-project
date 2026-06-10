// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_core/flutter_chat_core.dart' as core;
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:personal_project_v2/util/bottom_app_bar.dart';

// class TopicPage extends StatefulWidget {
//   final String subjectName;
//   final String topicName;

//   const TopicPage({
//     super.key,
//     required this.subjectName,
//     required this.topicName,
//   });

//   @override
//   State<TopicPage> createState() => _TopicPageState();
// }

// class _TopicPageState extends State<TopicPage> {
//   late final core.ChatController _chatController;
//   final Gemini gemini = Gemini.instance;

//   final String currentUserId = 'user_0';
//   final String botUserId = 'bot_1';

//   final StringBuffer _botBuffer = StringBuffer();

//   @override
//   void initState() {
//     super.initState();
//     _chatController = core.ChatController(
//       messages: [],
//       scrollController: ScrollController(),
//     );
//   }

//   @override
//   void dispose() {
//     _chatController.dispose();
//     super.dispose();
//   }

//   core.User _resolveUser(String id) {
//     if (id == currentUserId) {
//       return const core.User(id: 'user_0', name: 'You');
//     }
//     return const core.User(id: 'bot_1', name: 'ChatBot');
//   }

//   // ---------- Streaming-safe send ----------
//   void _handleSend(String text) {
//     final userMessage = core.TextMessage(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       authorId: currentUserId,
//       createdAt: DateTime.now(),
//       text: text,
//     );

//     _chatController.addMessage(userMessage);

//     _streamBotReply(text);
//   }

//   void _streamBotReply(String question) {
//     _botBuffer.clear();

//     final botMessageId = 'bot_${DateTime.now().millisecondsSinceEpoch}';

//     _chatController.addMessage(
//       core.TextMessage(
//         id: botMessageId,
//         authorId: botUserId,
//         createdAt: DateTime.now(),
//         text: '',
//       ),
//     );

//     final prompt =
//         "${_buildHiddenSystemPrompt()}\n\nUser: $question";

//     gemini.streamGenerateContent(prompt).listen(
//       (event) {
//         final chunk = _extractChunkFromEvent(event);
//         if (chunk.isEmpty) return;

//         _botBuffer.write(chunk);

//         final old = _chatController.messages
//             .whereType<core.TextMessage>()
//             .firstWhere((m) => m.id == botMessageId);

//         _chatController.updateMessage(
//           old.copyWith(text: _botBuffer.toString()),
//         );
//       },
//       onError: (e) => debugPrint('Streaming error: $e'),
//     );
//   }

//   // ---------- Hidden system prompt ----------
//   String _buildHiddenSystemPrompt() {
//     return '''
// You are a professional subject-matter expert.
// Explain clearly, concisely, and correctly.
// Use LaTeX math where appropriate.
// Subject: ${widget.subjectName}
// Topic: ${widget.topicName}
// ''';
//   }

//   // ---------- Chat UI ----------
//   Widget _buildChat() {
//     return Chat(
//       chatController: _chatController,
//       currentUserId: currentUserId,
//       resolveUser: _resolveUser,
//       onSendTap: _handleSend,
//       messageBuilder: _buildMessageWidget,
//     );
//   }

//   // ---------- Markdown + LaTeX renderer ----------
//   Widget _buildMessageWidget(
//     BuildContext context,
//     core.Message message,
//   ) {
//     if (message is! core.TextMessage) {
//       return const SizedBox.shrink();
//     }

//     final text = message.text;
//     final reg = RegExp(r'(\$\$[\s\S]+?\$\$|\$[^$\n]+\$)');
//     final widgets = <Widget>[];

//     int last = 0;
//     for (final m in reg.allMatches(text)) {
//       if (m.start > last) {
//         widgets.add(_markdown(text.substring(last, m.start)));
//       }

//       final token = m.group(0)!;
//       if (token.startsWith('$$')) {
//         widgets.add(Math.tex(
//           token.substring(2, token.length - 2),
//           mathStyle: MathStyle.display,
//         ));
//       } else {
//         widgets.add(Math.tex(
//           token.substring(1, token.length - 1),
//           mathStyle: MathStyle.text,
//         ));
//       }

//       last = m.end;
//     }

//     if (last < text.length) {
//       widgets.add(_markdown(text.substring(last)));
//     }

//     return Wrap(children: widgets);
//   }

//   Widget _markdown(String data) {
//     return MarkdownBody(
//       data: data,
//       selectable: false,
//       styleSheet:
//           MarkdownStyleSheet.fromTheme(Theme.of(context)),
//     );
//   }

//   // ---------- Gemini chunk extraction ----------
//   String _extractChunkFromEvent(dynamic event) {
//     try {
//       final parts = event.content?.parts;
//       if (parts is Iterable) {
//         return parts.map((p) => p?.text ?? '').join();
//       }
//       return event.content?.text ?? '';
//     } catch (_) {
//       return '';
//     }
//   }

//   // ---------- Scaffold ----------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.topicName)),
//       bottomNavigationBar: myAppBar().bottomAppBar(context),
//       body: Column(
//         children: [
//           if (widget.subjectName.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Text(widget.subjectName,
//                   style: const TextStyle(color: Colors.grey)),
//             ),
//           Expanded(child: _buildChat()),
//         ],
//       ),
//     );
//   }
// }
