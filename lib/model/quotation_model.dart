class QuotationHome {
  int code;
  bool success;
  String message;
  QuotationHomeResult result;
  int timestamp;

  QuotationHome(
      {this.code, this.success, this.message, this.result, this.timestamp});

  QuotationHome.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new QuotationHomeResult.fromJson(json['result'])
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

class QuotationHomeResult {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<QuotationHomeList> list;

  QuotationHomeResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  QuotationHomeResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<QuotationHomeList>();
      json['list'].forEach((v) {
        list.add(new QuotationHomeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['currPage'] = this.currPage;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuotationHomeList {
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
  int categoryNum;
  int total;
  int status;
  List<QuotationHomeDetailList> detailList;

  QuotationHomeList(
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

  QuotationHomeList.fromJson(Map<String, dynamic> json) {
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
    totalAmount = json['totalAmount'].toString(); ////这里强制转换为String 统一接受即可
    remark = json['remark'];
    categoryNum = json['categoryNum'];
    total = json['total'];
    status = json['status'];
    if (json['detailList'] != null) {
      detailList = new List<QuotationHomeDetailList>();
      json['detailList'].forEach((v) {
        detailList.add(new QuotationHomeDetailList.fromJson(v));
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

class QuotationHomeDetailList {
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
  String amount;
  int num;
  int typeId;
  String typeName;
  int status;

  QuotationHomeDetailList(
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

  QuotationHomeDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotationId'];
    demandDetailId = json['demandDetailId'];
    productCategroyName = json['productCategroyName'].toString();
    productCategroyId = json['productCategroyId'].toString();
    productDescript = json['productDescript'];
    skuId = json['skuId'];
    skuKey = json['skuKey'];
    skuUrl = json['skuUrl'];
    skuValueList = json['skuValueList'];
    skuName = json['skuName'].toString();
    amount = json['amount'].toString();
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
