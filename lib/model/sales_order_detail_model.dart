class SalesOrderDetail {
  int code;
  bool success;
  String message;
  SalesOrderDetailResult result;
  int timestamp;

  SalesOrderDetail(
      {this.code, this.success, this.message, this.result, this.timestamp});

  SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new SalesOrderDetailResult.fromJson(json['result'])
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

class SalesOrderDetailResult {
  int id;
  int mainOrderId;
  String subOrderCode;
  String demanderDeptName;
  String quotationCode;
  double totalMoney;
  int status;
  String consigneeName;
  String consigneeMobile;
  String consigneeAdress;
  String expectedDeliveryTime;
  String notes;
  List<OrderDetailItems> orderItems;
  List<DispatchVos> dispatchVos;
  String processInstanceId;
  int approvalState;

  SalesOrderDetailResult(
      {this.id,
      this.mainOrderId,
      this.subOrderCode,
      this.demanderDeptName,
      this.quotationCode,
      this.totalMoney,
      this.status,
      this.consigneeName,
      this.consigneeMobile,
      this.consigneeAdress,
      this.expectedDeliveryTime,
      this.notes,
      this.orderItems,
      this.dispatchVos,
      this.processInstanceId,
      this.approvalState});

  SalesOrderDetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainOrderId = json['mainOrderId'];
    subOrderCode = json['subOrderCode'];
    demanderDeptName = json['demanderDeptName'];
    quotationCode = json['quotationCode'].toString();
    totalMoney = json['totalMoney'];
    status = json['status'];
    consigneeName = json['consigneeName'];
    consigneeMobile = json['consigneeMobile'];
    consigneeAdress = json['consigneeAdress'];
    expectedDeliveryTime = json['expectedDeliveryTime'];
    notes = json['notes'];
    if (json['orderItems'] != null) {
      orderItems = new List<OrderDetailItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderDetailItems.fromJson(v));
      });
    }
    if (json['dispatchVos'] != null) {
      dispatchVos = new List<DispatchVos>();
      json['dispatchVos'].forEach((v) {
        dispatchVos.add(new DispatchVos.fromJson(v));
      });
    }
    processInstanceId = json['processInstanceId'].toString();
    approvalState = json['approvalState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainOrderId'] = this.mainOrderId;
    data['subOrderCode'] = this.subOrderCode;
    data['demanderDeptName'] = this.demanderDeptName;
    data['quotationCode'] = this.quotationCode;
    data['totalMoney'] = this.totalMoney;
    data['status'] = this.status;
    data['consigneeName'] = this.consigneeName;
    data['consigneeMobile'] = this.consigneeMobile;
    data['consigneeAdress'] = this.consigneeAdress;
    data['expectedDeliveryTime'] = this.expectedDeliveryTime;
    data['notes'] = this.notes;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    if (this.dispatchVos != null) {
      data['dispatchVos'] = this.dispatchVos.map((v) => v.toJson()).toList();
    }
    data['processInstanceId'] = this.processInstanceId;
    data['approvalState'] = this.approvalState;
    return data;
  }
}

class OrderDetailItems {
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

  OrderDetailItems(
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
      this.delFlag});

  OrderDetailItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainOrderId = json['mainOrderId'];
    merchantId = json['merchantId'];
    skuId = json['skuId'];
    number = json['number'];
    price = json['price'];
    productName = json['productName'];
    specification = json['specification'];
    unit = json['unit'];
    mainKey = json['mainKey'];
    skuKey = json['skuKey'];
    createBy = json['createBy'].toString();
    updateBy = json['updateBy'].toString();
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
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
    return data;
  }
}

class DispatchVos {
  int id;
  int batch;
  String planDeliveryTime;
  String actualDeliveryTime;
  String logisticsCompanyName;
  String logisticsNumber;
  String actualConsigneeTime;
  String qualityCondition;
  String consigneeKey;
  int status;
  List<DispatchItemVos> dispatchItemVos;
  String consigneeUrls;

  DispatchVos(
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

  DispatchVos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batch = json['batch'];
    planDeliveryTime = json['planDeliveryTime'];
    actualDeliveryTime = json['actualDeliveryTime'];
    logisticsCompanyName = json['logisticsCompanyName'].toString();
    logisticsNumber = json['logisticsNumber'].toString();
    actualConsigneeTime = json['actualConsigneeTime'];
    qualityCondition = json['qualityCondition'];
    consigneeKey = json['consigneeKey'];
    status = json['status'];
    if (json['dispatchItemVos'] != null) {
      dispatchItemVos = new List<DispatchItemVos>();
      json['dispatchItemVos'].forEach((v) {
        dispatchItemVos.add(new DispatchItemVos.fromJson(v));
      });
    }
    consigneeUrls = json['consigneeUrls'].toString();
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

class DispatchItemVos {
  int id;
  int orderItemId;
  int dispatchId;
  int planDeliveryNumber;
  int actualDeliveryNumber;
  int actualConsigneeNumber;
  String productName;
  String specification;
  int number;
  String totalActualDeliveryNumber;
  String skuKey;

  DispatchItemVos(
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
      this.skuKey});

  DispatchItemVos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItemId = json['orderItemId'];
    dispatchId = json['dispatchId'];
    planDeliveryNumber = json['planDeliveryNumber'];
    actualDeliveryNumber = json['actualDeliveryNumber'];
    actualConsigneeNumber = json['actualConsigneeNumber'];
    productName = json['productName'];
    specification = json['specification'];
    number = json['number'];
    totalActualDeliveryNumber = json['totalActualDeliveryNumber'].toString();
    skuKey = json['skuKey'].toString();
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
    return data;
  }
}
