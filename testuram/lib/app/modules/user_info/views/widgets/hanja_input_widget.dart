import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 이름(한자) 입력 위젯 — 선택 항목.
class HanjaInputWidget extends GetView<UserInfoController> {
  const HanjaInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '한자 이름',
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 22.sp),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '선택',
                  style: AppTextStyles.onboardingSubButton.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '한자가 있으면 더 풍부한 분석이 가능해요.',
            style: AppTextStyles.onboardingSubButton,
          ),
          SizedBox(height: 32.h),
          TextField(
            controller: controller.hanjaController,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            style: AppTextStyles.primaryButton.copyWith(
              color: AppColors.white,
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
              hintText: '예) 洪吉童',
              hintStyle: AppTextStyles.onboardingSubButton,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.whiteSubtle,
                  width: 1.w,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryPurpleLight,
                  width: 2.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
