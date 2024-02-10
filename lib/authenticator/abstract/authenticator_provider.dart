import 'dart:convert';

import 'package:openid_client/openid_client_io.dart';

// Abstract class defining the contract for an authenticator provider.
abstract class AuthenticatorProvider {
  /// Where the authorize() stores the credential after successfull login.
  Credential? credential;

  /// Initiates the authorization process.
  ///
  /// Parameters:
  /// - `tokenResponse`: Saved token response from the storage provider.
  ///                    If the value is null, the method will prompt the login screen.
  ///                    If not, it will use this value to create credential
  Future<void> authorize({
    String? tokenResponseString,
  });

  /// Closes any resources or UI related to the authentication process.
  void close();

  /// Retrieves the user info obtained during the authorization process.
  ///
  /// Return:
  /// -`String?`: an optional encoded string, which can be encoded into `OpenIdClaims`
  ///            using `jsonDecode()` and `OpenIdClaims.fromJson()`.
  ///
  /// Note: Do not call this method before calling authorize().
  String? getUserInfo() {
    final claim = credential?.idToken.claims;
    return (claim == null) ? null : _userInfoToEncodedString(claim);
  }

  /// Retrieves the token response obtained during the authorization process.
  ///
  /// Note: Do not call this method before calling authorize().
  Future<TokenResponse?> getTokenResponse([bool forceRefresh = false]) async {
    return await credential?.getTokenResponse(forceRefresh);
  }

  /// Generates a logout URL based on the current credentials.
  ///
  /// Note: Do not call this method before calling authorize().
  Uri? generateLogoutUrl() {
    return credential?.generateLogoutUrl();
  }

  String _userInfoToEncodedString(UserInfo userInfo) {
    final Map<String, dynamic> jsonMap = userInfo.toJson();
    return jsonEncode(jsonMap);
  }
}
