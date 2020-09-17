import 'package:json_annotation/json_annotation.dart';

part 'reop.g.dart';

@JsonSerializable()
class Reop {
    Reop();

    num id;
    String userId;
    String companyPortalId;
    String subjectMgrInfoId;
    String loginAccount;
    num auditStatus;
    String account;
    String companyName;
    String companyShort;
    String companyNum;
    String companyCode;
    String companyDistrictName;
    String companyDetailAddr;
    String companyMobile;
    String companyTelephone;
    String supplierType;
    String supplierTypeName;
    String businessLicenseIssuedKey;
    String businessLicenseIssuedRegistrationMark;
    String businessLicenseIssuedUrl;
    String socialCreditCode;
    String businessScope;
    String bank;
    String contactName;
    String contactMobile;
    num status;
    String isUpload;
    num isInspect;
    String inspectPicKey;
    String contactsDtoList;
    
    factory Reop.fromJson(Map<String,dynamic> json) => _$ReopFromJson(json);
    Map<String, dynamic> toJson() => _$ReopToJson(this);
}
