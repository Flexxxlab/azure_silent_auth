import 'package:openid_client/openid_client.dart';
import 'dart:io';
import 'dart:convert';

class CredentialTestHelper {
  File _file(String path) {
    return File(
        '${Directory.current.path.endsWith('test') ? '' : 'test/'}$path');
  }

  Future<dynamic> _readJson(String path) async =>
      json.decode(await _file(path).readAsString());

  Future<Client> mockClient() async {
    var configJson = await _readJson('mock/openid-configuration.json');
    var jwksContent = File(configJson['jwks_uri']).readAsStringSync();
    configJson['jwks_uri'] = Uri.dataFromString(jwksContent).toString();
    var issuer = Issuer(OpenIdProviderMetadata.fromJson(configJson));
    return Client(issuer, 'openid_client');
  }

  Future<Credential> mockCredential() async {
    var client = await mockClient();
    return client.createCredential(
        idToken:
            'eyJhbGciOiJSUzI1NiIsImtpZCI6InRlc3QxMjM0In0.eyJpc3MiOiJodHRwczovL29wZW5pZF9jbGllbnQuYXBwc3VwLmJlIiwiYXVkIjoib3BlbmlkX2NsaWVudCIsImF1dGhfdGltZSI6MTUxNjc5Mjc0OCwidXNlcl9pZCI6InhvMW5FNTAxd1BXRzFWUVlsMlJnbnFXaTdKZDIiLCJzdWIiOiJ4bzFuRTUwMXdQV0cxVlFZbDJSZ25xV2k3SmQyIiwiaWF0IjoxNTIyNjE2MDU1LCJleHAiOjE1MjI2MTk2NTV9.weRqNkFvrcgZ1TAZe0gLw7hKXAcEysntcdUJhLfiokFcApte2bMqnIGYxVINaBxc4Cvy1zwY7esBD8KKe7I2Xno57xN1Onbp5r_1Hj-hXM5ommGzLjcZOqGvmjHX_apoOnKhs2YJD06NBaaBE4Z2p7WudhQFBpfVmyH2fBaPFhpjAIoEy2-M3OsyqeXWBcIww7aMgpgK55_k98X5QdeGpVwXbIW4jZd7jXt5Kbr22NyvXQTQcg-omYw3EQ1zvONkRssX9P9MZThfGETNVNy2YHXBKDCo47vcZZhbF2ospe8W8VYdG0LFRBspyqorerlDun3oFWNB0llmYldfwuMAx64G8-SfevxrZjqVhaSOiWtvX_UcHI1puIVQC9kCI6rhU5jm6kqcEaOp5ge1hKctQejKXJnXPQcJ3OeA5-pojvibN_DksSkZhs006Fy6p_osAusSaKJzMYX7IYlJaF_SaaIe0VEhq0e1oWsuGyZYQROxedvQxTLuaE1BUn5SKhBO8YBWt9cHT1NbN2XeAU3PMHQ-lcz3NgSllR5AX0xQuwqMYGXbeQagiYdRDQKdYWYIEuayLCbmC3PsSR0KUVmgRBXxWipJMDRNWNxwqqNq4xdJpcI0NvCp1nnM1DHkVjV8mxAg7ItiBnIdDHZtkkVJ6mdqi7hGiXjJRdoCJDkvzfs');
  }
}
