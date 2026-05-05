import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testuram/app/routes/app_pages.dart';

/// 스플래시 컨트롤러.
///
/// 앱 진입 시 호출되어 사용자의 상태(회원가입 완료 여부)에 따라
/// 다음 화면으로 분기 라우팅을 수행한다.
///
/// 분기 규칙 (단순화)
/// - `sign_up_done == true` → `/report` (메인)
/// - 그 외 모든 경우 → `/user-info` (정보 수집부터 재시작)
///
/// 회원가입(`sign_up_done`)이 완료되기 전에 앱이 강제 종료되면
/// 중간 단계(`onboarding_intro_seen`, `user_info_done`)와 무관하게
/// 정보 수집 화면부터 다시 시작한다.
class SplashController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static SplashController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Constants
  // ---------------------------------------------------------------------------
  static const _kSplashDelay = Duration(milliseconds: 1500);

  // ---------------------------------------------------------------------------
  // Storage keys
  // ---------------------------------------------------------------------------
  static const String kKeyUserInfoDone = 'user_info_done';
  static const String kKeySignUpDone = 'sign_up_done';
  static const String kKeyOnboardingIntroSeen = 'onboarding_intro_seen';

  // ---------------------------------------------------------------------------
  // Private fields
  // ---------------------------------------------------------------------------
  final _storage = GetStorage();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final _isReady = false.obs;
  bool get isReady => _isReady.value;
  set isReady(bool value) => _isReady.value = value;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onReady() {
    super.onReady();
    _decideInitialRoute();
  }

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 사용자 상태에 따라 초기 라우트로 이동한다.
  ///
  /// `sign_up_done`만 분기 기준으로 사용한다.
  /// 회원가입 완료 전 앱이 종료된 경우 중간 단계 플래그(introSeen, userInfoDone)에
  /// 관계없이 항상 정보 수집 화면(`/user-info`)부터 다시 진입한다.
  Future<void> _decideInitialRoute() async {
    try {
      await Future.delayed(_kSplashDelay);

      final signUpDone = _storage.read<bool>(kKeySignUpDone) ?? false;

      if (signUpDone) {
        Get.offAllNamed(Routes.REPORT);
        return;
      }

      Get.offAllNamed(Routes.USER_INFO);
    } catch (e) {
      log('Splash decide initial route failed: $e');
      Get.offAllNamed(Routes.USER_INFO);
    } finally {
      isReady = true;
    }
  }
}
