class QuotationDetail {
  int code;
  bool success;
  String message;
  DetailResult result;
  int timestamp;

  QuotationDetail(
      {this.code, this.success, this.message, this.result, this.timestamp});

  QuotationDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new DetailResult.fromJson(json['result'])
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

class DetailResult {
  int id;
  String code;
  int demandId;
  String orgId;
  String orgName;
  String demandName;
  String merchantId;
  String merchantName;
  String linkPerson;
  String linkPhone;
  String totalAmount;
  String remark;
  String categoryNum;
  int total;
  int status;
  List<DetailList> detailList;

  DetailResult(
      {this.id,
      this.code,
      this.demandId,
      this.orgId,
      this.orgName,
      this.demandName,
      this.merchantId,
      this.merchantName,
      this.linkPerson,
      this.linkPhone,
      this.totalAmount,
      this.remark,
      this.categoryNum,
      this.total,
      this.status,
      this.detailList});

  DetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    demandId = json['demandId'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    demandName = json['demandName'];
    merchantId = json['merchantId'].toString();
    merchantName = json['merchantName'].toString();
    linkPerson = json['linkPerson'];
    linkPhone = json['linkPhone'];
    totalAmount = json['totalAmount'].toString();
    remark = json['remark'];
    categoryNum = json['categoryNum'].toString();
    total = json['total'];
    status = json['status'];
    if (json['detailList'] != null) {
      detailList = new List<DetailList>();
      json['detailList'].forEach((v) {
        detailList.add(new DetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['demandId'] = this.demandId;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['demandName'] = this.demandName;
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['linkPerson'] = this.linkPerson;
    data['linkPhone'] = this.linkPhone;
    data['totalAmount'] = this.totalAmount;
    data['remark'] = this.remark;
    data['categoryNum'] = this.categoryNum;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.detailList != null) {
      data['detailList'] = this.detailList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailList {
  int id;
  int quotationId;
  int demandDetailId;
  String productCategroyName;
  String productCategroyId;
  String productDescript;
  int skuId;
  String skuKey;
  String skuUrl;
  List skuValueList;
  String skuName;
  double amount;
  int num;
  int typeId;
  String typeName;
  int status;

  DetailList(
      {this.id,
      this.quotationId,
      this.demandDetailId,
      this.productCategroyName,
      this.productCategroyId,
      this.productDescript,
      this.skuId,
      this.skuKey,
      this.skuUrl,
      this.skuValueList,
      this.skuName,
      this.amount,
      this.num,
      this.typeId,
      this.typeName,
      this.status});

  DetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotationId'];
    demandDetailId = json['demandDetailId'];
    productCategroyName = json['productCategroyName'].toString();
    productCategroyId = json['productCategroyId'].toString();
    productDescript = json['productDescript'];
    skuId = json['skuId'];
    skuKey = json['skuKey'].toString();
    skuUrl = json['skuUrl'];
    skuValueList = json['skuValueList'];
    skuName = json['skuName'].toString();
    amount = json['amount'];
    num = json['num'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotationId'] = this.quotationId;
    data['demandDetailId'] = this.demandDetailId;
    data['productCategroyName'] = this.productCategroyName;
    data['productCategroyId'] = this.productCategroyId;
    data['productDescript'] = this.productDescript;
    data['skuId'] = this.skuId;
    data['skuKey'] = this.skuKey;
    data['skuUrl'] = this.skuUrl;
    data['skuValueList'] = this.skuValueList;
    data['skuName'] = this.skuName;
    data['amount'] = this.amount;
    data['num'] = this.num;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['status'] = this.status;
    return data;
  }
}
