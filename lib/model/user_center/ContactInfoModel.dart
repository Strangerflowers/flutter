class ContactInfoModel {
  int id;
  String userId;
  String contactName;
  String mobile;
  String email;
  String fax;
  String areaCode;
  String address;
  int defaultContact;
  String createTime;
  String createBy;
  String updateTime;
  String updateBy;
  int delFlag;

  ContactInfoModel(
      {this.id,
      this.userId,
      this.contactName,
      this.mobile,
      this.email,
      this.fax,
      this.areaCode,
      this.address,
      this.defaultContact,
      this.createTime,
      this.createBy,
      this.updateTime,
      this.updateBy,
      this.delFlag});

  ContactInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    contactName = json['contactName'];
    mobile = json['mobile'];
    email = json['email'];
    fax = json['fax'];
    areaCode = json['areaCode'];
    address = json['address'];
    defaultContact = json['defaultContact'];
    createTime = json['createTime'];
    createBy = json['createBy'];
    updateTime = json['updateTime'];
    updateBy = json['updateBy'];
    delFlag = json['delFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['contactName'] = this.contactName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['fax'] = this.fax;
    data['areaCode'] = this.areaCode;
    data['address'] = this.address;
    data['defaultContact'] = this.defaultContact;
    data['createTime'] = this.createTime;
    data['createBy'] = this.createBy;
    data['updateTime'] = this.updateTime;
    data['updateBy'] = this.updateBy;
    data['delFlag'] = this.delFlag;
    return data;
  }
}