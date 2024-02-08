import 'package:azure_silent_auth/authenticator/abstract/authenticator_provider.dart';
import 'package:azure_silent_auth/azure_silent_auth.dart';
import 'package:azure_silent_auth/storage/abstract/storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock/mock_authenticator_provider.dart';
import 'mock/mock_storage_provider.dart';

void main() {
  group('AzureAuth', () {
    late AzureAuth microsoftLogin;
    late StorageProvider mockStorageProvider;
    late AuthenticatorProvider mockAuthenticatorProvider;
    setUp(() {
      mockStorageProvider = MockStorageProvider({});
      mockAuthenticatorProvider = MockAuthenticatorProvider();

      microsoftLogin = AzureAuth(
        authenticatorProvider: mockAuthenticatorProvider,
        storageProvider: mockStorageProvider,
      );
    });

    test('login - successful', () async {
      // Your AzureAuth login logic
      await microsoftLogin.login();

      // Verifying that MockStorageProvider methods were called as expected
      expect(await mockStorageProvider.isTokenSavedLocally(), true);
      expect(await mockStorageProvider.getUserName(), isNotEmpty);
    });

    test('logout - successful', () async {
      // Your AzureAuth logout logic
      await microsoftLogin.logout();

      // Verifying that MockStorageProvider methods were called as expected
      expect(await mockStorageProvider.isTokenSavedLocally(), false);
      expect(await mockStorageProvider.getUserName(), null);
    });

    test('getAccessToken - isNotNull when loggedin', () async {
      // Your AzureAuth login logic
      await microsoftLogin.login();

      // Verifying that accessToken is not empty
      expect(await microsoftLogin.getAccessToken(), isNotNull);
    });

    test('getAccessToken - isNull when loggedout', () async {
      // Your AzureAuth login logic
      await microsoftLogin.logout();

      // Verifying that accessToken is not empty
      expect(await microsoftLogin.getAccessToken(), isNull);
    });
  });
}
