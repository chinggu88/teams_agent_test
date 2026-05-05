import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testuram/app/modules/splash/controllers/splash_controller.dart';
import 'package:testuram/app/routes/app_pages.dart';

/// 우주 테마 온보딩 인트로 컨트롤러.
///
/// 슬라이드 페이지 전환과 정보 수집 화면으로의 진입을 담당한다.
class OnboardingIntroController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static OnboardingIntroController get to => Get.find();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  /// 현재 슬라이드 페이지 인덱스 (0부터 시작)
  final _currentPage = 0.obs;
  int get currentPage => _currentPage.value;
  set currentPage(int val) => _currentPage.value = val;

  // ---------------------------------------------------------------------------
  // UI Controllers
  // ---------------------------------------------------------------------------
  late final PageController pageController;

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------
  final _storage = GetStorage();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 페이지 변경 시 인덱스를 업데이트한다.
  void onPageChanged(int index) {
    currentPage = index;
  }

  /// "내 우주 입력하기" — 정보 수집 화면으로 이동한다.
  Future<void> goToUserInfo() async {
    await _storage.write(SplashController.kKeyOnboardingIntroSeen, true);
    Get.offAllNamed(Routes.USER_INFO);
  }

  /// "유람 먼저 둘러보기" — 게스트 모드로 종합 리포트 미리보기 화면으로 이동한다.
  Future<void> goToGuest() async {
    await _storage.write(SplashController.kKeyOnboardingIntroSeen, true);
    Get.offAllNamed(Routes.REPORT);
  }
}
