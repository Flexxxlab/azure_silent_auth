import 'package:app/authentication_handler.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenViewModel extends ChangeNotifier {
  bool _silentLoginInProgress = false;

  bool get silentLoginInProgress => _silentLoginInProgress;

  void silentLogin(BuildContext context, VoidCallback onError) async {
    try {
      _silentLoginInProgress = true;
      await AuthenticationHandler().silentLogin();
    } catch (error) {
      // Handle error during silentLogin
      // You might want to handle the error or log it
      // For simplicity, this example navigates to Screen0
      onError();
      return;
    } finally {
      _silentLoginInProgress = false;
      notifyListeners();
    }
  }
}

class HomeScreen extends StatelessWidget {
  final bool silentLogin;

  const HomeScreen({Key? key, required this.silentLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(),
      child: _Screen1Content(silentLogin: silentLogin),
    );
  }
}

class _Screen1Content extends StatefulWidget {
  final bool silentLogin;

  const _Screen1Content({Key? key, required this.silentLogin})
      : super(key: key);

  @override
  State<_Screen1Content> createState() => _Screen1ContentState();
}

class _Screen1ContentState extends State<_Screen1Content> {
  late HomeScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    if (widget.silentLogin) {
      viewModel.silentLogin(context, () {
        _navigateToScreen0(context);
      });
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
              if (viewModel.silentLoginInProgress) {
                // If silentLogin is in progress, don't navigate to Screen0
                return;
              }
              if (context.mounted) {
                _navigateToScreen0(context);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HomeScreenViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.silentLoginInProgress) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Open Screen2 by pushing it to the navigation stack
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Screen2()),
                      );
                    },
                    child: const Text('Go to Detail'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _navigateToScreen0(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
