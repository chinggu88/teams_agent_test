import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/data/models/report_model.dart';
import 'package:testuram/app/modules/report/controllers/report_controller.dart';

/// 종합 리포트 메인 화면.
///
/// 회원가입 완료 후 진입한다.
/// 리포트 데이터(섹션 / 키워드 / 유람 좌표 요약)를 표시한다.
class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

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
            final report = controller.report;
            if (report == null) {
              return _buildEmpty();
            }
            return _buildReport(report);
          }),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: SizedBox(
        width: 36.r,
        height: 36.r,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.primaryPurpleLight,
          ),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text('리포트가 아직 없습니다.',
          style: AppTextStyles.onboardingSubButton),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off,
              size: 48.r, color: AppColors.whiteSubtle),
          SizedBox(height: 12.h),
          Text(message,
              style: AppTextStyles.onboardingTitle
                  .copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: controller.refreshReport,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryPurpleLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('다시 시도',
                style: AppTextStyles.primaryButton
                    .copyWith(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildReport(ReportModel report) {
    return RefreshIndicator(
      onRefresh: controller.refreshReport,
      color: AppColors.primaryPurpleLight,
      backgroundColor: AppColors.backgroundGradientBottom,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        children: [
          Text(report.title ?? '나의 종합 리포트',
              style: AppTextStyles.onboardingTitle.copyWith(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 12.h),
          if ((report.summary ?? '').isNotEmpty)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                report.summary!,
                style: AppTextStyles.onboardingTitle
                    .copyWith(fontSize: 15.sp, height: 1.7),
              ),
            ),
          SizedBox(height: 20.h),
          if (report.yuramCoordinate != null) _buildCoordinateCard(report),
          SizedBox(height: 20.h),
          if (report.sections != null) ..._buildSections(report.sections!),
          SizedBox(height: 24.h),
          if (report.recommendKeywords != null &&
              report.recommendKeywords!.isNotEmpty) ...[
            Text('추천 키워드',
                style: AppTextStyles.onboardingTitle
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: report.recommendKeywords!
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
        ],
      ),
    );
  }

  Widget _buildCoordinateCard(ReportModel report) {
    final c = report.yuramCoordinate!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.5),
            AppColors.primaryPurpleLight.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('너의 유람 좌표',
              style: AppTextStyles.onboardingSubButton
                  .copyWith(color: AppColors.white)),
          SizedBox(height: 4.h),
          Text(c.name ?? '미정',
              style: AppTextStyles.onboardingTitle.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              )),
          if ((c.summary ?? '').isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(c.summary!,
                style: AppTextStyles.onboardingTitle
                    .copyWith(fontSize: 14.sp, height: 1.6)),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSections(List<ReportSectionModel> sections) {
    return sections
        .map(
          (s) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.heading ?? '',
                    style: AppTextStyles.onboardingTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    s.body ?? '',
                    style: AppTextStyles.onboardingTitle
                        .copyWith(fontSize: 14.sp, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
