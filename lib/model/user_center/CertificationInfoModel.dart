class CertificationInfoModel {
  int id;
  Null userId;
  String companyPortalId;
  Null subjectMgrInfoId;
  Null loginAccount;
  int auditStatus;
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
  int status;
  Null isUpload;
  Null contactsDtoList;

  CertificationInfoModel(
      {this.id,
      this.userId,
      this.companyPortalId,
      this.subjectMgrInfoId,
      this.loginAccount,
      this.auditStatus,
      this.account,
      this.companyName,
      this.companyShort,
      this.companyNum,
      this.companyCode,
      this.companyDistrictName,
      this.companyDetailAddr,
      this.companyMobile,
      this.companyTelephone,
      this.supplierType,
      this.supplierTypeName,
      this.businessLicenseIssuedKey,
      this.businessLicenseIssuedRegistrationMark,
      this.businessLicenseIssuedUrl,
      this.socialCreditCode,
      this.businessScope,
      this.bank,
      this.contactName,
      this.contactMobile,
      this.status,
      this.isUpload,
      this.contactsDtoList});

  CertificationInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    companyPortalId = json['companyPortalId'];
    subjectMgrInfoId = json['subjectMgrInfoId'];
    loginAccount = json['loginAccount'];
    auditStatus = json['auditStatus'];
    account = json['account'];
    companyName = json['companyName'];
    companyShort = json['companyShort'];
    companyNum = json['companyNum'];
    companyCode = json['companyCode'];
    companyDistrictName = json['companyDistrictName'];
    companyDetailAddr = json['companyDetailAddr'];
    companyMobile = json['companyMobile'];
    companyTelephone = json['companyTelephone'];
    supplierType = json['supplierType'];
    supplierTypeName = json['supplierTypeName'];
    businessLicenseIssuedKey = json['businessLicenseIssuedKey'];
    businessLicenseIssuedRegistrationMark =
        json['businessLicenseIssuedRegistrationMark'];
    businessLicenseIssuedUrl = json['businessLicenseIssuedUrl'];
    socialCreditCode = json['socialCreditCode'];
    businessScope = json['businessScope'];
    bank = json['bank'];
    contactName = json['contactName'];
    contactMobile = json['contactMobile'];
    status = json['status'];
    isUpload = json['isUpload'];
    contactsDtoList = json['contactsDtoList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['companyPortalId'] = this.companyPortalId;
    data['subjectMgrInfoId'] = this.subjectMgrInfoId;
    data['loginAccount'] = this.loginAccount;
    data['auditStatus'] = this.auditStatus;
    data['account'] = this.account;
    data['companyName'] = this.companyName;
    data['companyShort'] = this.companyShort;
    data['companyNum'] = this.companyNum;
    data['companyCode'] = this.companyCode;
    data['companyDistrictName'] = this.companyDistrictName;
    data['companyDetailAddr'] = this.companyDetailAddr;
    data['companyMobile'] = this.companyMobile;
    data['companyTelephone'] = this.companyTelephone;
    data['supplierType'] = this.supplierType;
    data['supplierTypeName'] = this.supplierTypeName;
    data['businessLicenseIssuedKey'] = this.businessLicenseIssuedKey;
    data['businessLicenseIssuedRegistrationMark'] =
        this.businessLicenseIssuedRegistrationMark;
    data['businessLicenseIssuedUrl'] = this.businessLicenseIssuedUrl;
    data['socialCreditCode'] = this.socialCreditCode;
    data['businessScope'] = this.businessScope;
    data['bank'] = this.bank;
    data['contactName'] = this.contactName;
    data['contactMobile'] = this.contactMobile;
    data['status'] = this.status;
    data['isUpload'] = this.isUpload;
    data['contactsDtoList'] = this.contactsDtoList;
    return data;
  }
}
