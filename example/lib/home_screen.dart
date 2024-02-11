import 'package:app/authentication_handler.dart';
import 'package:app/detail_screen.dart';
import 'package:app/main.dart';
import 'package:azure_silent_auth/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenViewModel extends ChangeNotifier {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _userName;
  String? get userName => _userName;

  User? _user;
  User? get user => _user;

  void silentLogin(BuildContext context, VoidCallback onError) async {
    try {
      _inProgress = true;
      await AuthenticationHandler().silentLogin();
      _userName = await AuthenticationHandler().getUserName();
      _user = await AuthenticationHandler().getAllInfo();
    } catch (error) {
      // Handle error during silentLogin
      // You might want to handle the error or log it
      // For simplicity, this example navigates to Screen0
      onError();
      return;
    } finally {
      _inProgress = false;
      notifyListeners();
    }
  }

  void getUserData() async {
    _inProgress = true;
    _userName = await AuthenticationHandler().getUserName();
    _user = await AuthenticationHandler().getAllInfo();
    _inProgress = false;
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  final bool silentLogin;

  const HomeScreen({Key? key, required this.silentLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(),
      child: _HomeScreenContent(silentLogin: silentLogin),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final bool silentLogin;

  const _HomeScreenContent({Key? key, required this.silentLogin})
      : super(key: key);

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  late HomeScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    if (widget.silentLogin) {
      viewModel.silentLogin(context, () {
        _navigateToLoginScreen(context);
      });
    } else {
      viewModel.getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthenticationHandler().logout();
              if (viewModel.inProgress) {
                // If silentLogin is in progress, don't navigate to Screen0
                return;
              }
              if (context.mounted) {
                _navigateToLoginScreen(context);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HomeScreenViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.inProgress) {
              return const CircularProgressIndicator();
            } else {
              final user = viewModel.user;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.userName != null)
                    Text('Hello ${viewModel.userName}'),
                  if (user != null)
                    ElevatedButton(
                      onPressed: () {
                        // Open Screen2 by pushing it to the navigation stack
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    user: user,
                                  )),
                        );
                      },
                      child: const Text('Profile'),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
