import 'package:get/get.dart';
import 'package:testuram/app/modules/onboarding/controllers/onboarding_controller.dart';

/// 온보딩(유람 좌표 분석 결과) 모듈의 의존성을 등록하는 바인딩.
///
/// GetPage에 연결되어 화면 진입 시 OnboardingController를 지연 초기화한다.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
