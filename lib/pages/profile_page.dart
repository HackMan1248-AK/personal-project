import "dart:convert";
import "dart:io";
import "package:amplify_flutter/amplify_flutter.dart";
import "package:flutter/material.dart";
import "package:ClassViz/services/auth_service.dart";
import "package:ClassViz/util/custom_bottom_nav.dart";
import "package:image_picker/image_picker.dart";
import "package:ClassViz/util/custom_cards.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /* void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, "/loginpage");
  }

  void signOut(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      Navigator.pushNamed(context, "/loginpage");
    } on AuthException catch (e) {
      print("❌ Sign out failed: ${e.message}");
    }
  } */

  File? _image;
  String? _imageUrl;
  bool _isUploading = false;
  int? level;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
    _fetchLevel();
  }

  Future<void> _loadProfilePhoto() async {
    final url = await AuthService().getProfilePhotoUrl();
    setState(() {
      _imageUrl = url;
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      final url = await AuthService().uploadProfilePhoto(File(pickedFile.path));
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = url;
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile photo updated')));
      }
    }
  }

  Future<void> _fetchLevel() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final sub = attributes
        .firstWhere((a) => a.userAttributeKey.key == 'sub')
        .value;

    final request = GraphQLRequest<String>(
      document: '''
      query listUsers {
        listUsers {
          items {
            id
            level
          }
        }
      }
    ''',
    );

    final response = await Amplify.API.query(request: request).response;

    if (response.data != null) {
      final Map<String, dynamic> decoded = jsonDecode(response.data!);
      final List items = decoded['listUsers']['items'];

      for (var item in items) {
        if (item["id"] == sub) {
          setState(() {
            level = item["level"]?.toInt();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120, left: 40, right: 40),
              child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        GestureDetector(
                          onTap: () {
                            AuthService().signOut(context);
                            Navigator.pushNamed(context, "/loginpage");
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.logout,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32),
                    FutureBuilder<Map<String, String?>>(
                      future: AuthService().getCurrentUserAttributes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return Text('Unable to load profile');
                        }

                        final userData = snapshot.data!;
                        final userId = userData['userId'] ?? 'Unknown';
                        final email = userData['email'] ?? 'Unknown';
                        final name = userData['name'] ?? '';
                        final nameController = TextEditingController(
                          text: name,
                        );
                        final initial = name.isNotEmpty
                            ? name[0].toUpperCase()
                            : 'A';

                        return Column(
                          children: [
                            // Avatar Circle
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.25),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: _image != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(_image!),
                                        )
                                      : (_imageUrl != null
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  _imageUrl!,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  initial,
                                                  style: TextStyle(
                                                    fontSize: 44,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )),
                                ),
                                GestureDetector(
                                  onTap: _isUploading
                                      ? null
                                      : _pickAndUploadImage,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'ID $userId',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 32),
                            glowingCard(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EMAIL",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              context,
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            GlassCard(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EDIT USERNAME",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: nameController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            isCollapsed: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          await AuthService().updateUserName(
                                            nameController.text,
                                            context,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatCard(
                                  label: 'Level',
                                  value: level?.toString() ?? "--",
                                ),
                                _StatCard(label: 'Quests', value: '127'),
                                _StatCard(label: 'Streak', value: '12d'),
                              ],
                            ),
                            SizedBox(height: 28),
                            GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text(
                                      "Confirm Deletion",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      "This will delete your account and all data permanently. Proceed?",
                                      style: TextStyle(color: Colors.grey[300]),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await AuthService().deleteAccount(context);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.08),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Delete account',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      // color: Color.fromARGB(255, 244, 67, 54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
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
                currentIndex: 4,
                onTap: (index) {
                  if (index == 0) Navigator.pushNamed(context, "/homepage");
                  if (index == 1) Navigator.pushNamed(context, "/taskspage");
                  if (index == 2) {}
                  if (index == 3) Navigator.pushNamed(context, "/projectspage");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 35,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget glowingCard(Widget child, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          blurRadius: 40,
          spreadRadius: -8,
        ),
      ],
    ),
    child: GlassCard(padding: const EdgeInsets.all(20), child: child),
  );
}
