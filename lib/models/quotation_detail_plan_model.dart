class QuotationPlan {
  int code;
  bool success;
  String message;
  QuotationPlanResult result;
  int timestamp;

  QuotationPlan(
      {this.code, this.success, this.message, this.result, this.timestamp});

  QuotationPlan.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new QuotationPlanResult.fromJson(json['result'])
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

class QuotationPlanResult {
  String code;
  String orgId;
  String orgName;
  String userName;
  String createBy;
  String companyName;
  String linkPerson;
  String linkPhone;
  String announceTime;
  String name;
  String deliveryDate;
  String remark;
  String approvalKey;
  String categoryNum;
  String total;
  int status;
  List<GroupDetailList> groupDetailList;
  List<PlanDetailList> detailList;

  QuotationPlanResult(
      {this.code,
      this.orgId,
      this.orgName,
      this.userName,
      this.createBy,
      this.companyName,
      this.linkPerson,
      this.linkPhone,
      this.announceTime,
      this.name,
      this.deliveryDate,
      this.remark,
      this.approvalKey,
      this.categoryNum,
      this.total,
      this.status,
      this.groupDetailList,
      this.detailList});

  QuotationPlanResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    orgId = json['orgId'];
    orgName = json['orgName'].toString();
    userName = json['userName'].toString();
    createBy = json['createBy'];
    companyName = json['companyName'].toString();
    linkPerson = json['linkPerson'];
    linkPhone = json['linkPhone'];
    announceTime = json['announceTime'];
    name = json['name'];
    deliveryDate = json['deliveryDate'];
    remark = json['remark'];
    approvalKey = json['approvalKey'];
    categoryNum = json['categoryNum'].toString();
    total = json['total'].toString();
    status = json['status'];
    if (json['groupDetailList'] != null) {
      groupDetailList = new List<GroupDetailList>();
      json['groupDetailList'].forEach((v) {
        groupDetailList.add(new GroupDetailList.fromJson(v));
      });
    }
    if (json['detailList'] != null) {
      detailList = new List<PlanDetailList>();
      json['detailList'].forEach((v) {
        detailList.add(new PlanDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['userName'] = this.userName;
    data['createBy'] = this.createBy;
    data['companyName'] = this.companyName;
    data['linkPerson'] = this.linkPerson;
    data['linkPhone'] = this.linkPhone;
    data['announceTime'] = this.announceTime;
    data['name'] = this.name;
    data['deliveryDate'] = this.deliveryDate;
    data['remark'] = this.remark;
    data['approvalKey'] = this.approvalKey;
    data['categoryNum'] = this.categoryNum;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.groupDetailList != null) {
      data['groupDetailList'] =
          this.groupDetailList.map((v) => v.toJson()).toList();
    }
    if (this.detailList != null) {
      data['detailList'] = this.detailList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupDetailList {
  String productCategroyId;
  String productCategoryName;
  int categoryNum;
  int total;
  List<PlanDetailList> detailList;

  GroupDetailList(
      {this.productCategroyId,
      this.productCategoryName,
      this.categoryNum,
      this.total,
      this.detailList});

  GroupDetailList.fromJson(Map<String, dynamic> json) {
    productCategroyId = json['productCategroyId'].toString();
    productCategoryName = json['productCategoryName'].toString();
    categoryNum = json['categoryNum'];
    total = json['total'];
    if (json['detailList'] != null) {
      detailList = new List<PlanDetailList>();
      json['detailList'].forEach((v) {
        detailList.add(new PlanDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCategroyId'] = this.productCategroyId;
    data['productCategoryName'] = this.productCategoryName;
    data['categoryNum'] = this.categoryNum;
    data['total'] = this.total;
    if (this.detailList != null) {
      data['detailList'] = this.detailList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanDetailList {
  int id;
  String productCategroyId;
  String productCategoryName;
  String productDescript;
  int num;
  int typeId;
  String typeName;

  PlanDetailList(
      {this.id,
      this.productCategroyId,
      this.productCategoryName,
      this.productDescript,
      this.num,
      this.typeId,
      this.typeName});

  PlanDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCategroyId = json['productCategroyId'].toString();
    productCategoryName = json['productCategoryName'].toString();
    productDescript = json['productDescript'];
    num = json['num'];
    typeId = json['typeId'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productCategroyId'] = this.productCategroyId;
    data['productCategoryName'] = this.productCategoryName;
    data['productDescript'] = this.productDescript;
    data['num'] = this.num;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    return data;
  }
}
