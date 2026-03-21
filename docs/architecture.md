```
lib/
├── main.dart                              # 앱 진입점 및 GetMaterialApp 초기화
│
├── app/                                   # [앱 메인] 애플리케이션 로직
│   │
│   ├── bindings/                          # [글로벌 바인딩] 앱 초기화 시 의존성 주입
│   │   └── initial_binding.dart           # 초기 서비스 및 레포지토리 바인딩
│   │
│   ├── routes/                            # [라우팅] GetX 네비게이션 관리
│   │   ├── app_pages.dart                 # GetPage 정의 및 라우트-페이지 매핑
│   │   └── app_routes.dart                # 라우트 경로 상수
│   │
│   ├── modules/                           # [모듈] 기능별 MVC 패턴 구현
│   │   │
│   │   ├── onboarding/                    # [온보딩] 앱 최초 실행 시 안내 화면
│   │   │   ├── bindings/
│   │   │   │   └── onboarding_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── onboarding_controller.dart
│   │   │   └── views/
│   │   │       └── onboarding_view.dart
│   │   │
│   │   ├── login/                         # [로그인] 로그인 인증 모듈
│   │   │   ├── bindings/
│   │   │   │   └── login_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart
│   │   │   └── views/
│   │   │       └── login_view.dart
│   │   │
│   │   ├── home/                          # [홈] 할 일 목록 메인 화면
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart
│   │   │   └── views/
│   │   │       └── home_view.dart
│   │   │
│   │   ├── todo_add/                      # [할 일 추가] 새 할 일 등록
│   │   │   ├── bindings/
│   │   │   │   └── todo_add_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── todo_add_controller.dart
│   │   │   └── views/
│   │   │       └── todo_add_view.dart
│   │   │
│   │   ├── todo_detail/                   # [할 일 상세] 할 일 상세 및 수정/삭제
│   │   │   ├── bindings/
│   │   │   │   └── todo_detail_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── todo_detail_controller.dart
│   │   │   └── views/
│   │   │       └── todo_detail_view.dart
│   │   │
│   │   ├── completed/                     # [완료 목록] 완료된 할 일 관리
│   │   │   ├── bindings/
│   │   │   │   └── completed_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── completed_controller.dart
│   │   │   └── views/
│   │   │       └── completed_view.dart
│   │   │
│   │   └── my_page/                       # [마이페이지] 프로필 및 설정
│   │       ├── bindings/
│   │       │   └── my_page_binding.dart
│   │       ├── controllers/
│   │       │   └── my_page_controller.dart
│   │       └── views/
│   │           └── my_page_view.dart
│   │
│   ├── data/                              # [데이터] 데이터 레이어 (모델 + 저장소)
│   │   ├── models/                        # API 요청/응답 데이터 구조
│   │   │   ├── user_model.dart            # 사용자 데이터 모델
│   │   │   ├── auth_response_model.dart   # 인증 응답 모델
│   │   │   ├── todo_model.dart            # 할 일 데이터 모델
│   │   │   ├── todo_list_response_model.dart # 할 일 목록 응답 모델
│   │   │   ├── tag_model.dart             # 태그 데이터 모델
│   │   │   ├── create_todo_parameter.dart # 할 일 생성 요청 파라미터
│   │   │   ├── update_todo_parameter.dart # 할 일 수정 요청 파라미터
│   │   │   ├── update_user_parameter.dart # 사용자 정보 수정 요청 파라미터
│   │   │   └── update_notification_parameter.dart # 알림 설정 수정 요청 파라미터
│   │   │
│   │   └── repositories/                  # Controller와 API 사이 중간 레이어
│   │       ├── auth_repository.dart       # 인증 관련 API 호출
│   │       ├── todo_repository.dart       # 할 일 관련 API 호출
│   │       ├── user_repository.dart       # 사용자 관련 API 호출
│   │       └── tag_repository.dart        # 태그 관련 API 호출
│   │
│   ├── widgets/                           # [위젯] 앱 전역 재사용 UI 컴포넌트
│   │   ├── widgets.dart                   # 위젯 배럴 파일 (export 모음)
│   │   ├── app_button.dart                # 공통 버튼 위젯
│   │   ├── app_text_field.dart            # 공통 텍스트 입력 위젯
│   │   ├── todo_card_widget.dart          # 할 일 카드 위젯
│   │   ├── bottom_nav_bar.dart            # 하단 네비게이션 바 위젯
│   │   ├── priority_badge.dart            # 우선순위 배지 위젯
│   │   ├── tag_chip.dart                  # 태그 칩 위젯
│   │   ├── empty_state.dart               # 빈 상태 표시 위젯
│   │   ├── loading_state.dart             # 로딩 상태 표시 위젯
│   │   └── error_state.dart               # 에러 상태 표시 위젯
│   │
│   └── core/                              # [코어] 앱 전역 설정 및 유틸리티
│       ├── enums/                         # 앱 전역 열거형 정의
│       │   ├── priority.dart              # 우선순위 enum (high, medium, low)
│       │   ├── social_provider.dart       # 소셜 로그인 제공자 enum
│       │   ├── theme_mode.dart            # 테마 모드 enum (light, dark, system)
│       │   └── todo_filter.dart           # 할 일 필터 enum (all, today, upcoming)
│       │
│       └── values/                        # 앱 전역 상수값 및 스타일
│           ├── app_colors.dart            # 앱 색상 팔레트 정의
│           └── app_text_styles.dart       # 텍스트 스타일 정의
│
└── services/                              # [글로벌 서비스] GetxService 기반 싱글톤 서비스
    ├── api_service.dart                   # Dio 기반 HTTP 클라이언트 및 API 관리
    └── easyloading_service.dart           # 로딩/토스트 메시지 서비스
```
