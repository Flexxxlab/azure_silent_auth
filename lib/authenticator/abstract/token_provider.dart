import 'package:azure_silent_auth/model.dart';

/// Abstract class defining the contract for an token provider.
abstract class AzureAuthAbstract {
  /// Retrieves the access token.
  Future<String?> getAccessToken();

  /// Retrives users information
  Future<User?> getUserInfo();

  /// Prescents the login screen and stores user data upon success
  Future<void> login();

  /// Uses stored access token and authenticate in the background
  Future<void> silentLogin();

  /// Logs out user from azure and deletes the stored user data
  Future<void> logout();
}
