import 'package:azure_silent_auth/authenticator/abstract/token_provider.dart';
import 'package:http/http.dart';

/// Custom HTTP client with authentication capabilities.
///
/// This client automatically adds an "Authorization" header with the
/// bearer token obtained from the specified [TokenProvider] to each HTTP request.
class AuthenticatedClient extends BaseClient {
  final Client _inner = Client();
  late final TokenProvider _authenticationProvider;

  /// Constructor to initialize the AuthenticatedClient instance.
  ///
  /// Parameters:
  /// - `_authenticationProvider`: The TokenProvider to obtain the bearer token for authentication.
  AuthenticatedClient(this._authenticationProvider);

  /// Sends an HTTP request with authentication headers.
  ///
  /// Adds the bearer token obtained from the [TokenProvider] to the "Authorization" header.
  /// Throws an exception if the access token is not available.
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var accessToken = await _authenticationProvider.getAccessToken();

    if (accessToken == null) {
      throw Exception('Access token is not available.');
    }

    request.headers['Authorization'] = 'Bearer $accessToken';

    return await _inner.send(request);
  }

  /// Closes the underlying HTTP client.
  ///
  /// This method is called to close the internal HTTP client when it's no longer needed.
  @override
  void close() {
    _inner.close();
  }
}
