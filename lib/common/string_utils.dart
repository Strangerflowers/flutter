import 'package:flustars/flustars.dart';

class StringUtils extends TextUtil {
  static String defaultIfEmpty(String text, String defaultValue) {
    return TextUtil.isEmpty(text) ? defaultValue : text;
  }

  /** 
   * 预处理经营范围的描述内容，每10个字符换一次行
   */
  static String preprocessText(String text, int wordSize) {
    int length = text.length;
    int totalGroup = 0;
    if (length % wordSize == 0) {
      totalGroup = length ~/ wordSize;
    } else {
      totalGroup = length ~/ wordSize + 1;
    }
    String returnNewline = "\r\n";
    String finalText = '';
    for (int group = 0; group < totalGroup; group++) {
      int startIdx = group * wordSize + 1;
      int endIdx = group == totalGroup - 1 ? length - 1 : startIdx + wordSize;
      finalText += text.substring(startIdx, endIdx) + returnNewline;
    }
    return finalText;
  }
}
