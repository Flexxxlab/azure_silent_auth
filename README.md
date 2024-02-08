# Azure Silent Login

A Flutter package for seamless integration with Azure authentication and Silent Login.

## Features

- **Azure Authentication:** Integration with Azure authentication including login, logout, and silent login.
- **Secure Storage:** Securely store and manage tokens and user data.
- **Silent Login:** Provides silent login functionality which saves developers time.
- **Useful for Offline Applications:** Silent login functionality is particularly useful for offline applications where continuous user authentication may not be possible.
- **Token Management:** Automatically manages token expiration and refreshing.

### Explanation:

1. **First-Time Login:**
   - When the user opens the app for the first time, call `AzureAuth->Login()` to open the authentication page.
   - Upon successful login, the token is securely stored.
   
2. **Token Retrieval:**
   - When the app needs the token, call `AzureAuth->getAccessToken()`.
   - The token's validity is checked; if expired, it is automatically refreshed.
   
3. **Silent Login:**
   - Use `AzureAuth->silentLogin()` when the app is opened again.
   - The stored token is validated in the background without redirecting the user to the authentication page.
   - If the token is invalid or expired, an error is thrown, allowing developers to redirect the user to the login screen.
   
4. **Logout:**
   - Call `AzureAuth->logout()` to clear all locally stored token and user data.
   - Sends a request to the OpenID Provider to log out the End-User.

### Documentation

Explore the documentation to learn more.


## Getting started

To use this package, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  azure_silent_auth: ^1.0.0
```

Then, run:

```bash
flutter pub get
```
### Prerequisites

Flutter: Your app should use Flutter framework.
Dart: Your app should use Dart programming language.

### Platform

Tested in Windows and iOS, Should work on Android too.

## Usage

```dart
  AzureAuth _azureAuth = AzureAuth(
    authenticatorProvider: DefaultAuthenticator(
      'https://login.microsoftonline.com/{tenant-id}/',
      ["openId", "offline_access"],
      '{client-id}',
      '&prompt=select_account',
      {nnnn}, // Redirect URI's port in Azure app registration authentication (http://localhost:nnnn/)
    ),
  );
```
Please refer main.dart in the example app to see how this instance can be used in different scenarios.
## Additional information

- Contributions: Contributions are welcome! Open an issue or submit a pull request.
- issues: If you encounter any issues, please feel free to reach out to **Email:** irshad365@gmail.com
