class BaseResponseModel<T> {
  num code;
  bool success;
  String message;
  T result;
  num timestamp;

  Map<String, dynamic> toJson() => _$baseModelToJson(this);

  BaseResponseModel(
      {this.code, this.success, this.message, this.result, this.timestamp});

  BaseResponseModel.fromJson(Map<String, dynamic> json, Function callback) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    result = json['result'] != null ? callback(json['result']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> _$baseModelToJson(BaseResponseModel instance) =>
      <String, dynamic>{
        'code': instance.code,
        'success': instance.success,
        'message': instance.message,
        'result': instance.result,
        'timestamp': instance.timestamp
      };

  @override
  String toString() {
    return this.toJson().toString();
  }
}
