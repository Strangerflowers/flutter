import 'package:json_annotation/json_annotation.dart';

part 'WithdrawAddressModel.g.dart';

@JsonSerializable()
class WithdrawAddressModel {
  WithdrawAddressModel(
      {this.id,
      this.userId,
      this.receiverName,
      this.mobile,
      this.areaCode,
      this.address,
      this.defaultAddress,
      this.status,
      this.createTime,
      this.createBy,
      this.updateTime,
      this.updateBy,
      this.delFlag});

  num id;
  String userId;
  String receiverName;
  String mobile;
  String areaCode;
  String address;
  num defaultAddress;
  num status;
  String createTime;
  String createBy;
  String updateTime;
  String updateBy;
  num delFlag;

  factory WithdrawAddressModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawAddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawAddressModelToJson(this);

  @override
  String toString() {
    return this.toJson().toString();
  }
}
