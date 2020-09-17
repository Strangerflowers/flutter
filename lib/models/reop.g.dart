// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reop _$ReopFromJson(Map<String, dynamic> json) {
  return Reop()
    ..id = json['id'] as num
    ..userId = json['userId'] as String
    ..companyPortalId = json['companyPortalId'] as String
    ..subjectMgrInfoId = json['subjectMgrInfoId'] as String
    ..loginAccount = json['loginAccount'] as String
    ..auditStatus = json['auditStatus'] as num
    ..account = json['account'] as String
    ..companyName = json['companyName'] as String
    ..companyShort = json['companyShort'] as String
    ..companyNum = json['companyNum'] as String
    ..companyCode = json['companyCode'] as String
    ..companyDistrictName = json['companyDistrictName'] as String
    ..companyDetailAddr = json['companyDetailAddr'] as String
    ..companyMobile = json['companyMobile'] as String
    ..companyTelephone = json['companyTelephone'] as String
    ..supplierType = json['supplierType'] as String
    ..supplierTypeName = json['supplierTypeName'] as String
    ..businessLicenseIssuedKey = json['businessLicenseIssuedKey'] as String
    ..businessLicenseIssuedRegistrationMark =
        json['businessLicenseIssuedRegistrationMark'] as String
    ..businessLicenseIssuedUrl = json['businessLicenseIssuedUrl'] as String
    ..socialCreditCode = json['socialCreditCode'] as String
    ..businessScope = json['businessScope'] as String
    ..bank = json['bank'] as String
    ..contactName = json['contactName'] as String
    ..contactMobile = json['contactMobile'] as String
    ..status = json['status'] as num
    ..isUpload = json['isUpload'] as String
    ..isInspect = json['isInspect'] as num
    ..inspectPicKey = json['inspectPicKey'] as String
    ..contactsDtoList = json['contactsDtoList'] as String;
}

Map<String, dynamic> _$ReopToJson(Reop instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'companyPortalId': instance.companyPortalId,
      'subjectMgrInfoId': instance.subjectMgrInfoId,
      'loginAccount': instance.loginAccount,
      'auditStatus': instance.auditStatus,
      'account': instance.account,
      'companyName': instance.companyName,
      'companyShort': instance.companyShort,
      'companyNum': instance.companyNum,
      'companyCode': instance.companyCode,
      'companyDistrictName': instance.companyDistrictName,
      'companyDetailAddr': instance.companyDetailAddr,
      'companyMobile': instance.companyMobile,
      'companyTelephone': instance.companyTelephone,
      'supplierType': instance.supplierType,
      'supplierTypeName': instance.supplierTypeName,
      'businessLicenseIssuedKey': instance.businessLicenseIssuedKey,
      'businessLicenseIssuedRegistrationMark':
          instance.businessLicenseIssuedRegistrationMark,
      'businessLicenseIssuedUrl': instance.businessLicenseIssuedUrl,
      'socialCreditCode': instance.socialCreditCode,
      'businessScope': instance.businessScope,
      'bank': instance.bank,
      'contactName': instance.contactName,
      'contactMobile': instance.contactMobile,
      'status': instance.status,
      'isUpload': instance.isUpload,
      'isInspect': instance.isInspect,
      'inspectPicKey': instance.inspectPicKey,
      'contactsDtoList': instance.contactsDtoList
    };
