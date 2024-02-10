import 'package:azure_silent_auth/storage/default_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StorageOperations', () {
    late DefaultStorage storageOperations;

    // Initialize storage with mock values for testing
    setUp(() {
      const storage = FlutterSecureStorage();
      FlutterSecureStorage.setMockInitialValues({});
      storageOperations = DefaultStorage(storage: storage);
    });

    test('isTokenSavedLocally', () async {
      // Test when token is not saved
      expect(await storageOperations.isTokenSavedLocally(), false);

      // Save token
      await storageOperations.setTokenResponse('dummyToken');

      // Test when token is saved
      expect(await storageOperations.isTokenSavedLocally(), true);
    });

    test('setTokenResponse and readTokenResponse', () async {
      // Save token
      await storageOperations.setTokenResponse('dummyToken');

      // Read saved token
      final token = await storageOperations.readTokenResponse();
      expect(token, 'dummyToken');
    });

    test('deleteToken', () async {
      // Save token
      await storageOperations.setTokenResponse('dummyToken');

      // Delete token
      await storageOperations.deleteToken();

      // Test if token is deleted
      expect(await storageOperations.isTokenSavedLocally(), false);
    });

    test('setUserInfo and getUserInfo', () async {
      // Set user info
      await storageOperations.setUserInfo('John Doe');

      // Get user info
      final userInfo = await storageOperations.getUserInfo();

      // Test if user info is correct
      expect(userInfo, 'John Doe');
    });

    test('deleteUserName', () async {
      // Set user info
      await storageOperations.setUserInfo('John Doe');

      // Delete user info
      await storageOperations.deleteUserName();

      // Test if user info is deleted
      expect(await storageOperations.getUserInfo(), isNull);
    });
  });
}
