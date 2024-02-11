part of '../../model.dart';

/// This class maps data from `OpenIdClaims` in `openid_client` package.
/// This step is for the users to avoid adding another dependency directly to
/// their application and maintain it.
class User {
  final String subject;
  final String? name;
  final String? givenName;
  final String? familyName;
  final String? middleName;
  final String? nickname;
  final String? preferredUsername;
  final Uri? profile;
  final Uri? picture;
  final Uri? website;
  final String? email;
  final bool? emailVerified;
  final String? gender;
  final String? birthdate;
  final String? zoneinfo;
  final String? locale;
  final String? phoneNumber;
  final bool? phoneNumberVerified;
  final String? formattedAddress;
  final String? streetAddress;
  final String? locality;
  final String? region;
  final String? postalCode;
  final String? country;
  final DateTime? updatedAt;

  User({
    required this.subject,
    this.name,
    this.givenName,
    this.familyName,
    this.middleName,
    this.nickname,
    this.preferredUsername,
    this.profile,
    this.picture,
    this.website,
    this.email,
    this.emailVerified,
    this.gender,
    this.birthdate,
    this.zoneinfo,
    this.locale,
    this.phoneNumber,
    this.phoneNumberVerified,
    this.formattedAddress,
    this.streetAddress,
    this.locality,
    this.region,
    this.postalCode,
    this.country,
    this.updatedAt,
  });

  factory User.fromUserInfo(UserInfo userInfo) {
    return User(
      subject: userInfo.subject,
      name: userInfo.name,
      givenName: userInfo.givenName,
      familyName: userInfo.familyName,
      middleName: userInfo.middleName,
      nickname: userInfo.nickname,
      preferredUsername: userInfo.preferredUsername,
      profile: userInfo.profile,
      picture: userInfo.picture,
      website: userInfo.website,
      email: userInfo.email,
      emailVerified: userInfo.emailVerified,
      gender: userInfo.gender,
      birthdate: userInfo.birthdate,
      zoneinfo: userInfo.zoneinfo,
      locale: userInfo.locale,
      phoneNumber: userInfo.phoneNumber,
      phoneNumberVerified: userInfo.phoneNumberVerified,
      formattedAddress:
          (userInfo.address != null) ? userInfo.address!.formatted : null,
      streetAddress:
          (userInfo.address != null) ? userInfo.address!.streetAddress : null,
      locality: (userInfo.address != null) ? userInfo.address!.locality : null,
      region: (userInfo.address != null) ? userInfo.address!.region : null,
      postalCode:
          (userInfo.address != null) ? userInfo.address!.postalCode : null,
      country: (userInfo.address != null) ? userInfo.address!.country : null,
      updatedAt: userInfo.updatedAt,
    );
  }
}
