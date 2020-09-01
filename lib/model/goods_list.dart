class GoodsSearchList {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<GoodsList> list;

  GoodsSearchList(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  GoodsSearchList.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<GoodsList>();
      json['list'].forEach((v) {
        list.add(new GoodsList.fromJson(v));
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

class GoodsList {
  int id;
  String subjectId;
  String code;
  String name;
  String category1;
  String category2;
  String category3;
  String unit;
  String image;
  String description;
  String remark;
  int status;
  int version;
  String createTime;
  String updateTime;
  int scaleLeft;
  int scaleRight;

  GoodsList(
      {this.id,
      this.subjectId,
      this.code,
      this.name,
      this.category1,
      this.category2,
      this.category3,
      this.unit,
      this.image,
      this.description,
      this.remark,
      this.status,
      this.version,
      this.createTime,
      this.updateTime,
      this.scaleLeft,
      this.scaleRight});

  GoodsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subjectId'];
    code = json['code'];
    name = json['name'];
    category1 = json['category1'];
    category2 = json['category2'];
    category3 = json['category3'];
    unit = json['unit'];
    image = json['image'].toString();
    description = json['description'];
    remark = json['remark'];
    status = json['status'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    scaleLeft = json['scaleLeft'];
    scaleRight = json['scaleRight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subjectId'] = this.subjectId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['category1'] = this.category1;
    data['category2'] = this.category2;
    data['category3'] = this.category3;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['description'] = this.description;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['scaleLeft'] = this.scaleLeft;
    data['scaleRight'] = this.scaleRight;
    return data;
  }
}
