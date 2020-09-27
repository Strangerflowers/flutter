class GoodsNewsObj {
  int code;
  bool success;
  String message;
  GoodsNewsObjResult result;
  int timestamp;

  GoodsNewsObj(
      {this.code, this.success, this.message, this.result, this.timestamp});

  GoodsNewsObj.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new GoodsNewsObjResult.fromJson(json['result'])
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

class GoodsNewsObjResult {
  int id;
  int batch;
  String planDeliveryTime;
  String actualDeliveryTime;
  Null logisticsCompanyName;
  Null logisticsNumber;
  String actualConsigneeTime;
  String qualityCondition;
  String consigneeKey;
  int status;
  List<DispatchGoodsNewsVos> dispatchItemVos;
  List<String> consigneeUrls;

  GoodsNewsObjResult(
      {this.id,
      this.batch,
      this.planDeliveryTime,
      this.actualDeliveryTime,
      this.logisticsCompanyName,
      this.logisticsNumber,
      this.actualConsigneeTime,
      this.qualityCondition,
      this.consigneeKey,
      this.status,
      this.dispatchItemVos,
      this.consigneeUrls});

  GoodsNewsObjResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batch = json['batch'];
    planDeliveryTime = json['planDeliveryTime'];
    actualDeliveryTime = json['actualDeliveryTime'];
    logisticsCompanyName = json['logisticsCompanyName'];
    logisticsNumber = json['logisticsNumber'];
    actualConsigneeTime = json['actualConsigneeTime'];
    qualityCondition = json['qualityCondition'];
    consigneeKey = json['consigneeKey'];
    status = json['status'];
    if (json['dispatchItemVos'] != null) {
      dispatchItemVos = new List<DispatchGoodsNewsVos>();
      json['dispatchItemVos'].forEach((v) {
        dispatchItemVos.add(new DispatchGoodsNewsVos.fromJson(v));
      });
    }
    consigneeUrls = json['consigneeUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['batch'] = this.batch;
    data['planDeliveryTime'] = this.planDeliveryTime;
    data['actualDeliveryTime'] = this.actualDeliveryTime;
    data['logisticsCompanyName'] = this.logisticsCompanyName;
    data['logisticsNumber'] = this.logisticsNumber;
    data['actualConsigneeTime'] = this.actualConsigneeTime;
    data['qualityCondition'] = this.qualityCondition;
    data['consigneeKey'] = this.consigneeKey;
    data['status'] = this.status;
    if (this.dispatchItemVos != null) {
      data['dispatchItemVos'] =
          this.dispatchItemVos.map((v) => v.toJson()).toList();
    }
    data['consigneeUrls'] = this.consigneeUrls;
    return data;
  }
}

class DispatchGoodsNewsVos {
  int id;
  int orderItemId;
  int dispatchId;
  int planDeliveryNumber;
  Null actualDeliveryNumber;
  int actualConsigneeNumber;
  String productName;
  String specification;
  int number;
  int totalActualDeliveryNumber;
  String skuKey;
  String mainKey;

  DispatchGoodsNewsVos(
      {this.id,
      this.orderItemId,
      this.dispatchId,
      this.planDeliveryNumber,
      this.actualDeliveryNumber,
      this.actualConsigneeNumber,
      this.productName,
      this.specification,
      this.number,
      this.totalActualDeliveryNumber,
      this.mainKey,
      this.skuKey});

  DispatchGoodsNewsVos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItemId = json['orderItemId'];
    dispatchId = json['dispatchId'];
    planDeliveryNumber = json['planDeliveryNumber'];
    actualDeliveryNumber = json['actualDeliveryNumber'];
    actualConsigneeNumber = json['actualConsigneeNumber'];
    productName = json['productName'];
    specification = json['specification'];
    number = json['number'];
    totalActualDeliveryNumber = json['totalActualDeliveryNumber'];
    mainKey = json['mainKey'];
    skuKey = json['skuKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderItemId'] = this.orderItemId;
    data['dispatchId'] = this.dispatchId;
    data['planDeliveryNumber'] = this.planDeliveryNumber;
    data['actualDeliveryNumber'] = this.actualDeliveryNumber;
    data['actualConsigneeNumber'] = this.actualConsigneeNumber;
    data['productName'] = this.productName;
    data['specification'] = this.specification;
    data['number'] = this.number;
    data['totalActualDeliveryNumber'] = this.totalActualDeliveryNumber;
    data['skuKey'] = this.skuKey;
    data['mainKey'] = this.mainKey;
    return data;
  }
}
