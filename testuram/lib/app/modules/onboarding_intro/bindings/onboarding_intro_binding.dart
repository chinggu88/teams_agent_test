import 'package:get/get.dart';
import 'package:testuram/app/modules/onboarding_intro/controllers/onboarding_intro_controller.dart';

/// 우주 테마 온보딩 인트로 모듈의 바인딩.
class OnboardingIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingIntroController>(() => OnboardingIntroController());
  }
}
