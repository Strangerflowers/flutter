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
  String name;
  Null announceTime;
  String linkPhone;
  String linkPerson;
  String deliveryDate;
  Null status;
  String createTime;
  List<DemandDetailDtoList> demandDetailDtoList;
  CategoryMap categoryMap;

  DemandDetailResult(
      {this.id,
      this.orgId,
      this.orgName,
      this.name,
      this.announceTime,
      this.linkPhone,
      this.linkPerson,
      this.deliveryDate,
      this.status,
      this.createTime,
      this.demandDetailDtoList,
      this.categoryMap});

  DemandDetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    name = json['name'];
    announceTime = json['announceTime'];
    linkPhone = json['linkPhone'];
    linkPerson = json['linkPerson'];
    deliveryDate = json['deliveryDate'];
    status = json['status'];
    createTime = json['createTime'];
    if (json['demandDetailDtoList'] != null) {
      demandDetailDtoList = new List<DemandDetailDtoList>();
      json['demandDetailDtoList'].forEach((v) {
        demandDetailDtoList.add(new DemandDetailDtoList.fromJson(v));
      });
    }
    categoryMap = json['categoryMap'] != null
        ? new CategoryMap.fromJson(json['categoryMap'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['name'] = this.name;
    data['announceTime'] = this.announceTime;
    data['linkPhone'] = this.linkPhone;
    data['linkPerson'] = this.linkPerson;
    data['deliveryDate'] = this.deliveryDate;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    if (this.demandDetailDtoList != null) {
      data['demandDetailDtoList'] =
          this.demandDetailDtoList.map((v) => v.toJson()).toList();
    }
    if (this.categoryMap != null) {
      data['categoryMap'] = this.categoryMap.toJson();
    }
    return data;
  }
}

class DemandDetailDtoList {
  int id;
  Null demandId;
  String productCategroyId;
  String productCategroyPath;
  String productDescript;
  int num;
  int typeId;
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
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class CategoryMap {
  // String s2464;
  // String s2472;

  CategoryMap();

  CategoryMap.fromJson(Map<String, dynamic> json) {
    // s2464 = json['2464'];
    // s2472 = json['2472'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['2464'] = this.s2464;
    // data['2472'] = this.s2472;
    return data;
  }
}
