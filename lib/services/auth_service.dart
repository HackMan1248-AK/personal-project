import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ClassViz/util/dialog_box.dart';
import 'package:flutter/material.dart';
import "dart:io";

class AuthService {
  Future<void> updateUserName(String name, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.name,
        value: name,
      );
      Navigator.of(context).pop();
      dialogBox("✅ Username updated!", context);
    } on AuthException catch (e) {
      Navigator.of(context).pop();
      dialogBox("❌ Update username failed: ${e.message}", context);
    }
  }

  Future<Map<String, String?>> getCurrentUserAttributes() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final currentUser = await Amplify.Auth.getCurrentUser();

    String? email;
    String? name;

    for (final attr in attributes) {
      switch (attr.userAttributeKey.key) {
        case 'email':
          email = attr.value;
          break;
        case 'name':
          name = attr.value;
          break;
      }
    }

    return {'userId': currentUser.username, 'email': email, 'name': name};
  }

  // --- EMAIL/PASSWORD SIGN IN ---
  Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      final res = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      if (res.isSignedIn) {
        createUserInAPI();
        Navigator.of(context).pop();
        dialogBox("✅ Signed in with email!", context);
      }
    } on AuthException catch (e) {
      Navigator.of(context).pop();
      dialogBox("❌ Email sign-in failed: ${e.message}", context);
    }
  }

  // --- REGISTER (SIGN UP) ---
  Future<void> signUpWithEmail(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    if (password == confirmPassword) {
      try {
        await Amplify.Auth.signUp(username: email, password: password);
        Navigator.of(context).pop();
        dialogBox("✅ Sign up initiated! Confirm code sent to email.", context);
      } on AuthException catch (e) {
        Navigator.of(context).pop();
        dialogBox("❌ Sign up failed: ${e.message}", context);
      }
    } else {
      Navigator.of(context).pop();
      throw ArgumentError('Password and confirm password do not match.');
    }
  }

  // --- CONFIRM SIGN UP (after user enters code from email) ---
  Future<void> confirmSignUp(
    String email,
    String confirmationCode,
    BuildContext context,
    String password,
  ) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      // Auto sign-in after confirmation
      final signInResult = await Amplify.Auth.signIn(
        username: email,
        password: password, // You need to pass the password here!
      );
      if (signInResult.isSignedIn) {
        // Pop all dialogs and go to HomePage
        Navigator.of(
          context,
          rootNavigator: true,
        ).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, "/homepage");
      } else {
        dialogBox("✅ Confirmed! Please sign in.", context);
      }
      createUserInAPI();
    } on AuthException catch (e) {
      dialogBox("❌ Confirm sign up failed: ${e.message}", context);
    }
  }

  // --- FORGOT PASSWORD (send reset code) ---
  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.trim().isEmpty) {
      dialogBox("❌ Please enter a valid email address.", context);
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Amplify.Auth.resetPassword(username: email.trim());
      Navigator.of(context).pop();
      // Show dialog to enter code and new password
      String confirmationCode = '';
      String newPassword = '';
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Confirmation Code & New Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Confirmation Code"),
                  onChanged: (value) => confirmationCode = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "New Password"),
                  obscureText: true,
                  onChanged: (value) => newPassword = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      if (confirmationCode.isNotEmpty && newPassword.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        try {
          await Amplify.Auth.confirmResetPassword(
            username: email.trim(),
            newPassword: newPassword,
            confirmationCode: confirmationCode,
          );
          Navigator.of(context).pop();
          dialogBox("✅ Password reset successful!", context);
        } on AuthException catch (e) {
          Navigator.of(context).pop();
          dialogBox("❌ Confirm reset password failed: ${e.message}", context);
        }
      } else {
        dialogBox("❌ Please enter both code and new password.", context);
      }
    } on AuthException catch (e) {
      Navigator.of(context).pop();
      dialogBox("❌ Reset password failed: ${e.message}", context);
    }
  }

  // --- CONFIRM RESET PASSWORD (after user enters code and new password) ---
  Future<void> confirmResetPassword(
    String email,
    String newPassword,
    String confirmationCode,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      Navigator.of(context).pop();
      dialogBox("✅ Password reset successful!", context);
    } on AuthException catch (e) {
      Navigator.of(context).pop();
      dialogBox("❌ Confirm reset password failed: ${e.message}", context);
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Amplify.Auth.signOut();
      Navigator.of(context).pop();
      dialogBox("✅ Signed out!", context);
      Navigator.pushNamed(context, "/loginpage");
    } on AuthException catch (e) {
      Navigator.of(context).pop();
      dialogBox("❌ Sign out failed: ${e.message}", context);
    }
  }

  Future<String?> getProfilePhotoUrl() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final pictureAttr = attributes.firstWhere(
        (attr) => attr.userAttributeKey.key == 'picture',
        orElse: () => const AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.picture,
          value: '',
        ),
      );
      return pictureAttr.value.isNotEmpty ? pictureAttr.value : null;
    } catch (e) {
      print("Error fetching profile photo: $e");
      return null;
    }
  }

  // -- DELETE ACCOUNT --
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Step 1: Get user's Cognito sub
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final sub = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'sub')
          .value;

      // Step 2: Delete all tasks belonging to the user
      final listTasksRequest = GraphQLRequest<String>(
        document: '''
        query ListTasks {
          listTasks {
            items {
              id
              _version
            }
          }
        }
      ''',
      );
      final listTasksResponse = await Amplify.API
          .query(request: listTasksRequest)
          .response;
      final tasks =
          jsonDecode(listTasksResponse.data!)['listTasks']['items'] as List;

      for (final task in tasks) {
        final deleteTaskRequest = GraphQLRequest<String>(
          document: '''
          mutation DeleteTask(\$input: DeleteTaskInput!) {
            deleteTask(input: \$input) {
              id
            }
          }
        ''',
          variables: {
            'input': {'id': task['id'], '_version': task['_version']},
          },
        );
        await Amplify.API.mutate(request: deleteTaskRequest).response;
      }

      // Step 3: Delete the user's data from the User table
      final getUserRequest = GraphQLRequest<String>(
        document: '''
        query GetUser(\$id: ID!) {
          getUser(id: \$id) {
            id
            _version
          }
        }
      ''',
        variables: {'id': sub},
      );
      final getUserResponse = await Amplify.API
          .query(request: getUserRequest)
          .response;
      final userData = jsonDecode(getUserResponse.data!)['getUser'];
      if (userData != null) {
        final deleteUserRequest = GraphQLRequest<String>(
          document: '''
          mutation DeleteUser(\$input: DeleteUserInput!) {
            deleteUser(input: \$input) {
              id
            }
          }
        ''',
          variables: {
            'input': {'id': userData['id'], '_version': userData['_version']},
          },
        );
        await Amplify.API.mutate(request: deleteUserRequest).response;
      }

      // Step 4: Delete user from Cognito
      await Amplify.Auth.deleteUser();

      // Step 5: Show success message or navigate to login
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Account Deleted", style: TextStyle(color: Colors.white)),
          content: Text(
            "Your account and data have been successfully removed.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/loginpage');
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print('❌ Account deletion failed: $e');
      dialogBox('Failed to delete account: $e', context);
    }
  }

  Future<String?> uploadProfilePhoto(File file) async {
    try {
      // You should upload the file to your backend or a file server and get a URL.
      // For demonstration, let's encode the image as base64 and store it in Cognito (not recommended for large images).
      // In production, upload to your backend and store the URL in Cognito.

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final dataUrl = "data:image/png;base64,$base64Image";

      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.picture,
        value: dataUrl,
      );
      return dataUrl;
    } on AuthException catch (e) {
      print("Error uploading profile photo: ${e.message}");
      return null;
    }
  }

  // CHECK IF THERE IS A USER ATTRIBUTE
  Future<bool> userExists(String sub) async {
    final request = GraphQLRequest<String>(
      document: '''
      query GetUser(\$id: ID!) {
        getUser(id: \$id) {
          id
        }
      }
    ''',
      variables: {'id': sub},
    );

    final response = await Amplify.API.query(request: request).response;
    return response.data != null &&
        jsonDecode(response.data!)['getUser'] != null;
  }

  Future<void> createUserInAPI() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();

    final sub = attributes
        .firstWhere((a) => a.userAttributeKey.key == 'sub')
        .value;
    if (!await userExists(sub)) {
      try {
        final input = {
          'id': sub,
          'knowledge': 0.00,
          'charisma': 0.00,
          'strength': 0.00,
          'persistence': 0.00,
          'level': 1.00,
          'createdAt': TemporalDateTime.now().format(),
          'updatedAt': TemporalDateTime.now().format(),
        };

        final request = GraphQLRequest<String>(
          document: '''
          mutation CreateUser(\$input: CreateUserInput!) {
            createUser(input: \$input) {
              id
            }
          }
        ''',
          variables: {'input': input},
        );

        final response = await Amplify.API.mutate(request: request).response;

        if (response.errors.isEmpty) {
          print('✅ User created with ID: $sub');
        } else {
          print('❌ GraphQL errors: ${response.errors}');
        }
      } catch (e) {
        print('❌ Error creating user: $e');
      }
    }
  }
}
