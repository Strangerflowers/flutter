class AddDeliverArrange {
  int code;
  bool success;
  String message;
  List<AddDeliverArrangeResult> result;
  int timestamp;

  AddDeliverArrange(
      {this.code, this.success, this.message, this.result, this.timestamp});

  AddDeliverArrange.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<AddDeliverArrangeResult>();
      json['result'].forEach((v) {
        result.add(new AddDeliverArrangeResult.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class AddDeliverArrangeResult {
  int id;
  int mainOrderId;
  String merchantId;
  int skuId;
  int number;
  double price;
  String productName;
  String specification;
  String unit;
  String mainKey;
  String skuKey;
  String createBy;
  String updateBy;
  String createTime;
  String updateTime;
  int delFlag;
  int totalPlanDeliveryNumber;
  int planDeliveryNumber;

  AddDeliverArrangeResult(
      {this.id,
      this.mainOrderId,
      this.merchantId,
      this.skuId,
      this.number,
      this.price,
      this.productName,
      this.specification,
      this.unit,
      this.mainKey,
      this.skuKey,
      this.createBy,
      this.updateBy,
      this.createTime,
      this.updateTime,
      this.delFlag,
      this.totalPlanDeliveryNumber,
      this.planDeliveryNumber});

  AddDeliverArrangeResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainOrderId = json['mainOrderId'];
    merchantId = json['merchantId'];
    skuId = json['skuId'];
    number = json['number'];
    price = json['price'];
    productName = json['productName'];
    specification = json['specification'];
    unit = json['unit'];
    mainKey = json['mainKey'].toString();
    skuKey = json['skuKey'];
    createBy = json['createBy'].toString();
    updateBy = json['updateBy'].toString();
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    totalPlanDeliveryNumber = json['totalPlanDeliveryNumber'];
    planDeliveryNumber = json['planDeliveryNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainOrderId'] = this.mainOrderId;
    data['merchantId'] = this.merchantId;
    data['skuId'] = this.skuId;
    data['number'] = this.number;
    data['price'] = this.price;
    data['productName'] = this.productName;
    data['specification'] = this.specification;
    data['unit'] = this.unit;
    data['mainKey'] = this.mainKey;
    data['skuKey'] = this.skuKey;
    data['createBy'] = this.createBy;
    data['updateBy'] = this.updateBy;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    data['totalPlanDeliveryNumber'] = this.totalPlanDeliveryNumber;
    data['planDeliveryNumber'] = this.planDeliveryNumber;

    return data;
  }
}
