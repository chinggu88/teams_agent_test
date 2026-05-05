import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 생년월일 + 태어난 시간 입력 위젯.
///
/// 생년월일은 필수, 태어난 시간은 선택(미입력 시 'unknown').
class BirthDatetimeWidget extends GetView<UserInfoController> {
  const BirthDatetimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '언제 태어났어?',
            style: AppTextStyles.onboardingTitle.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '시각도 알면 더 정밀해져요. 모르면 ‘모름’을 눌러줘.',
            style: AppTextStyles.onboardingSubButton,
          ),
          SizedBox(height: 32.h),
          _buildDateField(context),
          SizedBox(height: 16.h),
          _buildTimeField(context),
          SizedBox(height: 12.h),
          _buildUnknownToggle(),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Obx(() {
      final value = controller.birthDate ?? '';
      return GestureDetector(
        onTap: () => _pickDate(context),
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.whiteSubtle, width: 1.w),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value.isEmpty ? '생년월일 (필수)' : value,
            style: AppTextStyles.primaryButton.copyWith(
              color: value.isEmpty ? AppColors.whiteSubtle : AppColors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimeField(BuildContext context) {
    return Obx(() {
      final isUnknown = controller.birthTimeUnknown;
      final value = controller.birthTime;
      final display = isUnknown
          ? '모름'
          : (value == null || value.isEmpty || value == 'unknown'
              ? '태어난 시간 (선택)'
              : value);
      return GestureDetector(
        onTap: isUnknown ? null : () => _pickTime(context),
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(
              alpha: isUnknown ? 0.04 : 0.08,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.whiteSubtle, width: 1.w),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            display,
            style: AppTextStyles.primaryButton.copyWith(
              color: AppColors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildUnknownToggle() {
    return Obx(() {
      return Row(
        children: [
          Checkbox(
            value: controller.birthTimeUnknown,
            onChanged: (v) =>
                controller.toggleBirthTimeUnknown(v ?? false),
            activeColor: AppColors.primaryPurple,
            checkColor: AppColors.white,
          ),
          Text('태어난 시간을 모릅니다',
              style: AppTextStyles.onboardingSubButton.copyWith(
                  color: AppColors.white, fontSize: 14.sp)),
        ],
      );
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = controller.birthDate != null
        ? (DateTime.tryParse(controller.birthDate!) ?? DateTime(2000, 1, 1))
        : DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryPurple,
              onPrimary: AppColors.white,
              surface: AppColors.backgroundGradientBottom,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.selectBirthDate(picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryPurple,
              onPrimary: AppColors.white,
              surface: AppColors.backgroundGradientBottom,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.selectBirthTime(picked);
    }
  }
}
