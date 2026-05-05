import 'package:get/get.dart';
import 'package:testuram/app/modules/auth/controllers/auth_controller.dart';

/// 인증(SNS 로그인) 모듈의 의존성을 등록하는 바인딩.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
