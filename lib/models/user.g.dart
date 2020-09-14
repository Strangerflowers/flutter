// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..token = json['token'] as String
    ..userId = json['userId'] as String
    ..loginAcc = json['loginAcc'] as String
    ..expirationTime = json['expirationTime'] as String
    ..userName = json['userName'] as String
    ..mobile = json['mobile'] as String
    ..unionUserId = json['unionUserId'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'loginAcc': instance.loginAcc,
      'expirationTime': instance.expirationTime,
      'userName': instance.userName,
      'mobile': instance.mobile,
      'unionUserId': instance.unionUserId
    };
