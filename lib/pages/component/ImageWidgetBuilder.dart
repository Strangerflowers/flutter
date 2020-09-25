import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/common/toast.dart';
import 'package:flutter/material.dart';

class ImageWidgetBuilder {
  static String TAG = "ImageWidgetBuilder";
  static Widget loadImage(
    url, {
    BuildContext context,
    noDefaultErrBuilder = true,
    openToast: false,
    String successToastMsg,
    String errToastMsg,
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
    Image defaultImage = Image.asset('images/default.png');
    Image image = Image.network(url,
        key: key,
        scale: scale,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: noDefaultErrBuilder
            ? (BuildContext context, Object exception, StackTrace stackTrace) {
                return defaultImage;
              }
            : errorBuilder != null ? errorBuilder : null,
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
        isAntiAlias: isAntiAlias,
        headers: headers,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight);
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((_, __) {
      LogUtils.debug(TAG, "=======> 图片加载成功!.", StackTrace.current);
      if (openToast) {
        Toast.toast(
          context,
          msg: StringUtils.defaultIfEmpty(successToastMsg, '文件上传成功!'),
        );
      }
    }, onError: (dynamic exception, StackTrace stackTrace) {
      LogUtils.debug(
          TAG, '=======> 图片加载失败! enter onError start', StackTrace.current);
      LogUtils.debug(TAG, exception, StackTrace.current);
      LogUtils.debug(TAG, stackTrace, StackTrace.current);
      LogUtils.debug(
          TAG, '=======> 图片加载失败! enter onError end', StackTrace.current);
      if (url != '' && openToast) {
        Toast.toast(
          context,
          msg: StringUtils.defaultIfEmpty(errToastMsg, '文件上传失败!'),
        );
      }
    }));

    return image;
  }
}
