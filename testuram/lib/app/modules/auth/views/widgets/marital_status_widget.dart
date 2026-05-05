import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/auth/controllers/auth_controller.dart';

/// 혼인 여부 선택 위젯 — 선택 항목.
///
/// 'married' / 'single' / 'unspecified' 중 하나를 선택한다.
class MaritalStatusWidget extends GetView<AuthController> {
  const MaritalStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('혼인 상태',
                style: AppTextStyles.onboardingTitle
                    .copyWith(fontSize: 16.sp)),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '선택',
                style: AppTextStyles.onboardingSubButton
                    .copyWith(fontSize: 12.sp, color: AppColors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final selected = controller.maritalStatus;
          return Row(
            children: [
              _option('married', '기혼', selected),
              SizedBox(width: 8.w),
              _option('single', '미혼', selected),
              SizedBox(width: 8.w),
              _option('unspecified', '선택 안함', selected),
            ],
          );
        }),
      ],
    );
  }

  Widget _option(String value, String label, String selectedValue) {
    final isSelected = value == selectedValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectMaritalStatus(value),
        child: Container(
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryPurple
                : AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryPurpleLight
                  : AppColors.whiteSubtle,
              width: 1.w,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.onboardingSubButton.copyWith(
              color: isSelected ? AppColors.white : AppColors.whiteSubtle,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}
