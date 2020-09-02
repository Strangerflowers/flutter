class QuotataionData {
  int code;
  bool success;
  String message;
  QuotataionDataResult result;
  int timestamp;

  QuotataionData(
      {this.code, this.success, this.message, this.result, this.timestamp});

  QuotataionData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new QuotataionDataResult.fromJson(json['result'])
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

class QuotataionDataResult {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<QuotataionDataList> list;

  QuotataionDataResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  QuotataionDataResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<QuotataionDataList>();
      json['list'].forEach((v) {
        list.add(new QuotataionDataList.fromJson(v));
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

class QuotataionDataList {
  int id;
  String subjectId;
  String subjectName;
  bool checkBoxFlag;
  String code;
  String name;
  String category1;
  String category2;
  String category3;
  String unit;
  String packUnit;
  String image;
  String description;
  String remark;
  int status;
  int auditStatus;
  int scaleLeft;
  int scaleRight;
  String createTime;
  String action;
  String priceRange;
  String updateTime;
  String priceValidStart;
  String priceValidEnd;
  List<SkuList> skuList;
  String supplier;

  QuotataionDataList(
      {this.id,
      this.subjectId,
      this.subjectName,
      this.checkBoxFlag,
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
      this.scaleLeft,
      this.scaleRight,
      this.createTime,
      this.action,
      this.priceRange,
      this.updateTime,
      this.priceValidStart,
      this.priceValidEnd,
      this.skuList,
      this.supplier});

  QuotataionDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subjectId'];
    subjectName = json['subjectName'].toString();
    checkBoxFlag = json['checkBoxFlag'];
    code = json['code'];
    name = json['name'];
    category1 = json['category1'].toString();
    category2 = json['category2'].toString();
    category3 = json['category3'].toString();
    unit = json['unit'];
    packUnit = json['packUnit'].toString();
    image = json['image'].toString();
    description = json['description'];
    remark = json['remark'];
    status = json['status'];
    auditStatus = json['auditStatus'];
    scaleLeft = json['scaleLeft'];
    scaleRight = json['scaleRight'];
    createTime = json['createTime'];
    action = json['action'].toString();
    priceRange = json['priceRange'];
    updateTime = json['updateTime'].toString();
    priceValidStart = json['priceValidStart'].toString();
    priceValidEnd = json['priceValidEnd'].toString();
    if (json['skuList'] != null) {
      skuList = new List<SkuList>();
      json['skuList'].forEach((v) {
        skuList.add(new SkuList.fromJson(v));
      });
    }
    supplier = json['supplier'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    data['checkBoxFlag'] = this.checkBoxFlag;
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
    data['scaleLeft'] = this.scaleLeft;
    data['scaleRight'] = this.scaleRight;
    data['createTime'] = this.createTime;
    data['action'] = this.action;
    data['priceRange'] = this.priceRange;
    data['updateTime'] = this.updateTime;
    data['priceValidStart'] = this.priceValidStart;
    data['priceValidEnd'] = this.priceValidEnd;
    if (this.skuList != null) {
      data['skuList'] = this.skuList.map((v) => v.toJson()).toList();
    }
    data['supplier'] = this.supplier;
    return data;
  }
}

class SkuList {
  int id;
  int spuId;
  int stock;
  int price;
  String expireTime;
  String image;
  int version;
  String createTime;
  String updateTime;
  List<Items> items;
  int status;
  int cartId;

  SkuList(
      {this.id,
      this.spuId,
      this.stock,
      this.price,
      this.expireTime,
      this.image,
      this.version,
      this.createTime,
      this.updateTime,
      this.items,
      this.status,
      this.cartId});

  SkuList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    spuId = json['spuId'];
    stock = json['stock'];
    price = json['price'];
    expireTime = json['expireTime'];
    image = json['image'].toString();
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'].toString();
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    status = json['status'];
    cartId = json['cartId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['spuId'] = this.spuId;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['expireTime'] = this.expireTime;
    data['image'] = this.image;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['cartId'] = this.cartId;
    return data;
  }
}

class Items {
  int id;
  int spuId;
  int specsId;
  int skuId;
  String value;
  String name;

  Items({this.id, this.spuId, this.specsId, this.skuId, this.value, this.name});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    spuId = json['spuId'];
    specsId = json['specsId'];
    skuId = json['skuId'];
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['spuId'] = this.spuId;
    data['specsId'] = this.specsId;
    data['skuId'] = this.skuId;
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}
