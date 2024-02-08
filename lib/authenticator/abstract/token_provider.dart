// Abstract class defining the contract for an token provider.
abstract class TokenProvider {
  /// Retrieves the access token.
  Future<String?> getAccessToken();
}
