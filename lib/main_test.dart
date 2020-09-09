import 'package:bid/config/environment.dart';
import 'package:bid/config/main_common.dart';

Future<void> main() async {
  await mainCommon(Environment.TEST);
}
