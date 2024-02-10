import 'package:app/authentication_handler.dart';
import 'package:app/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:azure_silent_auth/storage/default_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DefaultStorage storage = DefaultStorage();
  final value = await storage.isTokenSavedLocally();

  runApp(MyApp(isTokenAvailable: value));
}

class MyApp extends StatelessWidget {
  final bool isTokenAvailable;

  const MyApp({Key? key, required this.isTokenAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isTokenAvailable
          ? const HomeScreen(silentLogin: true)
          : const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthenticationHandler().login();

            if (context.mounted) {
              // Replace current screen with Screen1
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(silentLogin: false)),
              );
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: const Center(
        child: Text('more content'),
      ),
    );
  }
}
