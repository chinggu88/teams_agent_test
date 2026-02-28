```
lib/
├── main.dart                              # 앱 진입점 및 GetMaterialApp 초기화
│
└── app/                                   # [앱 메인] 애플리케이션 로직
    │
    ├── routes/                            # [라우팅] GetX 네비게이션 관리
    │   ├── app_pages.dart                 # GetPage 정의 및 라우트-페이지 매핑
    │   └── app_routes.dart                # 라우트 경로 상수 (Routes.COUNTER 등)
    │
    ├── modules/                           # [모듈] 기능별 MVC 패턴 구현
    │   │
    │   └── counter/                       # [카운터] 카운터 기능 모듈
    │       ├── bindings/                  # 의존성 주입 설정
    │       │   └── counter_binding.dart   # CounterController 바인딩
    │       ├── controllers/               # 비즈니스 로직
    │       │   └── counter_controller.dart # 카운터 증감 로직 및 상태 관리
    │       └── views/                     # UI 화면
    │           └── counter_view.dart      # 카운터 화면 UI
    │
    ├── core/                              # [코어] 앱 전역 설정 및 유틸리티 (구조만 준비)
    │   └── values/                        # 앱 전역 상수 값 (아직 파일 없음)
    │
    ├── data/                              # [데이터] 데이터 레이어 (모델 + 저장소) (구조만 준비)
    │   ├── models/                        # API 요청/응답 데이터 구조 (아직 파일 없음)
    │   └── repositories/                  # Controller와 API 사이 중간 레이어 (아직 파일 없음)
    │
    └── bindings/                          # [전역 바인딩] 앱 시작 시 초기화되는 의존성 (구조만 준비)
        └── initial_binding.dart           # (아직 파일 없음) 전역 서비스/컨트롤러 바인딩

└── views/                                 # [공통 위젯] 재사용 가능한 공통 UI 컴포넌트 (구조만 준비)
    └── widgets/                           # 공통 위젯 폴더
        └── common/                        # 공통 UI 컴포넌트 (아직 파일 없음)
```