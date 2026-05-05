import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 성별 선택 위젯 — 필수.
class GenderSelectWidget extends GetView<UserInfoController> {
  const GenderSelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성별을 알려줘',
            style: AppTextStyles.onboardingTitle.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text('정확한 분석을 위해 필요해요. (필수)',
              style: AppTextStyles.onboardingSubButton),
          SizedBox(height: 40.h),
          Row(
            children: [
              Expanded(child: _buildOption(value: 'male', label: '남성')),
              SizedBox(width: 12.w),
              Expanded(child: _buildOption(value: 'female', label: '여성')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({required String value, required String label}) {
    return Obx(() {
      final selected = controller.gender == value;
      return GestureDetector(
        onTap: () => controller.selectGender(value),
        child: Container(
          height: 64.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryPurple
                : AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected
                  ? AppColors.primaryPurpleLight
                  : AppColors.whiteSubtle,
              width: 1.w,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.primaryButton.copyWith(
              color: selected ? AppColors.white : AppColors.whiteSubtle,
              fontSize: 18.sp,
            ),
          ),
        ),
      );
    });
  }
}
