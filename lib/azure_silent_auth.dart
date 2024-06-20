library azure_silent_auth;

import 'dart:convert';
import 'dart:developer';
import 'package:azure_silent_auth/authenticator/abstract/authenticator_provider.dart';
import 'package:azure_silent_auth/model.dart';
import 'package:azure_silent_auth/authenticator/abstract/token_provider.dart';
import 'package:azure_silent_auth/storage/abstract/storage_provider.dart';
import 'package:azure_silent_auth/storage/default_storage.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';

/// Azure login provider implementing TokenProvider.
class AzureAuth implements AzureAuthAbstract {
  final StorageProvider _storageProvider;
  final AuthenticatorProvider _authenticatorProvider;

  /// Constructor to initialize the AzureAuth instance.
  ///
  /// Parameters:
  /// - `_authenticatorProvider`: The AuthenticatorProvider for the login process.
  ///                             Recommended to use `DefaultAuthenticator` if using this package for the first time.
  /// - `storageOperations`: Optional parameter for a custom StorageProvider.
  ///                        Defaults to using `DefaultStorage` if no value is provided.
  AzureAuth({
    required AuthenticatorProvider authenticatorProvider,
    StorageProvider? storageProvider,
  })  : _authenticatorProvider = authenticatorProvider,
        _storageProvider = storageProvider ?? DefaultStorage();

  /// throws an exception if the TokenResponse from AuthenticatorProvider is null.
  ///
  /// Initiates the login process using the authenticator provider. Stores the accessToken and
  /// user info locally using storage provider
  @override
  Future<void> login() async {
    await _authenticatorProvider.authorize();

    final TokenResponse? tokenResponse =
        await _authenticatorProvider.getTokenResponse();
    if (tokenResponse == null) {
      throw 'TokenResponse from AuthenticatorProvider is null. Check if the Credentials is created or not';
    }

    await _storageProvider.setTokenResponse(_toEncodedString(tokenResponse));

    final String? userInfo = _authenticatorProvider.getUserInfo();
    if (userInfo != null) {
      await _storageProvider.setUserInfo(userInfo);
    }

    _authenticatorProvider.close();
  }

  /// Attempts to perform a silent login using a previously stored token response obtained from the `storageProvider`.
  /// Throws an error if the silent login fails. Use a try-catch block and call `login()` in the catch block
  /// to open the authentication page for the user.
  @override
  Future<void> silentLogin() async {
    String? savedTokenResponseString =
        await _storageProvider.readTokenResponse();

    await _authenticatorProvider.authorize(
        tokenResponseString: savedTokenResponseString);

    // tries to refresh the token if expired if not expired it returns the token
    final TokenResponse? tokenResponse =
        await _authenticatorProvider.getTokenResponse();

    // if we dont have token even after silent refresh, show login screen
    if (tokenResponse == null) {
      throw 'Silent login failed. `AuthenticatorProvider` failed to create `Credentials using saved token`. Call `login()` to open authentication page';
    }
  }

  /// Performs logout by deleting locally stored token and user name,
  /// and making a request to the logout endpoint if available.
  @override
  Future<void> logout() async {
    await _storageProvider.deleteToken();
    await _storageProvider.deleteUserName();

    final logoutUri = _authenticatorProvider.generateLogoutUrl();
    if (logoutUri != null) {
      await http.get(logoutUri);
    } else {
      log('client.issuer.metadata.endSessionEndpoint is null.');
    }
  }

  /// Retrieves the access token obtained during the authorization process.
  @override
  Future<String?> getAccessToken() async {
    final tokenResponse = await _authenticatorProvider.getTokenResponse();
    if (tokenResponse == null) {
      return null;
    }
    return _toEncodedString(tokenResponse);
  }

  /// Retrieves stored user information from the secure storage.
  @override
  Future<User?> getUserInfo() async {
    final userInfoString = _authenticatorProvider.getUserInfo();
    if (userInfoString == null) {
      return null;
    }
    final Map<String, dynamic> jsonMap = jsonDecode(userInfoString);
    final claims = OpenIdClaims.fromJson(jsonMap);
    return User.fromUserInfo(claims);
  }

  // Converts a TokenResponse object into an encoded string.
  String _toEncodedString(TokenResponse tokenResponse) {
    final Map<String, dynamic> jsonMap = tokenResponse.toJson();
    return jsonEncode(jsonMap);
  }

  @override
  Uri? logoutUrl() {
    return _authenticatorProvider.generateLogoutUrl();
  }
}
