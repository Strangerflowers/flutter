import 'package:flustars/flustars.dart';

class StringUtils extends TextUtil {
  static String defaultIfEmpty(String text, String defaultValue) {
    return TextUtil.isEmpty(text) ? defaultValue : text;
  }
}
