import 'package:get/get.dart';
import 'package:testuram/app/modules/auth/bindings/auth_binding.dart';
import 'package:testuram/app/modules/auth/views/auth_view.dart';
import 'package:testuram/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:testuram/app/modules/onboarding/views/onboarding_view.dart';
import 'package:testuram/app/modules/onboarding_intro/bindings/onboarding_intro_binding.dart';
import 'package:testuram/app/modules/onboarding_intro/views/onboarding_intro_view.dart';
import 'package:testuram/app/modules/report/bindings/report_binding.dart';
import 'package:testuram/app/modules/report/views/report_view.dart';
import 'package:testuram/app/modules/splash/bindings/splash_binding.dart';
import 'package:testuram/app/modules/splash/views/splash_view.dart';
import 'package:testuram/app/modules/user_info/bindings/user_info_binding.dart';
import 'package:testuram/app/modules/user_info/views/user_info_view.dart';

part 'app_routes.dart';

/// 앱의 모든 라우트를 등록하는 GetPage 모음.
class AppPages {
  /// 앱 진입 라우트 (스플래시 → 분기)
  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING_INTRO,
      page: () => const OnboardingIntroView(),
      binding: OnboardingIntroBinding(),
    ),
    GetPage(
      name: Routes.USER_INFO,
      page: () => const UserInfoView(),
      binding: UserInfoBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
  ];
}
