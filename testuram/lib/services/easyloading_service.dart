import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 로딩 인디케이터 / 토스트 / 정보 메시지 글로벌 서비스.
///
/// EasyLoading을 래핑하여 앱 전역에서 일관된 UI로 사용한다.
class EasyloadingService extends GetxService {
  static EasyloadingService get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    _configure();
  }

  void _configure() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1800)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 36.0
      ..radius = 12.0
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  /// 전역 로딩 표시.
  Future<void> showLoading([String? message]) async {
    await EasyLoading.show(status: message ?? '로딩 중...');
  }

  /// 전역 로딩 해제.
  Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }

  /// 정보 메시지 (성공/안내).
  Future<void> showInfo(String message) async {
    await EasyLoading.showInfo(message);
  }

  /// 토스트 메시지.
  ///
  /// [issuccess]가 false 인 경우 에러 톤으로 표시한다.
  Future<void> showToast(String message, {bool issuccess = true}) async {
    if (issuccess) {
      await EasyLoading.showSuccess(message);
    } else {
      await EasyLoading.showError(message);
    }
  }
}

/// EasyLoading 글로벌 ThemeData에 통합하기 위한 헬퍼.
///
/// MaterialApp.builder 단계에서 `EasyLoading.init()`이 적용되어야 한다.
class EasyloadingThemeBinder {
  EasyloadingThemeBinder._();

  static TransitionBuilder bind() {
    return (context, child) {
      ScreenUtil.init(context);
      return EasyLoading.init()(context, child);
    };
  }
}
