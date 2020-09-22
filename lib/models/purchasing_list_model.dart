class Purchasing {
  int code;
  bool success;
  String message;
  PurchasingResult result;
  int timestamp;

  Purchasing(
      {this.code, this.success, this.message, this.result, this.timestamp});

  Purchasing.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new PurchasingResult.fromJson(json['result'])
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

class PurchasingResult {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<PurchasingList> list;

  PurchasingResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  PurchasingResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<PurchasingList>();
      json['list'].forEach((v) {
        list.add(new PurchasingList.fromJson(v));
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

class PurchasingList {
  int id;
  String orgId;
  String orgName;
  String name;
  String announceTime;
  String announceTimeStr;
  String linkPhone;
  String linkPerson;
  String deliveryDate;
  String deliveryDateStr;
  Null status;
  String createTime;
  List<DemandDetailDtoList> demandDetailDtoList;
  Map categoryMap;
  Null demandSkuDtoList;

  PurchasingList(
      {this.id,
      this.orgId,
      this.orgName,
      this.name,
      this.announceTime,
      this.announceTimeStr,
      this.linkPhone,
      this.linkPerson,
      this.deliveryDate,
      this.deliveryDateStr,
      this.status,
      this.createTime,
      this.demandDetailDtoList,
      this.categoryMap,
      this.demandSkuDtoList});

  PurchasingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    name = json['name'];
    announceTime = json['announceTime'];
    announceTimeStr = json['announceTimeStr'];
    linkPhone = json['linkPhone'];
    linkPerson = json['linkPerson'];
    deliveryDate = json['deliveryDate'];
    deliveryDateStr = json['deliveryDateStr'];
    status = json['status'];
    createTime = json['createTime'];
    if (json['demandDetailDtoList'] != null) {
      demandDetailDtoList = new List<DemandDetailDtoList>();
      json['demandDetailDtoList'].forEach((v) {
        demandDetailDtoList.add(new DemandDetailDtoList.fromJson(v));
      });
    }
    categoryMap = json['categoryMap'];
    // ? new Map.fromJson(json['categoryMap'])
    // : null;
    demandSkuDtoList = json['demandSkuDtoList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['name'] = this.name;
    data['announceTime'] = this.announceTime;
    data['announceTimeStr'] = this.announceTimeStr;
    data['linkPhone'] = this.linkPhone;
    data['linkPerson'] = this.linkPerson;
    data['deliveryDate'] = this.deliveryDate;
    data['deliveryDateStr'] = this.deliveryDateStr;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    if (this.demandDetailDtoList != null) {
      data['demandDetailDtoList'] =
          this.demandDetailDtoList.map((v) => v.toJson()).toList();
    }
    if (this.categoryMap != null) {
      data['categoryMap'] = this.categoryMap;
    }
    data['demandSkuDtoList'] = this.demandSkuDtoList;
    return data;
  }
}

class DemandDetailDtoList {
  int id;
  Null demandId;
  int productCategroyId;
  String productCategroyPath;
  String productDescript;
  int num;
  int typeId;
  Null isQuotation;
  Null createBy;
  Null createTime;
  Null updateBy;
  Null updateTime;

  DemandDetailDtoList(
      {this.id,
      this.demandId,
      this.productCategroyId,
      this.productCategroyPath,
      this.productDescript,
      this.num,
      this.typeId,
      this.isQuotation,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime});

  DemandDetailDtoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    demandId = json['demandId'];
    productCategroyId = json['productCategroyId'];
    productCategroyPath = json['productCategroyPath'];
    productDescript = json['productDescript'];
    num = json['num'];
    typeId = json['typeId'];
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
    data['productCategroyPath'] = this.productCategroyPath;
    data['productDescript'] = this.productDescript;
    data['num'] = this.num;
    data['typeId'] = this.typeId;
    data['isQuotation'] = this.isQuotation;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

// class CategoryMap {
//   // String s2464;
//   // String s2472;

//   // CategoryMap({this.s2464, this.s2472});

//   // CategoryMap.fromJson(Map<String, dynamic> json) {
//   //   s2464 = json['2464'];
//   //   s2472 = json['2472'];
//   // }

//   // Map<String, dynamic> toJson() {
//   //   final Map<String, dynamic> data = new Map<String, dynamic>();
//   //   data['2464'] = this.s2464;
//   //   data['2472'] = this.s2472;
//   //   return data;
//   // }
// }
