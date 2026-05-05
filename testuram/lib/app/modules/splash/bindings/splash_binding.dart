import 'package:get/get.dart';
import 'package:testuram/app/modules/splash/controllers/splash_controller.dart';

/// 스플래시 모듈의 의존성을 등록하는 바인딩.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
