import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 이름(국문) 입력 위젯.
///
/// 한글/영문 1~20자만 허용한다.
class NameInputWidget extends GetView<UserInfoController> {
  const NameInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이름을 알려줘',
            style: AppTextStyles.onboardingTitle.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '리포트에 사용할 이름이에요. (필수)',
            style: AppTextStyles.onboardingSubButton,
          ),
          SizedBox(height: 32.h),
          TextField(
            controller: controller.nameController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.allow(RegExp(r'[가-힣A-Za-z]')),
            ],
            style: AppTextStyles.primaryButton.copyWith(
              color: AppColors.white,
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
              hintText: '예) 홍길동',
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
