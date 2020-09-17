import 'package:bid/common/app_global.dart';
import 'package:bid/models/index.dart';
import 'package:bid/models/profile.dart';
import 'package:bid/provide/app_global/save_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ProfileChangeNotifier {
  Profile get _profile => Global.profile;
  User get user => _profile.user;

  //用户信息发生变化，更新用户信息并通知依赖它的Widgets更新
  set user(User user) {
    if (user?.token != _profile.user?.token) {
      _profile.token = user?.token;
      _profile.user = user;

      notifyListeners();
    }
  }
}
