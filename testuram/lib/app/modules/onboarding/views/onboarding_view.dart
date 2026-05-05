import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/data/models/yuram_coordinate_model.dart';
import 'package:testuram/app/modules/onboarding/controllers/onboarding_controller.dart';

/// 유람 좌표 분석 결과 온보딩 화면.
///
/// 분석 결과(YuramCoordinate)를 카드 형태로 보여주고,
/// 회원가입 화면으로 진입하는 CTA를 제공한다.
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

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
          child: Obx(() {
            if (controller.isLoading) {
              return _buildLoading();
            }
            if (controller.errorMessage != null) {
              return _buildError(controller.errorMessage!);
            }
            final c = controller.coordinate;
            if (c == null) {
              return _buildError('분석 결과가 없습니다.');
            }
            return _buildResult(c);
          }),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36.r,
            height: 36.r,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryPurpleLight,
              ),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16.h),
          Text('네 좌표를 그리고 있어...',
              style: AppTextStyles.onboardingSubButton),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 48.r, color: AppColors.whiteSubtle),
          SizedBox(height: 12.h),
          Text(message,
              style: AppTextStyles.onboardingTitle.copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: controller.retry,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryPurpleLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('다시 시도',
                style: AppTextStyles.primaryButton.copyWith(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(YuramCoordinateModel c) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.goBack,
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('너의 유람 좌표',
                    style: AppTextStyles.onboardingSubButton),
                SizedBox(height: 8.h),
                Text(
                  c.name ?? '미정',
                  style: AppTextStyles.onboardingTitle.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((c.code ?? '').isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text('좌표 코드: ${c.code}',
                      style: AppTextStyles.onboardingSubButton),
                ],
                SizedBox(height: 24.h),
                if ((c.summary ?? '').isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      c.summary!,
                      style: AppTextStyles.onboardingTitle
                          .copyWith(fontSize: 16.sp, height: 1.6),
                    ),
                  ),
                SizedBox(height: 16.h),
                if ((c.description ?? '').isNotEmpty)
                  Text(
                    c.description!,
                    style: AppTextStyles.onboardingTitle
                        .copyWith(fontSize: 14.sp, height: 1.7),
                  ),
                SizedBox(height: 24.h),
                if (c.keywords != null && c.keywords!.isNotEmpty)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: c.keywords!
                        .map(
                          (k) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '#$k',
                              style: AppTextStyles.onboardingSubButton
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
          child: SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: controller.goToAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                elevation: 0,
              ),
              child: Text('회원가입하고 종합 리포트 받기',
                  style: AppTextStyles.primaryButton),
            ),
          ),
        ),
      ],
    );
  }
}
