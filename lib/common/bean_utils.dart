class BeanUtils<T> {
  static T copyProperties<T>(
      Map<String, dynamic> src, Map<String, dynamic> dest, Function callback) {
    if (null != src && null != dest) {
      src.forEach((key, value) => dest[key] = value);
      return callback(dest);
    }
    return null;
  }
}
