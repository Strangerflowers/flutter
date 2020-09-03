typedef mapcallback = dynamic Function(dynamic json);

class ListModel<T> {
  static List<T> collectToList<T>(
      List<Map<String, dynamic>> list, mapcallback callback) {
    List<T> retList = [];
    list.forEach((json) => retList.add(callback(json)));
    return retList;
  }
}
