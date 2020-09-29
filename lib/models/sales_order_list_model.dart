class SalesRoder {
  int code;
  bool success;
  String message;
  SalesRoderResult result;
  int timestamp;

  SalesRoder(
      {this.code, this.success, this.message, this.result, this.timestamp});

  SalesRoder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null
        ? new SalesRoderResult.fromJson(json['result'])
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

class SalesRoderResult {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  List<SalesRoderList> list;

  SalesRoderResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.list});

  SalesRoderResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      list = new List<SalesRoderList>();
      json['list'].forEach((v) {
        list.add(new SalesRoderList.fromJson(v));
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

class SalesRoderList {
  int id;
  int mainOrderId;
  String subOrderCode;
  String merchantId;
  double totalMoney;
  int status;
  Null consigneeName;
  Null consigneeMobile;
  Null consigneeAdress;
  String expectedDeliveryTime;
  Null notes;
  String demanderDeptName;
  String quotationCode;
  Null applyKey;
  Null createBy;
  Null updateBy;
  Null createTime;
  Null updateTime;
  Null delFlag;
  List<OrderItems> orderItems;
  Null processInstanceId;
  Null approvalState;
  Null key;
  int totalNumber;
  bool isOpen;

  SalesRoderList(
      {this.id,
      this.mainOrderId,
      this.subOrderCode,
      this.merchantId,
      this.totalMoney,
      this.status,
      this.consigneeName,
      this.consigneeMobile,
      this.consigneeAdress,
      this.expectedDeliveryTime,
      this.notes,
      this.demanderDeptName,
      this.quotationCode,
      this.applyKey,
      this.createBy,
      this.updateBy,
      this.createTime,
      this.updateTime,
      this.delFlag,
      this.orderItems,
      this.processInstanceId,
      this.approvalState,
      this.isOpen,
      this.key,
      this.totalNumber});

  SalesRoderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainOrderId = json['mainOrderId'];
    subOrderCode = json['subOrderCode'];
    merchantId = json['merchantId'];
    totalMoney = json['totalMoney'];
    status = json['status'];
    consigneeName = json['consigneeName'];
    consigneeMobile = json['consigneeMobile'];
    consigneeAdress = json['consigneeAdress'];
    expectedDeliveryTime = json['expectedDeliveryTime'];
    notes = json['notes'];
    demanderDeptName = json['demanderDeptName'];
    quotationCode =
        json['quotationCode'] != null ? json['quotationCode'] : null;
    applyKey = json['applyKey'];
    createBy = json['createBy'];
    updateBy = json['updateBy'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    delFlag = json['delFlag'];
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    processInstanceId = json['processInstanceId'];
    approvalState = json['approvalState'];
    isOpen = json['isOpen'];
    key = json['key'];
    totalNumber = json['totalNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainOrderId'] = this.mainOrderId;
    data['subOrderCode'] = this.subOrderCode;
    data['merchantId'] = this.merchantId;
    data['totalMoney'] = this.totalMoney;
    data['status'] = this.status;
    data['consigneeName'] = this.consigneeName;
    data['consigneeMobile'] = this.consigneeMobile;
    data['consigneeAdress'] = this.consigneeAdress;
    data['expectedDeliveryTime'] = this.expectedDeliveryTime;
    data['notes'] = this.notes;
    data['demanderDeptName'] = this.demanderDeptName;
    data['quotationCode'] = this.quotationCode;
    data['applyKey'] = this.applyKey;
    data['createBy'] = this.createBy;
    data['updateBy'] = this.updateBy;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['delFlag'] = this.delFlag;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['processInstanceId'] = this.processInstanceId;
    data['approvalState'] = this.approvalState;
    data['isOpen'] = this.isOpen;
    data['key'] = this.key;
    data['totalNumber'] = this.totalNumber;
    return data;
  }
}

class OrderItems {
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

  OrderItems(
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

  OrderItems.fromJson(Map<String, dynamic> json) {
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
    createBy = json['createBy'];
    updateBy = json['updateBy'];
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

// class SalesRoder {
//   int code;
//   bool success;
//   String message;
//   SalesRoderResult result;
//   int timestamp;

//   SalesRoder(
//       {this.code, this.success, this.message, this.result, this.timestamp});

//   SalesRoder.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     success = json['success'];
//     message = json['message'];
//     result = json['result'] != null
//         ? new SalesRoderResult.fromJson(json['result'])
//         : null;
//     timestamp = json['timestamp'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.result != null) {
//       data['result'] = this.result.toJson();
//     }
//     data['timestamp'] = this.timestamp;
//     return data;
//   }
// }

// class SalesRoderResult {
//   int totalCount;
//   int pageSize;
//   int totalPage;
//   int currPage;
//   List<SalesRoderList> list;

//   SalesRoderResult(
//       {this.totalCount,
//       this.pageSize,
//       this.totalPage,
//       this.currPage,
//       this.list});

//   SalesRoderResult.fromJson(Map<String, dynamic> json) {
//     totalCount = json['totalCount'];
//     pageSize = json['pageSize'];
//     totalPage = json['totalPage'];
//     currPage = json['currPage'];
//     if (json['list'] != null) {
//       list = new List<SalesRoderList>();
//       json['list'].forEach((v) {
//         list.add(new SalesRoderList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['totalCount'] = this.totalCount;
//     data['pageSize'] = this.pageSize;
//     data['totalPage'] = this.totalPage;
//     data['currPage'] = this.currPage;
//     if (this.list != null) {
//       data['list'] = this.list.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SalesRoderList {
//   int id;
//   int mainOrderId;
//   String subOrderCode;
//   String merchantId;
//   double totalMoney;
//   int status;
//   Null consigneeName;
//   Null consigneeMobile;
//   Null consigneeAdress;
//   String expectedDeliveryTime;
//   Null notes;
//   String demanderDeptName;
//   Null quotationCode;
//   Null applyKey;
//   Null createBy;
//   Null updateBy;
//   Null createTime;
//   Null updateTime;
//   Null delFlag;
//   List<OrderItems> orderItems;

//   SalesRoderList(
//       {this.id,
//       this.mainOrderId,
//       this.subOrderCode,
//       this.merchantId,
//       this.totalMoney,
//       this.status,
//       this.consigneeName,
//       this.consigneeMobile,
//       this.consigneeAdress,
//       this.expectedDeliveryTime,
//       this.notes,
//       this.demanderDeptName,
//       this.quotationCode,
//       this.applyKey,
//       this.createBy,
//       this.updateBy,
//       this.createTime,
//       this.updateTime,
//       this.delFlag,
//       this.orderItems});

//   SalesRoderList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     mainOrderId = json['mainOrderId'];
//     subOrderCode = json['subOrderCode'];
//     merchantId = json['merchantId'];
//     totalMoney = json['totalMoney'];
//     status = json['status'];
//     consigneeName = json['consigneeName'];
//     consigneeMobile = json['consigneeMobile'];
//     consigneeAdress = json['consigneeAdress'];
//     expectedDeliveryTime = json['expectedDeliveryTime'];
//     notes = json['notes'];
//     demanderDeptName = json['demanderDeptName'];
//     quotationCode = json['quotationCode'];
//     applyKey = json['applyKey'];
//     createBy = json['createBy'];
//     updateBy = json['updateBy'];
//     createTime = json['createTime'];
//     updateTime = json['updateTime'];
//     delFlag = json['delFlag'];
//     if (json['orderItems'] != null) {
//       orderItems = new List<OrderItems>();
//       json['orderItems'].forEach((v) {
//         orderItems.add(new OrderItems.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['mainOrderId'] = this.mainOrderId;
//     data['subOrderCode'] = this.subOrderCode;
//     data['merchantId'] = this.merchantId;
//     data['totalMoney'] = this.totalMoney;
//     data['status'] = this.status;
//     data['consigneeName'] = this.consigneeName;
//     data['consigneeMobile'] = this.consigneeMobile;
//     data['consigneeAdress'] = this.consigneeAdress;
//     data['expectedDeliveryTime'] = this.expectedDeliveryTime;
//     data['notes'] = this.notes;
//     data['demanderDeptName'] = this.demanderDeptName;
//     data['quotationCode'] = this.quotationCode;
//     data['applyKey'] = this.applyKey;
//     data['createBy'] = this.createBy;
//     data['updateBy'] = this.updateBy;
//     data['createTime'] = this.createTime;
//     data['updateTime'] = this.updateTime;
//     data['delFlag'] = this.delFlag;
//     if (this.orderItems != null) {
//       data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class OrderItems {
//   int id;
//   int mainOrderId;
//   String merchantId;
//   int skuId;
//   int number;
//   double price;
//   String productName;
//   String specification;
//   String unit;
//   String mainKey;
//   String skuKey;
//   String createBy;
//   String updateBy;
//   String createTime;
//   String updateTime;
//   int delFlag;

//   OrderItems(
//       {this.id,
//       this.mainOrderId,
//       this.merchantId,
//       this.skuId,
//       this.number,
//       this.price,
//       this.productName,
//       this.specification,
//       this.unit,
//       this.mainKey,
//       this.skuKey,
//       this.createBy,
//       this.updateBy,
//       this.createTime,
//       this.updateTime,
//       this.delFlag});

//   OrderItems.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     mainOrderId = json['mainOrderId'];
//     merchantId = json['merchantId'];
//     skuId = json['skuId'];
//     number = json['number'];
//     price = json['price'];
//     productName = json['productName'];
//     specification = json['specification'];
//     unit = json['unit'];
//     mainKey = json['mainKey'];
//     skuKey = json['skuKey'];
//     createBy = json['createBy'];
//     updateBy = json['updateBy'];
//     createTime = json['createTime'];
//     updateTime = json['updateTime'];
//     delFlag = json['delFlag'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['mainOrderId'] = this.mainOrderId;
//     data['merchantId'] = this.merchantId;
//     data['skuId'] = this.skuId;
//     data['number'] = this.number;
//     data['price'] = this.price;
//     data['productName'] = this.productName;
//     data['specification'] = this.specification;
//     data['unit'] = this.unit;
//     data['mainKey'] = this.mainKey;
//     data['skuKey'] = this.skuKey;
//     data['createBy'] = this.createBy;
//     data['updateBy'] = this.updateBy;
//     data['createTime'] = this.createTime;
//     data['updateTime'] = this.updateTime;
//     data['delFlag'] = this.delFlag;
//     return data;
//   }
// }
