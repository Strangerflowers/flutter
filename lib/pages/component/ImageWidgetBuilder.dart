import 'package:bid/common/log_utils.dart';
import 'package:flutter/material.dart';

class ImageWidgetBuilder {
  static String TAG = "ImageWidgetBuilder";
  static Widget loadImage(
    url, {
    Key key,
    double scale = 1.0,
    frameBuilder,
    loadingBuilder,
    errorBuilder,
    semanticLabel,
    excludeFromSemantics = false,
    width,
    height,
    color,
    colorBlendMode,
    fit,
    alignment = Alignment.center,
    repeat = ImageRepeat.noRepeat,
    centerSlice,
    matchTextDirection = false,
    gaplessPlayback = false,
    filterQuality = FilterQuality.low,
    isAntiAlias = false,
    Map<String, String> headers,
    int cacheWidth,
    int cacheHeight,
  }) {
    Image defaultImage = Image.asset('images/icon.png');
    Image image = Image.network(url,
        key: key,
        scale: scale,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder, errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
      return defaultImage;
    },
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        // isAntiAlias: isAntiAlias,
        headers: headers,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight);
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((_, __) {
      LogUtils.debug(TAG, "=======> 图片加载成功!.", StackTrace.current);
    }, onError: (dynamic exception, StackTrace stackTrace) {
      LogUtils.debug(
          TAG, '=======> 图片加载失败! enter onError start', StackTrace.current);
      LogUtils.debug(TAG, exception, StackTrace.current);
      LogUtils.debug(TAG, stackTrace, StackTrace.current);
      LogUtils.debug(
          TAG, '=======> 图片加载失败! enter onError end', StackTrace.current);
    }));

    return image;
  }
}
