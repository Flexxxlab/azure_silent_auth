import 'package:azure_silent_auth/storage/abstract/storage_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Implementation of StorageProvider using FlutterSecureStorage.
class DefaultStorage implements StorageProvider {
  // Keys for secure storage.
  static String tokenResponseKey = 'token_response';
  static String userNameKey = 'user_name_from_token';

  late final FlutterSecureStorage _storage;

  /// Constructor to initialize the DefaultStorage instance.
  ///
  /// Parameters:
  /// - `storage`: Optional parameter to provide a custom instance of FlutterSecureStorage.
  ///              Defaults to a new instance if no value is provided.
  DefaultStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
                aOptions: AndroidOptions(
              encryptedSharedPreferences: true,
            ));

  /// Checks if the access token is saved locally.
  ///
  /// Returns `true` if the token is found in secure storage, otherwise `false`.
  @override
  Future<bool> isTokenSavedLocally() async {
    final String? tokenResponseJson =
        await _storage.read(key: tokenResponseKey);
    return (tokenResponseJson != null);
  }

  /// Sets the access token response in secure storage.
  ///
  /// Parameters:
  /// - `value`: The value of the access token response to be stored.
  @override
  Future<void> setTokenResponse(String value) async {
    await _storage.write(key: tokenResponseKey, value: value);
  }

  /// Reads the access token response from secure storage.
  ///
  /// Returns the stored access token response or `null` if not found.
  @override
  Future<String?> readTokenResponse() async {
    return await _storage.read(key: tokenResponseKey);
  }

  /// Deletes the locally stored access token.
  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: tokenResponseKey);
  }

  /// Sets the user info in secure storage.
  ///
  /// Parameters:
  /// - `name`: The user info to be stored.
  @override
  Future<void> setUserInfo(String? name) async {
    await _storage.write(key: userNameKey, value: name);
  }

  /// Reads the stored user info from secure storage.
  ///
  /// Returns the stored user info or `null` if not found.
  /// which can be encoded into `OpenIdClaims`
  /// using `jsonDecode()` and `OpenIdClaims.fromJson()`.
  /// `OpenIdClaims` implements `UserInfo` wher you will find
  /// all the information about the logged in user
  @override
  Future<String?> getUserInfo() async {
    return await _storage.read(key: userNameKey);
  }

  /// Deletes the locally stored user name.
  @override
  Future<void> deleteUserName() async {
    await _storage.delete(key: userNameKey);
  }
}
