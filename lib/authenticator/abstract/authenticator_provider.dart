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

  /// Retrieves the user name obtained during the authorization process.
  ///
  /// Note: Do not call this method before calling authorize().
  String? getUserName() {
    return credential?.idToken.claims.name;
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
}

// TO-DO
// handle when and why the credentials is null.
// what if the user calls this method before authorize.
// can i create credentials without authorize and with just saved token?
// is our refresh even needed?   _credential?.getTokenResponse(); seems to handle refresh in on itself.
// Future<String> refreshToken(String refreshToken);
