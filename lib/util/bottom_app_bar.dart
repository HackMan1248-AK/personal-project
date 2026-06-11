// import 'package:flutter/material.dart';
// import 'package:ClassViz/pages/add_task_page.dart';

// class myAppBar {
//   final _controller = TextEditingController();
//   final addTaskController = TextEditingController();

//   void saveNewTask(BuildContext context) {
//     Navigator.of(context).pop();
//     _controller.clear();
//     addTaskController.clear(); // clears dropdown
//   }

//   void createNewTask(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AddTaskPage(
//           controller: _controller,
//           onSave: () {
//             saveNewTask(context);
//           },
//           onCancel: () => Navigator.of(context).pop(),
//           dropdownController: addTaskController,
//         );
//       },
//     );
//   }

//   BottomAppBar bottomAppBar(BuildContext context) {
//     return BottomAppBar(
//       color: Theme.of(context).primaryColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               if (ModalRoute.of(context)?.settings.name != '/homepage') {
//                 Navigator.pushNamed(context, "/homepage");
//               }
//             },
//             child: Icon(Icons.home),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               createNewTask(context);
//             },
//             child: Icon(Icons.note_add),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (ModalRoute.of(context)?.settings.name != '/taskspage') {
//                 Navigator.pushNamed(context, "/taskspage");
//               }
//             },
//             child: Icon(Icons.book),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (ModalRoute.of(context)?.settings.name != '/projectspage') {
//                 Navigator.pushNamed(context, "/projectspage");
//               }
//             },
//             child: Icon(Icons.folder),
//           ),
//           ElevatedButton(
//             child: Icon(Icons.person),
//             onPressed: () {
//               if (ModalRoute.of(context)?.settings.name != '/profilepage') {
//                 Navigator.pushNamed(context, "/profilepage");
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
