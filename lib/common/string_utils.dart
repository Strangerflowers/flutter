import 'package:flustars/flustars.dart';
import 'package:sprintf/sprintf.dart';

class StringUtils extends TextUtil {
  static final String EMPTY = '';

  static String defaultIfEmpty(String text, String defaultValue) {
    return TextUtil.isEmpty(text) ? defaultValue : text;
  }

  /** 
   * @Description: 预处理输入文本的内容，每n个字符换一次行
   * @Author: DANTE FUNG
   * @Date: 2020-9-8 16:06:26
   */
  static String preprocessText(String text, int wordSize) {
    int length = text.length;
    if (length <= wordSize) {
      return text;
    }
    int totalGroup = 0;
    if (length % wordSize == 0) {
      totalGroup = length ~/ wordSize;
    } else {
      totalGroup = length ~/ wordSize + 1;
    }
    String returnNewline = "\r\n";
    String finalText = '';
    for (int group = 0; group < totalGroup; group++) {
      int startIdx = group * wordSize;
      int endIdx = group == totalGroup - 1 ? length - 1 : startIdx + wordSize;
      finalText += text.substring(startIdx, endIdx) + returnNewline;
    }
    return finalText;
  }

  /** 
   * @Description: 输出JSON字符串.例如用于重写类的toString()方法时可以这样使用.
   * e.g.
   * 
   * @override
   * String toString() {
   *      return StringUtils.toStringBuilder(this.toJson());
   *  }
   * @Author: DANTE FUNG 
   * @Date: 2020-9-8 16:06:26
   */
  static String toStringBuilder(Map<String, dynamic> map) {
    String finalText = null;
    if (null != map) {
      String prefix = "{";
      String suffix = "}";
      String nonNullFmt = "\"%s\":\"%s\",";
      String nullFmt = "\"%s\":%s,";
      StringBuffer sb = new StringBuffer();
      sb.write(prefix);
      map.forEach((key, value) {
        if (null != value) {
          sb.write(sprintf(nonNullFmt, [key, value]));
        } else {
          sb.write(sprintf(nullFmt, [key, value]));
        }
      });
      finalText = sb.toString();
      finalText = finalText.substring(0, finalText.length - 1);
      finalText = finalText + suffix;
    }
    return finalText;
  }

  static String valueOf(dynamic value) {
    if (null != value) {
      return value.toString();
    } else {
      return '';
    }
  }
}
