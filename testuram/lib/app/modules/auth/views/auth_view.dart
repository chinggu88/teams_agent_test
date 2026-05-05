import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/auth/controllers/auth_controller.dart';
import 'package:testuram/app/modules/auth/views/widgets/marital_status_widget.dart';

/// SNS 회원가입 / 로그인 화면.
///
/// 카카오 / 구글 로그인 버튼과 (선택) 혼인 여부 위젯을 제공한다.
/// SNS 버튼은 각 플랫폼 브랜드 가이드라인을 준수한다.
/// - 카카오: 배경 #FEE500, 텍스트 #191919, 카카오 로고 좌측
/// - 구글: 배경 흰색, 테두리 #DDDDDD, 텍스트 black87, 'G' 로고 좌측
class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundGradientTop,
              AppColors.backgroundGradientBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '리포트를 저장하려면',
                  style: AppTextStyles.onboardingTitle
                      .copyWith(fontSize: 22.sp),
                ),
                Text(
                  '간편 가입을 해줘',
                  style: AppTextStyles.onboardingTitle
                      .copyWith(fontSize: 22.sp),
                ),
                SizedBox(height: 16.h),
                Text('1초 만에 끝나요. 너의 좌표를 우리만 알게 해줄게.',
                    style: AppTextStyles.onboardingSubButton),
                SizedBox(height: 32.h),
                const MaritalStatusWidget(),
                const Spacer(),
                _buildKakaoButton(),
                SizedBox(height: 12.h),
                _buildGoogleButton(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 카카오 공식 가이드라인 준수 버튼.
  ///
  /// - 배경: `AppColors.kakaoYellow` (#FEE500)
  /// - 전경: `AppColors.kakaoText` (#191919)
  /// - 카카오 말풍선 로고를 텍스트 좌측에 배치
  Widget _buildKakaoButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton.icon(
          onPressed: controller.isAuthenticating
              ? null
              : controller.signInWithKakao,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kakaoYellow,
            foregroundColor: AppColors.kakaoText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          icon: Icon(
            Icons.chat_bubble,
            color: AppColors.kakaoText,
            size: 20.r,
          ),
          label: Text(
            '카카오로 시작하기',
            style: AppTextStyles.primaryButton
                .copyWith(color: AppColors.kakaoText),
          ),
        ),
      );
    });
  }

  /// 구글 공식 가이드라인 준수 버튼.
  ///
  /// - 배경: `Colors.white`
  /// - 테두리: `AppColors.googleBorder` (#DDDDDD)
  /// - 텍스트: `Colors.black87`
  /// - 구글 'G' 로고를 텍스트 좌측에 배치
  Widget _buildGoogleButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 56.h,
        child: OutlinedButton.icon(
          onPressed: controller.isAuthenticating
              ? null
              : controller.signInWithGoogle,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: AppColors.googleBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          icon: Icon(
            Icons.g_mobiledata,
            color: AppColors.googleBrandBlue,
            size: 28.r,
          ),
          label: Text(
            'Google로 시작하기',
            style: AppTextStyles.primaryButton.copyWith(color: Colors.black87),
          ),
        ),
      );
    });
  }
}
