// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WithdrawAddressModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawAddressModel _$WithdrawAddressModelFromJson(Map<String, dynamic> json) {
  return WithdrawAddressModel(
      id: json['id'] as num,
      userId: json['userId'] as String,
      receiverName: json['receiverName'] as String,
      mobile: json['mobile'] as String,
      areaCode: json['areaCode'] as String,
      address: json['address'] as String,
      defaultAddress: json['defaultAddress'] as num,
      status: json['status'] as num,
      createTime: json['createTime'] as String,
      createBy: json['createBy'] as String,
      updateTime: json['updateTime'] as String,
      updateBy: json['updateBy'] as String,
      delFlag: json['delFlag'] as num);
}

Map<String, dynamic> _$WithdrawAddressModelToJson(
        WithdrawAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'receiverName': instance.receiverName,
      'mobile': instance.mobile,
      'areaCode': instance.areaCode,
      'address': instance.address,
      'defaultAddress': instance.defaultAddress,
      'status': instance.status,
      'createTime': instance.createTime,
      'createBy': instance.createBy,
      'updateTime': instance.updateTime,
      'updateBy': instance.updateBy,
      'delFlag': instance.delFlag
    };
