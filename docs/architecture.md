```
lib/
├── main.dart                              # 앱 진입점 및 GetMaterialApp 초기화
│
├── app/                                   # [앱 메인] 애플리케이션 로직
│   │
│   ├── routes/                            # [라우팅] GetX 네비게이션 관리
│   │   ├── app_pages.dart                 # GetPage 정의 및 라우트-페이지 매핑
│   │   └── app_routes.dart                # 라우트 경로 상수
│   │
│   ├── modules/                           # [모듈] 기능별 MVC 패턴 구현
│   │   ├── home/                          # [홈] 홈 화면 모듈
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart      # HomeController 의존성 주입
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart   # 홈 화면 비즈니스 로직
│   │   │   └── views/
│   │   │       └── home_view.dart         # 홈 화면 UI
│   │   │
│   │   ├── login/                         # [로그인] 로그인 인증 모듈
│   │   │   ├── bindings/
│   │   │   │   └── login_binding.dart     # LoginController 의존성 주입
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart  # 로그인 비즈니스 로직
│   │   │   └── views/
│   │   │       └── login_view.dart        # 로그인 화면 UI
│   │   │
│   │   ├── profile/                       # [프로필] 사용자 프로필 모듈
│   │   │   ├── bindings/
│   │   │   │   └── profile_binding.dart   # ProfileController 의존성 주입
│   │   │   ├── controllers/
│   │   │   │   └── profile_controller.dart # 프로필 비즈니스 로직
│   │   │   └── views/
│   │   │       └── profile_view.dart      # 프로필 화면 UI
│   │   │
│   │   ├── settings/                      # [설정] 앱 설정 관리 모듈
│   │   │   ├── bindings/
│   │   │   │   └── settings_binding.dart  # SettingsController 의존성 주입
│   │   │   ├── controllers/
│   │   │   │   └── settings_controller.dart # 설정 상태 관리
│   │   │   └── views/
│   │   │       └── settings_view.dart     # 설정 화면 UI
│   │   │
│   │   ├── timer/                         # [타이머] 타이머 기능 모듈
│   │   │   ├── bindings/
│   │   │   │   └── timer_binding.dart     # TimerController 의존성 주입
│   │   │   ├── controllers/
│   │   │   │   └── timer_controller.dart  # 타이머 로직 및 상태 관리
│   │   │   └── views/
│   │   │       └── timer_view.dart        # 타이머 화면 UI
│   │   │
│   │   └── main/                          # [메인] 메인 네비게이션 모듈
│   │       ├── bindings/
│   │       │   └── main_binding.dart      # MainController 의존성 주입
│   │       ├── controllers/
│   │       │   └── main_controller.dart   # 메인 화면 네비게이션 로직
│   │       └── views/
│   │           └── main_view.dart         # 메인 화면 UI
│   │
│   ├── core/                              # [코어] 앱 전역 설정 및 유틸리티
│   │   ├── values/                        # 앱 전역 상수값 및 스타일
│   │   │   ├── app_colors.dart            # 앱 색상 팔레트 정의
│   │   │   └── app_text_styles.dart       # 텍스트 스타일 정의
│   │   │
│   │   └── theme/                         # 앱 테마 관리
│   │       ├── light_theme.dart           # 라이트 모드 테마
│   │       └── dark_theme.dart            # 다크 모드 테마
│   │
│   ├── data/                              # [데이터] 데이터 레이어 (모델 + 저장소)
│   │   ├── models/                        # API 요청/응답 데이터 구조
│   │   │   ├── user_model.dart            # 사용자 데이터 모델
│   │   │   └── auth_model.dart            # 인증 데이터 모델
│   │   │
│   │   └── repositories/                  # Controller와 API 사이 중간 레이어
│   │       ├── user_repository.dart       # 사용자 관련 API 호출
│   │       └── auth_repository.dart       # 인증 관련 API 호출
│   │
│   └── bindings/                          # [전역 바인딩] 앱 시작 시 초기화되는 의존성
│       └── initial_binding.dart           # 전역 서비스/컨트롤러 바인딩
│
└── services/                              # [글로벌 서비스] GetxService 기반 싱글톤 서비스
    ├── api_service.dart                   # Dio 기반 HTTP 클라이언트 및 API 관리
    ├── auth_service.dart                  # 인증 상태 및 토큰 관리
    └── theme_service.dart                 # 테마 전환 로직
```