import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:azure_silent_auth/authenticator/abstract/authenticator_provider.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

/// Default implementation of AuthenticatorProvider.
class DefaultAuthenticator extends AuthenticatorProvider {
  final String _issuerUrl;
  final List<String> _scopes;
  final String _clientId;
  final String _query;
  final int _port;

  // There is a bug in `url_launcher-6.2.4` which causes app crash
  // if launch mode is `platformDefault` for macOS.
  // if this doesn't works for you, create an appropriate `AuthenticatorProvider`
  // and use it in `AzureAuth`
  final _launchMode = LaunchMode.inAppBrowserView;

  /// Constructor to initialize the DefaultAuthenticator instance.
  ///
  /// Parameters:
  /// - `_issuerUrl`: The URL of the OpenID Connect issuer.
  /// - `_scopes`: The list of requested scopes during the authorization process.
  /// - `_clientId`: The client ID used for authentication.
  /// - `_query`: Additional query parameters for the authorization URL.
  /// - `_port`: The port number to use during the authorization process.
  DefaultAuthenticator(
    this._issuerUrl,
    this._scopes,
    this._clientId,
    this._query,
    this._port,
  );

  /// Initiates the authorization process.
  ///
  /// Discovers the OpenID Connect issuer configuration, creates a client,
  /// and launches the authorization process using the specified URL launcher.
  ///
  /// Throws an error if the authorization URL cannot be launched.
  @override
  Future<void> authorize({
    String? tokenResponseString,
  }) async {
    final issuer = await Issuer.discover(Uri.parse('$_issuerUrl/v2.0'));
    final client = Client(issuer, _clientId);

    if (tokenResponseString == null) {
      urlLauncher(String urlString) async {
        var url = '$urlString$_query';
        var uri = Uri.parse(url);
        if (await canLaunchUrl(uri) || Platform.isAndroid) {
          await launchUrl(uri, mode: _launchMode);
        } else {
          throw 'Could not launch $url';
        }
      }

      Authenticator authenticator = Authenticator(
        client,
        scopes: _scopes,
        port: _port,
        urlLancher: urlLauncher,
      );

      credential = await authenticator.authorize();
    } else {
      credential = fromTokenResponseString(client, tokenResponseString);
    }
  }

  /// Closes any resources or UI related to the authentication process.
  ///
  /// This method is called to close the InAppWebView, if applicable.
  @override
  void close() {
    supportsCloseForLaunchMode(_launchMode).then((value) => {
          if (value) {closeInAppWebView()}
        });
  }

  // Converts String into TokenResponse
  TokenResponse _toObject(String value) {
    final Map<String, dynamic> jsonMap = jsonDecode(value);
    return TokenResponse.fromJson(jsonMap);
  }

  /// Converts tokenResponse String it into Credential
  @visibleForTesting
  Credential fromTokenResponseString(
      Client client, String tokenResponseString) {
    final TokenResponse savedTokenResponse = _toObject(tokenResponseString);
    return client.createCredential(
        accessToken: savedTokenResponse.accessToken,
        tokenType: savedTokenResponse.tokenType,
        refreshToken: savedTokenResponse.refreshToken,
        expiresIn: savedTokenResponse.expiresIn,
        expiresAt: savedTokenResponse.expiresAt,
        idToken: savedTokenResponse.idToken.toCompactSerialization());
  }
}
