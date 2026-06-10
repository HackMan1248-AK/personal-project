import "package:flutter/material.dart";
import "package:ClassViz/services/auth_service.dart";
import "package:ClassViz/util/text_field.dart";

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /*void signUserIn() async {
    //login progress
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      wrongCredentials(e.code);
    }
  }

  void resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      wrongCredentials("Password reset code sent to e-mail");
      // Prompt user for code and new password
    } on AuthException catch (e) {
      wrongCredentials(e.message);
      rethrow;
    }
  }

  void signInWithEmail() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      await Amplify.Auth.signIn(
        username: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      wrongCredentials(e.message);
    }
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
  }*/

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Text(
                  "Let's Get",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 46,
                    fontFamily: "UA",
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Started!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 46,
                    fontFamily: "UA",
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 75),

                // email & password
                MyField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                // forgot password
                GestureDetector(
                  onTap: () {
                    AuthService().resetPassword(emailController.text, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 65),

                // sign in button
                GestureDetector(
                  onTap: () {
                    AuthService().signInWithEmail(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
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
                        "Sign In",
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
                      "First Time Adventuring?",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Start Now!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
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
