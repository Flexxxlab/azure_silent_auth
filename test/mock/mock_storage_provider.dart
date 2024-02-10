import 'package:azure_silent_auth/storage/abstract/storage_provider.dart';

class MockStorageProvider implements StorageProvider {
  final Map<String, String> data;

  MockStorageProvider(this.data);

  @override
  Future<bool> isTokenSavedLocally() async =>
      data.containsKey('token_response');

  @override
  Future<void> setTokenResponse(String value) async =>
      data['token_response'] = value;

  @override
  Future<String?> readTokenResponse() async => data['token_response'];

  @override
  Future<void> deleteToken() async => data.remove('token_response');

  @override
  Future<void> setUserInfo(String? name) async =>
      data['user_name_from_token'] = name ?? '';

  @override
  Future<String?> getUserInfo() async => data['user_name_from_token'];

  @override
  Future<void> deleteUserName() async => data.remove('user_name_from_token');
}
