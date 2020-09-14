// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..token = json['token'] as String
    ..theme = json['theme'] as num
    ..auditStatusStatus = json['auditStatusStatus'] == null
        ? null
        : Reop.fromJson(json['auditStatusStatus'] as Map<String, dynamic>)
    ..auditStatus = json['auditStatus'] as num
    ..lastLogin = json['lastLogin'] as String
    ..locale = json['locale'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'theme': instance.theme,
      'auditStatusStatus': instance.auditStatusStatus,
      'auditStatus': instance.auditStatus,
      'lastLogin': instance.lastLogin,
      'locale': instance.locale
    };
