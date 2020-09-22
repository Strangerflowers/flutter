class GoodsSearchList {
  int code;
  bool success;
  String message;
  GoodsSearchResult result;
  int timestamp;

  GoodsSearchList(
      {this.code, this.success, this.message, this.result, this.timestamp});

  GoodsSearchList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'].toString();
    result = json['result'] != null
        ? new GoodsSearchResult.fromJson(json['result'])
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

class GoodsSearchResult {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<GoodsSearchResultList> list;

  GoodsSearchResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  GoodsSearchResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<GoodsSearchResultList>();
      json['list'].forEach((v) {
        list.add(new GoodsSearchResultList.fromJson(v));
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

class GoodsSearchResultList {
  int id;
  String subjectId;
  String subjectName;
  String code;
  String name;
  int category1;
  int category2;
  int category3;
  String unit;
  String packUnit;
  String image;
  String description;
  String remark;
  int status;
  int auditStatus;
  String expireTime;
  int version;
  String createTime;
  String updateTime;
  int scaleLeft;
  int scaleRight;
  String priceRange;
  String action;

  GoodsSearchResultList(
      {this.id,
      this.subjectId,
      this.subjectName,
      this.code,
      this.name,
      this.category1,
      this.category2,
      this.category3,
      this.unit,
      this.packUnit,
      this.image,
      this.description,
      this.remark,
      this.status,
      this.auditStatus,
      this.expireTime,
      this.version,
      this.createTime,
      this.updateTime,
      this.scaleLeft,
      this.scaleRight,
      this.priceRange,
      this.action});

  GoodsSearchResultList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    code = json['code'];
    name = json['name'];
    category1 = json['category1'];
    category2 = json['category2'];
    category3 = json['category3'];
    unit = json['unit'];
    packUnit = json['packUnit'];
    image = json['image'].toString();
    description = json['description'];
    remark = json['remark'];
    status = json['status'];
    auditStatus = json['auditStatus'];
    expireTime = json['expireTime'].toString();
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    scaleLeft = json['scaleLeft'];
    scaleRight = json['scaleRight'];
    priceRange = json['priceRange'];
    action = json['action'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    data['code'] = this.code;
    data['name'] = this.name;
    data['category1'] = this.category1;
    data['category2'] = this.category2;
    data['category3'] = this.category3;
    data['unit'] = this.unit;
    data['packUnit'] = this.packUnit;
    data['image'] = this.image;
    data['description'] = this.description;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['auditStatus'] = this.auditStatus;
    data['expireTime'] = this.expireTime;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['scaleLeft'] = this.scaleLeft;
    data['scaleRight'] = this.scaleRight;
    data['priceRange'] = this.priceRange;
    data['action'] = this.action;
    return data;
  }
}
