abstract class LogUtils {
  //dart.vm.product 环境标识位 Release为true debug 为false
  static const bool isRelease = const bool.fromEnvironment("dart.vm.product");

  static XFCustomTrace programInfo;

  static void debug(String tag, Object message, StackTrace current) {
    programInfo = XFCustomTrace(current);
    if (!isRelease)
      _printLog(
          tag,
          '[DEBUG] ' +
              programInfo.fileName +
              ' - 第' +
              programInfo.lineNumber.toString() +
              '行 -> ',
          message);
  }

  static void info(String tag, Object message, StackTrace current) {
    programInfo = XFCustomTrace(current);
    _printLog(
        tag,
        '[INFO] ' +
            programInfo.fileName +
            ' - 第' +
            programInfo.lineNumber.toString() +
            '行 -> ',
        message);
  }

  static void d(String tag, Object message) {
    if (!isRelease) _printLog(tag, '[DEBUG] -> ', message);
  }

  static void i(String tag, Object message) {
    _printLog(tag, '[INFO] -> ', message);
  }

  static void e(String tag, Object message, {Exception e}) {
    _printLog(tag, '[ERROR] -> ', message);
  }

  static void w(String tag, Object message, {Exception e}) {
    _printLog(tag, '[WARN] -> ', message);
  }

  static void _printLog(String tag, String level, Object message) {
    StringBuffer sb = new StringBuffer();
    sb
      ..write(new DateTime.now())
      ..write('  -  ')
      ..write(level)
      ..write(tag ?? '')
      ..write(': ')
      ..write(message);
    print(sb.toString());
  }
}

class XFCustomTrace {
  final StackTrace _trace;

  String fileName;
  int lineNumber;
  int columnNumber;

  XFCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceString = this._trace.toString().split("\n")[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    this.columnNumber = int.parse(columnStr);
  }
}
