import "package:flutter/material.dart";
import "package:ClassViz/services/auth_service.dart";
import "package:ClassViz/util/text_field.dart";

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Example: Show dialog after successful sign up
  void promptForConfirmationCode(String email, String password) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Enter Confirmation Code",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(hintText: "Confirmation Code"),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await AuthService().confirmSignUp(
                email,
                codeController.text,
                context,
                password, // Pass password here
              );
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void wrongCredentials(String cred) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          cred,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Text(
                  "Start Now!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 46,
                    fontFamily: "UA",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // email & password
                MyField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                MyField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 65),

                // sign in button
                GestureDetector(
                  onTap: () async {
                    try {
                      await AuthService().signUpWithEmail(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        context,
                      );
                      if (!mounted) return;
                      promptForConfirmationCode(
                        emailController.text,
                        passwordController.text,
                      );
                    } catch (e) {
                      wrongCredentials(e.toString());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    margin: EdgeInsets.symmetric(horizontal: 115.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50),
                // not a member? Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already adventuring?",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now!",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
