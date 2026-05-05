---
name: testuram 프로젝트 UI 패턴
description: testuram Flutter 프로젝트의 디자인 시스템, 위젯 구조, 레이아웃 패턴
type: project
---

## 디자인 시스템

- 배경: LinearGradient(backgroundGradientTop → backgroundGradientBottom)
- 메인 컬러: AppColors.primaryPurple (0xFF7B4FFF), Light: AppColors.primaryPurpleLight (0xFF9B6FFF)
- 텍스트: AppColors.white, AppColors.whiteSubtle (0xCCFFFFFF)
- 다크 코스믹 테마 기반

## AppTextStyles 사용 패턴

- onboardingTitle: 섹션 제목 (20.sp, w500)
- onboardingSubButton: 부제목/힌트 (14.sp, w400, whiteSubtle)
- primaryButton: 버튼 텍스트 (16.sp, w600, white)

## 위젯 구조

- GetView<Controller> 패턴 사용
- Obx는 observable을 직접 참조하는 최소 범위에만 적용
- ScreenUtil: .w, .h, .sp, .r 필수
- 입력 필드: underline border (enabledBorder/focusedBorder)
- 버튼: ElevatedButton with RoundedRectangleBorder(radius: 50.r) or 10~12.r
- 컨테이너: white.withValues(alpha: 0.08) 배경, white.withValues(alpha: 0.15) 보더

## user_info 모듈

- 경로: lib/app/modules/user_info/
- 컨트롤러: UserInfoController (pageController, currentStep 등 PageView 관련 유지)
- 뷰: SingleChildScrollView + Column 구조로 변경됨 (PageView 제거)
- 바텀시트: _HanjaBottomSheet(한자 찾기), _LocationSearchBottomSheet(지역 검색) — 뷰 파일 내 private 클래스
- 하단 버튼: '우주 리포트 열기' → controller.submit() 호출

## 공통 패턴

- SafeArea + GestureDetector(onTap: FocusScope.unfocus)
- 섹션 구분: Container(height: 1.h, color: white.withValues(alpha: 0.10))
- 섹션 레이블: 소형 텍스트 + * 필수 표시
- 라디오 버튼: 커스텀 원형 컨테이너 (_buildRadioCircle)
- 하단 고정 버튼: gradient 배경 Container + Obx(() => ElevatedButton)
