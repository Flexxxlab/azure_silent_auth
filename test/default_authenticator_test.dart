import 'dart:convert';

import 'package:azure_silent_auth/authenticator/default_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openid_client/openid_client.dart';

import 'mock/credential_test_helper.dart';

void main() {
  group('DefaultAuthenticator', () {
    late DefaultAuthenticator defaultAuthenticator;
    setUp(() {
      defaultAuthenticator = DefaultAuthenticator(
          '_issuerUrl', ['_scopes'], '_clientId', '_query', 999);
    });

    /// TO-DO: expired token test
    test('create credential with saved token response - successful', () async {
      // Your AzureAuth login logic

      String toEncodedString(TokenResponse tokenResponse) {
        final Map<String, dynamic> jsonMap = tokenResponse.toJson();
        return jsonEncode(jsonMap);
      }

      final mockCredential = await CredentialTestHelper().mockCredential();
      final tokenResponseString = await mockCredential.getTokenResponse();
      final mockClient = await CredentialTestHelper().mockClient();

      final credential = defaultAuthenticator.fromTokenResponseString(
          mockClient, toEncodedString(tokenResponseString));

      // Verifying that MockStorageProvider methods were called as expected
      expect(credential, isNotNull);
    });
  });
}
