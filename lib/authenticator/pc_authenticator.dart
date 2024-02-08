import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:azure_silent_auth/authenticator/abstract/authenticator_provider.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:path_provider/path_provider.dart';

/// PC(Windows/Mac) specific implementation of the AuthenticatorProvider.
///
/// This class creates a WebView window that opens the login page, providing a solution
/// to the issue where PC users, after authentication, are not redirected back to
/// their Flutter application. The WebView window is used instead of opening the login
/// page in the default browser.
class PCAuthenticator extends AuthenticatorProvider {
  final String _issuerUrl;
  final List<String> _scopes;
  final String _clientId;
  final String _query;
  final int _port;
  Webview? _webview;

  /// Constructor to initialize the PCAuthenticator instance.
  ///
  /// Parameters:
  /// - `_issuerUrl`: The URL of the OpenID Connect issuer.
  /// - `_scopes`: The list of requested scopes during the authorization process.
  /// - `_clientId`: The client ID used for authentication.
  /// - `_query`: Additional query parameters for the authorization URL.
  /// - `_port`: The port number to use during the authorization process.

  PCAuthenticator(
    this._issuerUrl,
    this._scopes,
    this._clientId,
    this._query,
    this._port,
  );

  /// Initiates the authorization process using a WebView window.
  ///
  /// Throws an error if WebView runtime is not available on the current device.
  ///
  /// The authorization process involves discovering the OpenID Connect issuer,
  /// creating a client, launching a WebView window, and obtaining credentials.

  @override
  Future<void> authorize({
    String? tokenResponseString,
  }) async {
    bool isWebviewAvailable = await WebviewWindow.isWebviewAvailable();
    if (isWebviewAvailable == false) {
      throw 'WebView runtime is available on the current devices';
    }

    final issuer = await Issuer.discover(Uri.parse('$_issuerUrl/v2.0'));
    final client = Client(issuer, _clientId);

    urlLauncher(String urlString) async {
      var url = '$urlString$_query';
      _webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowHeight: 500,
          windowWidth: 500,
          title: "Authentication",
          userDataFolderWindows: await getWebViewPath(),
        ),
      );
      _webview?.launch(url);
      return _webview;
    }

    Authenticator authenticator = Authenticator(
      client,
      scopes: _scopes,
      port: _port,
      urlLancher: urlLauncher,
    );

    credential = await authenticator.authorize();
  }

  /// Retrieves the path for the WebView userDataFolder on PC.
  ///
  /// Returns the path where the WebView stores its data.
  Future<String> getWebViewPath() async {
    final document = await getApplicationDocumentsDirectory();
    return document.path;
  }

  /// Closes the WebView window.
  ///
  /// This method is called to close the WebView window after the authorization process is complete.
  @override
  void close() {
    _webview?.close();
  }
}
