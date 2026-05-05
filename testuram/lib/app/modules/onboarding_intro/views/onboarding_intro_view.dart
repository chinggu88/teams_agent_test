import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/onboarding_intro/controllers/onboarding_intro_controller.dart';

/// 우주 테마 온보딩 인트로 화면.
///
/// 2페이지 슬라이드 후 정보 수집 화면으로 진입한다.
class OnboardingIntroView extends GetView<OnboardingIntroController> {
  const OnboardingIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          const _StarParticles(),
          const _TopLeftConstellation(),
          const _BottomRightConstellation(),
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
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
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [_buildPage1(), _buildPage2()],
          ),
        ),
        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildPage1() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('안녕!',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
            Text('네 안의 빛나는 우주가',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
            Text('너무 궁금해서 기다리고 있었어 ✨',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('너에게 맞는',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
            Text('리포트를 써줄 수 있게,',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
            Text('태어난 시공간의 좌표를 알려줄래?',
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: controller.currentPage == 1
            ? _buildPage2Buttons()
            : SizedBox(height: 120.h),
      ),
    );
  }

  Widget _buildPage2Buttons() {
    return Padding(
      key: const ValueKey('page2_buttons'),
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: controller.goToUserInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                elevation: 0,
              ),
              child: Text('내 우주 입력하기', style: AppTextStyles.primaryButton),
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: controller.goToGuest,
            child: Text('유람 먼저 둘러보기',
                style: AppTextStyles.onboardingSubButton),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Star Particles
// ---------------------------------------------------------------------------

class _StarParticles extends StatelessWidget {
  const _StarParticles();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarParticlesPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _StarParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.starColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final positions = List.generate(18, (i) {
      final localRandom = Random(i * 137 + 42);
      return Offset(
        localRandom.nextDouble() * size.width,
        localRandom.nextDouble() * size.height,
      );
    });

    for (int i = 0; i < positions.length; i++) {
      final sizeRandom = Random(i * 97 + 13);
      final radius = 1.0 + sizeRandom.nextDouble() * 2.0;
      canvas.drawCircle(positions[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Constellation Painters
// ---------------------------------------------------------------------------

class _TopLeftConstellation extends StatelessWidget {
  const _TopLeftConstellation();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      width: 200,
      height: 200,
      child: CustomPaint(painter: _TopLeftConstellationPainter()),
    );
  }
}

class _TopLeftConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.constellationColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.starColor
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.10, size.height * 0.15),
      Offset(size.width * 0.25, size.height * 0.30),
      Offset(size.width * 0.18, size.height * 0.50),
      Offset(size.width * 0.40, size.height * 0.42),
      Offset(size.width * 0.55, size.height * 0.20),
      Offset(size.width * 0.45, size.height * 0.08),
    ];

    final connections = [
      [0, 1],
      [1, 2],
      [1, 3],
      [3, 4],
      [4, 5],
      [5, 0],
    ];

    for (final conn in connections) {
      canvas.drawLine(points[conn[0]], points[conn[1]], linePaint);
    }
    for (final point in points) {
      canvas.drawCircle(point, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomRightConstellation extends StatelessWidget {
  const _BottomRightConstellation();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      width: 220,
      height: 220,
      child: CustomPaint(painter: _BottomRightConstellationPainter()),
    );
  }
}

class _BottomRightConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.constellationColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.starColor
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.90, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.28),
      Offset(size.width * 0.85, size.height * 0.48),
      Offset(size.width * 0.60, size.height * 0.40),
      Offset(size.width * 0.50, size.height * 0.65),
      Offset(size.width * 0.70, size.height * 0.80),
      Offset(size.width * 0.92, size.height * 0.72),
    ];

    final connections = [
      [0, 1],
      [1, 2],
      [1, 3],
      [3, 4],
      [4, 5],
      [5, 6],
      [6, 2],
    ];

    for (final conn in connections) {
      canvas.drawLine(points[conn[0]], points[conn[1]], linePaint);
    }
    for (final point in points) {
      canvas.drawCircle(point, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
