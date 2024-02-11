import 'package:azure_silent_auth/authenticator/default_authenticator.dart';
import 'package:azure_silent_auth/model.dart';
import 'package:azure_silent_auth/azure_silent_auth.dart';

class AuthenticationHandler {
  static final AuthenticationHandler _instance =
      AuthenticationHandler._internal();

  factory AuthenticationHandler() {
    return _instance;
  }

  AuthenticationHandler._internal();

  final AzureAuth _microsoftAuthenticator = AzureAuth(
    authenticatorProvider: DefaultAuthenticator(
      'https://login.microsoftonline.com/90440eb1-5d83-4e46-82b7-430409c54b9e/',
      ["openId", "offline_access"],
      'd4e38243-f46f-44b8-9916-b00299661b71',
      '&prompt=select_account',
      3000, // localhost redirect uri port
    ),
  );

  Future<void> login() async {
    await _microsoftAuthenticator.login();
  }

  Future<void> silentLogin() async {
    await _microsoftAuthenticator.silentLogin();
  }

  Future<void> logout() async {
    await _microsoftAuthenticator.logout();
  }

  Future<String?> getUserName() async {
    return await _microsoftAuthenticator
        .getUserInfo()
        .then((value) => value?.name);
  }

  Future<User?> getAllInfo() async {
    return await _microsoftAuthenticator.getUserInfo();
  }
}
