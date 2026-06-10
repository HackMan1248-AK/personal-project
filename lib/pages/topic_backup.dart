// import "package:flutter_chat_ui/flutter_chat_ui.dart";
// import "package:flutter_chat_types/flutter_chat_types.dart" as types;
// import "package:flutter_chat_core/flutter_chat_core.dart";
// import "package:flutter/material.dart";
// import "package:personal_project_v2/util/bottom_app_bar.dart";
// import "package:flutter_gemini/flutter_gemini.dart";

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
//   final Gemini gemini = Gemini.instance;

//   List<types.Message> messages = [];
//   final types.User _currentUser = types.User(id: "0", firstName: "You");
//   final types.User _botUser = types.User(id: "1", firstName: "ChatBot");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.topicName)),
//       bottomNavigationBar: myAppBar().bottomAppBar(context),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return Chat(
//       chatController: ChatController(),
//       currentUserId: _currentUser.id,
//       resolveUser: (userId) async {
//         if (userId == _currentUser.id) _currentUser;
//         if (userId == _botUser.id) _botUser;
//         return null;
//       },
//     );
//   }

//   void _sendMessage(types.PartialText partialText) {
//     final String text = partialText.text;
//     final userMessage = types.TextMessage(
//       author: _currentUser,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       text: text,
//     );
//     setState(() {
//       messages.insert(0, userMessage);
//     });

//     try {
//       gemini.streamGenerateContent(text).listen((event) {
//         final String responseText = (event.content?.parts ?? []).fold<String>(
//           "",
//           (previous, current) {
//             final dynamic part = current;
//             if (part == null) return previous;
//             if (part is String) return "$previous$part";

//             try {
//               final dyn = part as dynamic;
//               final maybeText =
//                   dyn.text ??
//                   dyn.content ??
//                   (part is Map ? part['text'] ?? part['content'] : null);
//               return "$previous${maybeText?.toString() ?? part.toString()}";
//             } catch (_) {
//               return "$previous${part.toString()}";
//             }
//           },
//         );

//         final botMessage = types.TextMessage(
//           author: _botUser,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: DateTime.now().millisecondsSinceEpoch.toString() + 'bot',
//           text: responseText,
//         );

//         setState(() {
//           if (messages.isNotEmpty && messages.first.author.id == _botUser.id) {
//             messages[0] = botMessage;
//           } else {
//             messages.insert(0, botMessage);
//           }
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }
