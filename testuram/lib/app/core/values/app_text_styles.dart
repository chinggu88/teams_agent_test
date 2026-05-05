import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle onboardingTitle = TextStyle(
    color: AppColors.white,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 1.8,
  );

  static TextStyle onboardingSubButton = TextStyle(
    color: AppColors.whiteSubtle,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle primaryButton = TextStyle(
    color: AppColors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
}
