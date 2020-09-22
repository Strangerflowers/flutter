class BaseRequestModel<T> {
  static final int DEFAULT_LIMIT = 10;

  // 是否加载全部
  bool isAll = false;
  // 当前页
  int page = 1;
  // 每页限制显示数
  int limit = 10;
  // 降序:DESC  升序: ASC
  String order;
  Map<String, dynamic> pageMap;
  T params;

  BaseRequestModel({this.page, this.limit});

  BaseRequestModel.fromJson(Map<String, dynamic> json) {
    isAll = json['isAll'];
    limit = json['limit'];
    order = json['order'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAll'] = this.isAll;
    data['limit'] = this.limit;
    data['order'] = this.order;
    data['page'] = this.page;
    return data;
  }
}
