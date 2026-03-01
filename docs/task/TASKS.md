# TASKS

팀장 Agent가 이 파일을 읽고 사용자 흐름을 분석하여 각 Agent에게 작업을 할당합니다.

---

## 현재 작업

<!-- 새 태스크는 여기에 추가됩니다 -->

---

## 완료된 작업

### TASK-001: 다크모드 지원

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 디자인 | 없음 |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[설정 화면 진입] → [다크모드 토글 스위치 확인] → [토글 탭] → [테마 즉시 변경] → [GetStorage에 저장]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 저장 실패 | GetStorage 오류 | 기본 테마(라이트) 유지, 스낵바 알림 |
| 앱 재시작 | 앱 종료 후 재실행 | GetStorage에서 저장된 테마 복원 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 테마 전환 | 라이트/다크 모드 토글 | 설정 화면 토글 스위치 탭 |
| 테마 저장 | 선택한 테마를 로컬에 저장 | 테마 변경 시 자동 저장 |
| 테마 복원 | 앱 시작 시 저장된 테마 적용 | 앱 시작 시 |
| AppColors 분리 | 라이트/다크 모드별 색상 정의 | 테마 변경 시 |

#### 4. API 정보
- API 호출 없음 (로컬 기능)

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 다크모드 토글 | Switch | 라이트/다크 전환 스위치 |
| 테마 프리뷰 | Container | 현재 테마 미리보기 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 없음 (로컬 기능) | - | - |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| ThemeController | `lib/app/modules/settings/controllers/settings_controller.dart` | completed |
| ThemeService | `lib/services/theme_service.dart` | completed |
| AppColors 정의 | `lib/app/core/values/app_colors.dart` | completed |
| AppTextStyles 정의 | `lib/app/core/values/app_text_styles.dart` | completed |
| 라이트 테마 | `lib/app/core/theme/light_theme.dart` | completed |
| 다크 테마 | `lib/app/core/theme/dark_theme.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 설정 화면 | `lib/app/modules/settings/views/settings_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

### TASK-002: 타이머 화면 추가

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | medium |
| 디자인 | 없음 |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[타이머 탭 진입] → [시간 설정] → [시작 버튼 탭] → [카운트다운 진행] → [완료 시 알림]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 사용자 취소 | 정지 버튼 탭 | 타이머 일시정지, 재개/리셋 옵션 |
| 앱 백그라운드 | 앱 백그라운드 전환 | 타이머 계속 진행 (백그라운드 처리) |
| 시간 미설정 | 0초 상태에서 시작 | 시작 버튼 비활성화 |
| 중복 요청 | 시작 버튼 연속 탭 | 로딩 중 버튼 비활성화 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 타이머 설정 | 시/분/초 설정 | 시간 선택 위젯 조작 |
| 타이머 시작 | 카운트다운 시작 | 시작 버튼 탭 |
| 타이머 일시정지 | 카운트다운 일시정지 | 일시정지 버튼 탭 |
| 타이머 재개 | 카운트다운 재개 | 재개 버튼 탭 |
| 타이머 리셋 | 타이머 초기화 | 리셋 버튼 탭 |
| 완료 알림 | 타이머 종료 시 알림 | 카운트다운 0 도달 |

#### 4. API 정보
- API 호출 없음 (로컬 기능)

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 시간 표시 | Text | 남은 시간 (HH:MM:SS) |
| 시간 선택 | CupertinoPicker | 시/분/초 설정 |
| 시작/정지 버튼 | ElevatedButton | 타이머 시작/일시정지 |
| 리셋 버튼 | TextButton | 타이머 초기화 |
| 프로그레스 | CircularProgressIndicator | 진행률 표시 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 없음 (로컬 기능) | - | - |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TimerController | `lib/app/modules/timer/controllers/timer_controller.dart` | completed |
| TimerBinding | `lib/app/modules/timer/bindings/timer_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 타이머 화면 | `lib/app/modules/timer/views/timer_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

### TASK-003: 프로필 화면 추가

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | medium |
| 디자인 | 없음 |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[프로필 탭 진입] → [사용자 정보 로딩] → [프로필 표시 (이름, 이메일, 프로필 이미지)] → [편집 버튼 탭] → [정보 수정] → [저장]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| API 실패 | 네트워크 오류, 서버 오류 | 에러 메시지 표시, 재시도 옵션 |
| 데이터 없음 | 프로필 정보 없음 | 기본 프로필 UI 표시 |
| 유효성 검증 실패 | 잘못된 입력값 | 입력 필드 에러 표시 |
| 권한 부족 | 인증 만료 | 로그인 화면 이동 |
| 사용자 취소 | 뒤로가기, 취소 버튼 | 이전 화면으로 복귀 |
| 타임아웃 | 응답 지연 | 타임아웃 메시지, 재시도 옵션 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 프로필 조회 | 사용자 정보 표시 (이름, 이메일, 프로필 이미지) | 화면 진입 시 |
| 프로필 편집 | 사용자 정보 수정 | 편집 버튼 탭 |
| 프로필 저장 | 수정된 정보 저장 | 저장 버튼 탭 |
| 로그아웃 | 로그아웃 처리 | 로그아웃 버튼 탭 |

#### 4. API 정보
**프로필 조회**
- **Method**: `GET`
- **Endpoint**: `/api/user/profile`
- **Request**: 없음 (헤더에 토큰 포함)
- **Response (성공)**:
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "profile_image": "string"
}
```
- **Response (실패)**:
```json
{ "error": "UNAUTHORIZED", "message": "인증이 필요합니다" }
```

**프로필 수정**
- **Method**: `PUT`
- **Endpoint**: `/api/user/profile`
- **Request**:
```json
{
  "name": "string",
  "email": "string"
}
```
- **Response (성공)**:
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "profile_image": "string"
}
```
- **Response (실패)**:
```json
{ "error": "VALIDATION_ERROR", "message": "유효하지 않은 입력입니다" }
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 프로필 이미지 | CircleAvatar | 사용자 프로필 이미지 |
| 이름 | Text | 사용자 이름 표시 |
| 이메일 | Text | 사용자 이메일 표시 |
| 편집 버튼 | IconButton | 프로필 편집 모드 전환 |
| 로그아웃 버튼 | TextButton | 로그아웃 처리 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| UserModel | `lib/app/data/models/user_model.dart` | completed |
| UserRepository | `lib/app/data/repositories/user_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| ProfileController | `lib/app/modules/profile/controllers/profile_controller.dart` | completed |
| ProfileBinding | `lib/app/modules/profile/bindings/profile_binding.dart` | completed |
> 의존: API Agent 완료 후

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 프로필 화면 | `lib/app/modules/profile/views/profile_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

### TASK-004: 로그인 화면 추가

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 디자인 | 없음 |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[앱 시작] → [로그인 화면] → [이메일/비밀번호 입력] → [로그인 버튼 탭] → [API 호출] → [토큰 저장] → [메인 화면 이동]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| API 실패 | 네트워크 오류, 서버 오류 | 에러 메시지 스낵바, 재시도 옵션 |
| 유효성 검증 실패 | 빈 이메일/비밀번호, 이메일 형식 오류 | 입력 필드 에러 표시 |
| 로그인 실패 | 잘못된 자격 증명 | "이메일 또는 비밀번호가 올바르지 않습니다" 메시지 |
| 타임아웃 | 응답 지연 | 타임아웃 메시지, 재시도 옵션 |
| 중복 요청 | 로그인 버튼 연속 탭 | 로딩 중 버튼 비활성화 |
| 자동 로그인 | 저장된 토큰 존재 | 토큰 유효성 확인 후 메인 화면 이동 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 이메일 입력 | 이메일 주소 입력 필드 | 사용자 입력 시 |
| 비밀번호 입력 | 비밀번호 입력 필드 (마스킹) | 사용자 입력 시 |
| 이메일 검증 | 이메일 형식 유효성 검사 | 입력 시 실시간 검증 |
| 비밀번호 검증 | 비밀번호 최소 길이 검사 | 입력 시 실시간 검증 |
| 로그인 | API 호출로 인증 처리 | 로그인 버튼 탭 |
| 자동 로그인 | 저장된 토큰으로 자동 인증 | 앱 시작 시 |
| 비밀번호 표시/숨김 | 비밀번호 가시성 토글 | 아이콘 버튼 탭 |

#### 4. API 정보
**로그인**
- **Method**: `POST`
- **Endpoint**: `/api/auth/login`
- **Request**:
```json
{
  "email": "string",
  "password": "string"
}
```
- **Response (성공)**:
```json
{
  "access_token": "string",
  "refresh_token": "string",
  "user": {
    "id": "string",
    "name": "string",
    "email": "string"
  }
}
```
- **Response (실패)**:
```json
{ "error": "INVALID_CREDENTIALS", "message": "이메일 또는 비밀번호가 올바르지 않습니다" }
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 앱 로고 | Image | 상단 로고 이미지 |
| 이메일 필드 | TextField | 이메일 입력 (키보드: email) |
| 비밀번호 필드 | TextField | 비밀번호 입력 (obscure) |
| 비밀번호 표시 토글 | IconButton | 비밀번호 가시성 토글 |
| 로그인 버튼 | ElevatedButton | 로그인 실행 |
| 로딩 인디케이터 | CircularProgressIndicator | API 호출 중 표시 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| AuthModel (LoginRequest/Response) | `lib/app/data/models/auth_model.dart` | completed |
| AuthRepository | `lib/app/data/repositories/auth_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginController | `lib/app/modules/login/controllers/login_controller.dart` | completed |
| LoginBinding | `lib/app/modules/login/bindings/login_binding.dart` | completed |
| AuthService | `lib/services/auth_service.dart` | completed |
> 의존: API Agent 완료 후

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 로그인 화면 | `lib/app/modules/login/views/login_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

### TASK-005: 바텀 네비게이션 추가

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 디자인 | 없음 |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[로그인 완료] → [메인 화면 (바텀네비)] → [탭 전환: 홈/타이머/프로필/설정] → [각 탭 화면 표시]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 권한 부족 | 미인증 상태에서 접근 | 로그인 화면 이동 |
| 데이터 없음 | 탭 전환 시 데이터 없음 | Empty State UI 표시 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 탭 전환 | 홈/타이머/프로필/설정 탭 전환 | 바텀네비 아이콘 탭 |
| 탭 상태 유지 | 탭 전환 시 이전 상태 유지 | 탭 전환 시 |
| 현재 탭 표시 | 선택된 탭 하이라이트 | 탭 전환 시 |

#### 4. API 정보
- API 호출 없음 (네비게이션 기능)

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 바텀네비게이션 바 | BottomNavigationBar | 4개 탭 네비게이션 |
| 홈 탭 | BottomNavigationBarItem | 아이콘: Icons.home |
| 타이머 탭 | BottomNavigationBarItem | 아이콘: Icons.timer |
| 프로필 탭 | BottomNavigationBarItem | 아이콘: Icons.person |
| 설정 탭 | BottomNavigationBarItem | 아이콘: Icons.settings |
| 페이지 뷰 | PageView/IndexedStack | 탭별 화면 컨테이너 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 없음 (네비게이션 기능) | - | - |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| MainController | `lib/app/modules/main/controllers/main_controller.dart` | completed |
| MainBinding | `lib/app/modules/main/bindings/main_binding.dart` | completed |
| HomeController | `lib/app/modules/home/controllers/home_controller.dart` | completed |
| HomeBinding | `lib/app/modules/home/bindings/home_binding.dart` | completed |
| SettingsBinding | `lib/app/modules/settings/bindings/settings_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| 메인 화면 (바텀네비) | `lib/app/modules/main/views/main_view.dart` | completed |
| 홈 화면 | `lib/app/modules/home/views/home_view.dart` | completed |
> 의존: Controller Agent 완료 후

---

> **참조**: 새 태스크 작성 시 `docs/task/TASKS_GUIDE.md` 포맷을 따릅니다.
