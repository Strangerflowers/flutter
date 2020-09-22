/** 
 * 数据对象
 */
class DataModel {
  String code;
  String label;
  String value;

  DataModel({this.code, this.label, this.value});

  DataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
