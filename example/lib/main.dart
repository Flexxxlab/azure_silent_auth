import 'package:azure_silent_auth/authenticator/default_authenticator.dart';
import 'package:azure_silent_auth/model.dart';
import 'package:azure_silent_auth/azure_silent_auth.dart';
import 'package:app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:azure_silent_auth/storage/default_storage.dart';

class AuthenticationHandler {
  static final AuthenticationHandler _instance =
      AuthenticationHandler._internal();

  factory AuthenticationHandler() {
    return _instance;
  }

  AuthenticationHandler._internal();

  final AzureAuth _azureAuth = AzureAuth(
    authenticatorProvider: DefaultAuthenticator(
      'https://login.microsoftonline.com/90440eb1-5d83-4e46-82b7-430409c54b9e/',
      ["openId", "offline_access"],
      'd4e38243-f46f-44b8-9916-b00299661b71',
      '&prompt=select_account',
      3000, // localhost redirect uri port
    ),
  );

  Future<void> login() async {
    await _azureAuth.login();
  }

  Future<void> silentLogin() async {
    await _azureAuth.silentLogin();
  }

  Future<void> logout() async {
    await _azureAuth.logout();
  }

  Future<String?> getUserName() async {
    return await _azureAuth.getUserInfo().then((value) => value?.name);
  }

  Future<User?> getAllInfo() async {
    return await _azureAuth.getUserInfo();
  }
}

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
