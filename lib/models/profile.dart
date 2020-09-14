import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "reop.dart";
part 'profile.g.dart';

@JsonSerializable()
class Profile {
    Profile();

    User user;
    String token;
    num theme;
    Reop auditStatusStatus;
    num auditStatus;
    String lastLogin;
    String locale;
    
    factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
    Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
