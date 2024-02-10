// Abstract class defining the contract for a storage provider.
abstract class StorageProvider {
  /// Checks if the token is saved locally.
  Future<bool> isTokenSavedLocally();

  /// Sets the token response value locally.
  Future<void> setTokenResponse(String value);

  /// Reads the locally stored token response.
  Future<String?> readTokenResponse();

  /// Deletes the locally stored token.
  Future<void> deleteToken();

  /// Sets the user info locally.
  Future<void> setUserInfo(String? name);

  /// Retrieves the locally stored encoded user info json.
  Future<String?> getUserInfo();

  /// Deletes the locally stored user name.
  Future<void> deleteUserName();
}
