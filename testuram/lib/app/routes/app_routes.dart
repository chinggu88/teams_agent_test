part of 'app_pages.dart';

/// 앱 라우트 경로 상수.
///
/// 모든 화면 이동은 GetX의 `Get.toNamed(Routes.X)` 형태로 수행한다.
abstract class Routes {
  /// 스플래시 화면 (앱 진입점)
  static const SPLASH = '/splash';

  /// 기존 온보딩(우주 테마 인트로) 화면
  static const ONBOARDING_INTRO = '/onboarding-intro';

  /// 정보 수집 화면 (이름·성별·생년월일 등)
  static const USER_INFO = '/user-info';

  /// 유람 좌표 분석 결과 온보딩 화면
  static const ONBOARDING = '/onboarding';

  /// SNS 회원가입 / 로그인 화면
  static const AUTH = '/auth';

  /// 종합 리포트 메인 화면
  static const REPORT = '/report';

  /// 레거시 라우트 (호환용)
  static const LOGIN = '/login';
  static const HOME = '/home';
}
