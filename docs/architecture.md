```
lib/
├── main.dart                              # 앱 진입점 및 서비스 초기화
│
├── app/                                   # 메인 애플리케이션 로직
│   │
│   ├── bindings/                          # [전역 바인딩] 앱 시작 시 초기화되는 의존성
│   │   └── initial_binding.dart           # 앱 초기화 시 전역 서비스/컨트롤러 바인딩
│   │
│   ├── routes/                            # [라우팅] GetX 네비게이션 관리
│   │   ├── app_pages.dart                 # GetPage 정의 및 라우트-페이지 매핑
│   │   └── app_routes.dart                # 라우트 경로 상수 (Routes.HOME 등)
│   │
│   ├── modules/                           # [모듈] 기능별 MVC 패턴 구현
│   │   │
│   │   ├── auth/                          # [인증] 로그인 모듈
│   │   │   ├── bindings/                  # 의존성 주입 설정
│   │   │   │   └── login_binding.dart     # LoginController 바인딩
│   │   │   ├── controllers/               # 비즈니스 로직
│   │   │   │   └── login_controller.dart  # 로그인 로직 및 상태 관리
│   │   │   └── views/                     # UI 화면
│   │   │       └── login_view.dart        # 로그인 화면
│   │   │
│   │   └── main/                          # [메인] 앱 메인 컨테이너
│   │       ├── bindings/                  # 의존성 주입 설정
│   │       │   └── main_binding.dart      # MainController 바인딩
│   │       ├── controllers/               # 비즈니스 로직
│   │       │   ├── main_controller.dart   # 바텀 네비게이션, 탭 전환
│   │       │   └── drawer_controller.dart # 사이드 드로어 상태 관리
│   │       └── views/                     # UI 화면
│   │           └── main_view.dart         # 메인 레이아웃 (네비게이션 + 드로어)
│   │
│   ├── data/                              # [데이터] 데이터 레이어 (모델 + 저장소)
│   │   │
│   │   ├── models/                        # [모델] API 요청/응답 데이터 구조
│   │   │   ├── login_parameter.dart       # 로그인 요청 파라미터 (toJson 메서드 포함)
│   │   │   ├── login_response.dart        # 로그인 응답 모델 (fromJson 메서드 포함)
│   │   │   ├── login_user_response.dart   # 로그인 사용자 정보 응답 모델
│   │   │   ├── *Parameter.dart            # API 요청 파라미터 (toJson 메서드 포함)
│   │   │   └── *Response.dart             # API 응답 모델 (fromJson 메서드 포함)
│   │   │
│   │   └── repositories/                  # [저장소] Controller와 API 사이 중간 레이어
│   │       ├── auth_repository.dart       # 인증 API (로그인, 회원가입)
│   │       └── app_repository.dart        # 앱 설정 API (버전 체크, 공지사항)
│   │
│   ├── core/                              # [코어] 앱 전역 설정 및 유틸리티
│   │   │
│   │   ├── enums/                         # [열거형] 타입 정의
│   │   │
│   │   ├── values/                        # [상수] 앱 전역 상수 값
│   │   │   ├── colors.dart                # 색상 팔레트 (AppColors 클래스)
│   │   │   ├── text_styles.dart           # 텍스트 스타일 (AppTextStyles 클래스)
│   │   │   └── strings.dart               # 문자열 상수 (AppStrings.appName 등)
│   │   │
│   │   ├── theme/                         # [테마] 앱 테마 설정
│   │   │   └── app_theme.dart             # 라이트/다크 테마 정의
│   │   │
│   │   └── utils/                         # [유틸리티] 헬퍼 함수 모음
│   │       ├── helpers.dart               # 범용 헬퍼 (날짜, 문자열 처리)
│   │       ├── function.dart              # 공통 비즈니스 함수
│   │
│   └── widgets/                           # [위젯] 재사용 가능한 공통 UI 컴포넌트
│       ├── common_button.dart             # 공통 버튼 (로딩 상태 포함)
│       ├── common_dialog.dart             # 공통 다이얼로그 (확인, 취소)
│       ├── custom_app_bar.dart            # 커스텀 앱바 (뒤로가기, 타이틀)
│       └── error_dialog.dart              # 에러 다이얼로그 (API 오류 표시)
│
└── services/                              # [서비스] 앱 전역 서비스 (5개 파일)
    ├── api_service.dart                   # API 통신 (HTTP 요청, 인터셉터, 토큰 관리)
    ├── app_service.dart                   # 앱 상태 관리 (라이프사이클)
```