class DemandDetailHome {
  int code;
  bool success;
  String message;
  DemandDetailResult result;
  int timestamp;

  DemandDetailHome(
      {this.code, this.success, this.message, this.result, this.timestamp});

  DemandDetailHome.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new DemandDetailResult.fromJson(json['result'])
        : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class DemandDetailResult {
  int id;
  String orgId;
  String orgName;
  int isQuotationMerchant;
  String quotationId;
  String name;
  Null announceTime;
  String linkPhone;
  String linkPerson;
  String deliveryDate;
  Null status;
  String remark;
  String createTime;
  Null demandDetailDtoList;
  Null categoryMap;
  List<DemandSkuDtoList> demandSkuDtoList;

  DemandDetailResult(
      {this.id,
      this.orgId,
      this.orgName,
      this.isQuotationMerchant,
      this.quotationId,
      this.name,
      this.announceTime,
      this.linkPhone,
      this.linkPerson,
      this.deliveryDate,
      this.status,
      this.remark,
      this.createTime,
      this.demandDetailDtoList,
      this.categoryMap,
      this.demandSkuDtoList});

  DemandDetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    isQuotationMerchant = json['isQuotationMerchant'];
    quotationId = json['quotationId'].toString();
    name = json['name'];
    announceTime = json['announceTime'];
    linkPhone = json['linkPhone'];
    linkPerson = json['linkPerson'];
    deliveryDate = json['deliveryDate'];
    status = json['status'];
    remark = json['remark'];
    createTime = json['createTime'];
    demandDetailDtoList = json['demandDetailDtoList'];
    categoryMap = json['categoryMap'];
    if (json['demandSkuDtoList'] != null) {
      demandSkuDtoList = new List<DemandSkuDtoList>();
      json['demandSkuDtoList'].forEach((v) {
        demandSkuDtoList.add(new DemandSkuDtoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['isQuotationMerchant'] = this.isQuotationMerchant;
    data['quotationId'] = this.quotationId;
    data['name'] = this.name;
    data['announceTime'] = this.announceTime;
    data['linkPhone'] = this.linkPhone;
    data['linkPerson'] = this.linkPerson;
    data['deliveryDate'] = this.deliveryDate;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['createTime'] = this.createTime;
    data['demandDetailDtoList'] = this.demandDetailDtoList;
    data['categoryMap'] = this.categoryMap;
    if (this.demandSkuDtoList != null) {
      data['demandSkuDtoList'] =
          this.demandSkuDtoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DemandSkuDtoList {
  int productCategroyId;
  bool checkBoxFlag;
  String productCategroyPath;
  List<DemandDetailDtoList> demandDetailDtoList;

  DemandSkuDtoList(
      {this.productCategroyId,
      this.checkBoxFlag,
      this.productCategroyPath,
      this.demandDetailDtoList});

  DemandSkuDtoList.fromJson(Map<String, dynamic> json) {
    productCategroyId = json['productCategroyId'];
    checkBoxFlag = json['checkBoxFlag'];
    productCategroyPath = json['productCategroyPath'];
    if (json['demandDetailDtoList'] != null) {
      demandDetailDtoList = new List<DemandDetailDtoList>();
      json['demandDetailDtoList'].forEach((v) {
        demandDetailDtoList.add(new DemandDetailDtoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCategroyId'] = this.productCategroyId;
    data['checkBoxFlag'] = this.checkBoxFlag;
    data['productCategroyPath'] = this.productCategroyPath;
    if (this.demandDetailDtoList != null) {
      data['demandDetailDtoList'] =
          this.demandDetailDtoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DemandDetailDtoList {
  int id;
  int demandId;
  int productCategroyId;
  bool checkBoxFlag;
  String productCategroyPath;
  String productDescript;
  List<Object> subjectItemList;
  List<Object> specificationList;
  int specificaId;
  double goodsPrice;
  int num;
  int typeId;
  String type;
  int isQuotation;
  Null createBy;
  Null createTime;
  Null updateBy;
  Null updateTime;

  DemandDetailDtoList(
      {this.id,
      this.demandId,
      this.productCategroyId,
      this.checkBoxFlag,
      this.productCategroyPath,
      this.productDescript,
      this.subjectItemList,
      this.specificationList,
      this.specificaId,
      this.goodsPrice,
      this.num,
      this.typeId,
      this.type,
      this.isQuotation,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime});

  DemandDetailDtoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    demandId = json['demandId'];
    productCategroyId = json['productCategroyId'];
    checkBoxFlag = json['checkBoxFlag'];
    productCategroyPath = json['productCategroyPath'];
    productDescript = json['productDescript'];
    subjectItemList = json['subjectItemList'];
    specificationList = json['specificationList'];
    specificaId = json['specificaId'];
    goodsPrice = json['goodsPrice'];
    // subjectItemList
    num = json['num'];
    typeId = json['typeId'];
    type = json['type'];
    isQuotation = json['isQuotation'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['demandId'] = this.demandId;
    data['productCategroyId'] = this.productCategroyId;
    data['checkBoxFlag'] = this.checkBoxFlag;
    data['productCategroyPath'] = this.productCategroyPath;
    data['productDescript'] = this.productDescript;
    data['subjectItemList'] = this.subjectItemList;
    data['specificationList'] = this.specificationList;
    data['specificaId'] = this.specificaId;
    data['goodsPrice'] = this.goodsPrice;
    // subjectItemList
    data['num'] = this.num;
    data['typeId'] = this.typeId;
    data['type'] = this.type;
    data['isQuotation'] = this.isQuotation;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    return data;
  }
}
