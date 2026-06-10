import "package:flutter/material.dart";
import "package:amplify_flutter/amplify_flutter.dart";
import "package:ClassViz/pages/home_page.dart";
import "package:ClassViz/pages/auth/login_or_register_page.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    Amplify.Hub.listen(HubChannel.Auth, (hubEvent) {
      if (hubEvent.eventName == 'SIGNED_IN' ||
          hubEvent.eventName == 'SIGNED_OUT') {
        _checkAuthStatus();
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      setState(() {
        _isSignedIn = session.isSignedIn;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSignedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(body: _isSignedIn ? HomePage() : LoginOrRegisterPage());
  }
}
