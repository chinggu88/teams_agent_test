import 'package:flutter/material.dart';

/// 앱 전역 컬러 팔레트.
///
/// - **다크(우주) 테마**: 기본 온보딩 / 인증 / 리포트 화면에 사용한다.
/// - **라이트 테마**: 라이트 모드 또는 본문 가독성이 중요한 화면에 사용한다.
///
/// 모든 화면의 색상은 본 클래스 상수를 참조해야 하며, 위젯 내부에서 hex 값을
/// 직접 하드코딩해서는 안 된다. (브랜드 SDK 가이드라인이 강제하는
/// 카카오 노란색 / 구글 G 컬러 같은 외부 브랜드 컬러는 예외)
class AppColors {
  // ---------------------------------------------------------------------------
  // Dark (Cosmic) Theme — 기본 테마
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFF1A0A3B);
  static const Color backgroundGradientTop = Color(0xFF0D0620);
  static const Color backgroundGradientBottom = Color(0xFF2D1060);

  static const Color surface = Color(0xFF1F0E48);
  static const Color surfaceSubtle = Color(0xFF291566);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xCCFFFFFF);
  static const Color textTertiary = Color(0x99FFFFFF);

  // ---------------------------------------------------------------------------
  // Light Theme — 라이트 모드 / 본문 위주 화면
  // ---------------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightBackgroundGradientTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundGradientBottom = Color(0xFFF6F4FF);

  static const Color lightSurface = Color(0xFFF7F7FB);
  static const Color lightSurfaceSubtle = Color(0xFFEFEDF7);

  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xCC1A1A1A);
  static const Color lightTextTertiary = Color(0x991A1A1A);

  static const Color lightDivider = Color(0xFFE5E5EA);
  static const Color lightBorder = Color(0xFFDDDDDD);

  // ---------------------------------------------------------------------------
  // Common
  // ---------------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteSubtle = Color(0xCCFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black87 = Color(0xDD000000);

  static const Color primaryPurple = Color(0xFF7B4FFF);
  static const Color primaryPurpleLight = Color(0xFF9B6FFF);

  static const Color starColor = Color(0xFFFFFFFF);
  static const Color constellationColor = Color(0xAAFFFFFF);

  // ---------------------------------------------------------------------------
  // Brand — SNS Login Buttons
  // ---------------------------------------------------------------------------

  /// 카카오 공식 버튼 배경 (Kakao Yellow)
  static const Color kakaoYellow = Color(0xFFFEE500);

  /// 카카오 공식 버튼 텍스트/아이콘
  static const Color kakaoText = Color(0xFF191919);

  /// 구글 공식 버튼 테두리 (Google sign-in branding stroke)
  static const Color googleBorder = Color(0xFFDDDDDD);

  /// 구글 공식 'G' 로고 컬러
  static const Color googleBrandBlue = Color(0xFF4285F4);
}
