# TodoList 태스크 목록

> 생성일: 2026-03-08
> 참조: todolist_backend_spec.md, todolist_designer_spec.md, figma_screen_mapping.md

---

## TASK-001: S01 온보딩 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S01 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-70&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[앱 최초 실행] → [온보딩 화면] → [슬라이드 스와이프 (3페이지)] → [시작하기 버튼 탭] → [로그인 화면]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 건너뛰기 | 건너뛰기 링크 탭 | 로그인 화면으로 즉시 이동 |
| 사용자 취소 | 뒤로가기 | 앱 종료 확인 다이얼로그 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 슬라이드 스와이프 | 3페이지 온보딩 슬라이드 전환 | 좌우 스와이프 |
| 페이지 인디케이터 | 현재 페이지 표시 (3개 도트) | 페이지 전환 시 |
| 시작하기 | 로그인 화면으로 이동 | 버튼 탭 |
| 건너뛰기 | 온보딩 스킵하고 로그인 이동 | 링크 탭 |

#### 4. API 정보
> 온보딩 화면은 API 호출 없음 (로컬 UI 전용)

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 앱 아이콘/일러스트 | Image | 각 페이지별 일러스트 |
| 페이지 인디케이터 | PageIndicator | 3개 도트 |
| 온보딩 메시지 | Text/Title | "할 일을 쉽고 빠르게 관리하세요" |
| 설명 문구 | Text/Body | 상세 설명 |
| 시작하기 버튼 | Button/Primary | 로그인 화면 이동 |
| 건너뛰기 | Link | 온보딩 스킵 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| - | - | - |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| OnboardingController | `lib/app/modules/onboarding/controllers/onboarding_controller.dart` | completed |
| OnboardingBinding | `lib/app/modules/onboarding/bindings/onboarding_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| OnboardingView | `lib/app/modules/onboarding/views/onboarding_view.dart` | completed |

---

## TASK-002: S02 로그인 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S02 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-2&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[로그인 화면] → [이메일/PW 입력] → [로그인 버튼 탭] → [로딩 스피너] → [홈 화면]
```
```
[로그인 화면] → [소셜 로그인 버튼 탭] → [OAuth 인증] → [홈 화면]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 로그인 실패 | 잘못된 이메일/비밀번호 | 토스트: "이메일 또는 비밀번호가 올바르지 않습니다" |
| 유효성 검증 실패 | 이메일 형식 오류 | 입력 필드 에러 표시 |
| 네트워크 오류 | API 호출 실패 | 에러 토스트, 재시도 옵션 |
| 소셜 로그인 취소 | OAuth 창 닫기 | 로그인 화면 유지 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 이메일 입력 | 이메일 주소 입력 | 텍스트 입력 |
| 비밀번호 입력 | 비밀번호 입력 (마스킹) | 텍스트 입력 |
| 비밀번호 표시/숨김 | 비밀번호 가시성 토글 | Eye 아이콘 탭 |
| 로그인 | 이메일/PW 로그인 | 로그인 버튼 탭 |
| Google 로그인 | Google OAuth 로그인 | 버튼 탭 |
| Apple 로그인 | Apple OAuth 로그인 | 버튼 탭 |
| 회원가입 이동 | 회원가입 화면 이동 | 링크 탭 |

#### 4. API 정보

**A02. 로그인 (Login)**
- **Method**: `POST`
- **Endpoint**: `/auth/login`
- **Request**:
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```
- **Response (성공)**:
```json
{
  "token": "string",
  "user": {
    "id": "int",
    "email": "string",
    "nickname": "string?"
  }
}
```
- **Response (실패)**:
```json
{
  "code": "INVALID_CREDENTIALS",
  "message": "이메일 또는 비밀번호가 올바르지 않습니다"
}
```

**A03. 소셜 로그인 (Social Login)**
- **Method**: `POST`
- **Endpoint**: `/auth/social`
- **Request**:
```json
{
  "provider": "google | apple",
  "accessToken": "string"
}
```
- **Response (성공)**:
```json
{
  "token": "string",
  "user": {
    "id": "int",
    "email": "string",
    "nickname": "string?",
    "socialProvider": "google | apple"
  }
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | "회원로그인" |
| 앱 로고 | Image/Icon | 앱 로고 이미지 |
| 이메일 입력 | Input/Email | placeholder: "example@email.com" |
| 비밀번호 입력 | Input/Password | Eye 아이콘으로 표시/숨김 토글 |
| 로그인 버튼 | Button/Primary | 메인 로그인 버튼 |
| 구분선 | Divider | "또는" |
| Google 로그인 | Button/Social | Google OAuth |
| Apple 로그인 | Button/Social | Apple OAuth |
| 회원가입 링크 | Link | "아직 회원이 아니신가요? 가입하기" |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| UserModel | `lib/app/data/models/user_model.dart` | completed |
| AuthResponseModel | `lib/app/data/models/auth_response_model.dart` | completed |
| AuthRepository | `lib/app/data/repositories/auth_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginController | `lib/app/modules/login/controllers/login_controller.dart` | completed |
| LoginBinding | `lib/app/modules/login/bindings/login_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| LoginView | `lib/app/modules/login/views/login_view.dart` | completed |

---

## TASK-003: S03 홈 화면 (할 일 목록) 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S03 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[홈 화면 진입] → [할 일 목록 로딩] → [목록 표시] → [탭 전환/카드 탭/체크박스 탭/FAB 탭]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 데이터 없음 | 할 일 목록 비어있음 | Empty State UI 표시 |
| API 실패 | 네트워크 오류 | 에러 화면 + 재시도 버튼 |
| 타임아웃 | 응답 지연 | 타임아웃 메시지, 재시도 옵션 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 목록 조회 | 할 일 목록 로딩 | 화면 진입 시 |
| 탭 전환 | 오늘/전체/태그별 필터 | 탭 탭 |
| 진행률 표시 | 완료율 ProgressBar | 목록 로딩 시 |
| 할 일 완료 | 체크박스로 완료 처리 | 체크박스 탭 |
| 상세 이동 | 할 일 상세 화면 이동 | 카드 탭 |
| 추가 이동 | 할 일 추가 화면 이동 | FAB 탭 |
| 검색 이동 | 검색 화면 이동 | 검색 아이콘 탭 |

#### 4. API 정보

**F02. 할 일 목록 조회 (Get Todos)**
- **Method**: `GET`
- **Endpoint**: `/todos`
- **Request**:
```json
{
  "filter": "today | all | byTag (optional, default: all)",
  "tagId": "int? (required if filter=byTag)",
  "sortBy": "dueDate | priority | createdAt (optional, default: createdAt)",
  "sortOrder": "asc | desc (optional, default: desc)"
}
```
- **Response (성공)**:
```json
{
  "todos": [
    {
      "id": "int",
      "title": "string",
      "memo": "string?",
      "dueDate": "DateTime?",
      "priority": "high | normal | low",
      "tagId": "int?",
      "isCompleted": "bool",
      "createdAt": "DateTime"
    }
  ],
  "total": "int",
  "completedCount": "int",
  "progressRate": "float (0.0 ~ 1.0)"
}
```
- **Response (실패)**:
```json
{
  "code": "UNAUTHORIZED",
  "message": "인증이 필요합니다"
}
```

**F06. 완료 처리 (Complete Todo)**
- **Method**: `PATCH`
- **Endpoint**: `/todos/:id/complete`
- **Response (성공)**:
```json
{
  "id": "int",
  "isCompleted": true,
  "completedAt": "DateTime",
  "message": "할 일을 완료했습니다"
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | "오늘의 할 일" + 검색 아이콘 |
| 탭바 | TabBar | 오늘 / 전체 / 태그별 |
| 진행률 | ProgressBar | 완료 진행률 (3/5) |
| 할 일 카드 | Card | 체크박스, 제목, 마감일, 우선순위 뱃지 |
| FAB | FAB | + 버튼 (추가 화면 이동) |
| 바텀 네비게이션 | BottomNav | 홈 / 검색 / 완료 / 마이 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoModel | `lib/app/data/models/todo_model.dart` | completed |
| TodoListResponseModel | `lib/app/data/models/todo_list_response_model.dart` | completed |
| TagModel | `lib/app/data/models/tag_model.dart` | completed |
| TodoRepository | `lib/app/data/repositories/todo_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| HomeController | `lib/app/modules/home/controllers/home_controller.dart` | completed |
| HomeBinding | `lib/app/modules/home/bindings/home_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| HomeView | `lib/app/modules/home/views/home_view.dart` | completed |
| TodoCardWidget | `lib/app/widgets/todo_card_widget.dart` | completed |

---

## TASK-004: S04 할 일 추가 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S04 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-90&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[추가 화면 진입] → [제목 입력] → [메모 입력 (선택)] → [마감일 선택] → [우선순위 선택] → [태그 선택] → [추가하기 버튼 탭] → [홈 화면 (목록 갱신)]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 제목 미입력 | 저장 버튼 탭 (제목 비어있음) | 토스트: "제목을 입력해주세요" |
| 제목 길이 초과 | 100자 초과 입력 | 토스트: "제목은 100자 이내로 입력해주세요" |
| 과거 날짜 선택 | 과거 마감일 선택 | 경고 다이얼로그 -> 확인 시 저장 허용 |
| 뒤로가기 (편집 중) | 뒤로가기 버튼 | 다이얼로그: "변경사항을 저장하지 않겠습니까?" |
| API 실패 | 저장 실패 | 에러 토스트, 재시도 옵션 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 제목 입력 | 할 일 제목 입력 (필수, max: 100자) | 텍스트 입력 |
| 메모 입력 | 메모 입력 (선택, max: 500자) | 텍스트 입력 |
| 마감일 선택 | DatePicker로 마감일 선택 | 날짜 필드 탭 |
| 우선순위 선택 | 높음/보통/낮음 중 선택 | 칩 탭 |
| 태그 선택 | 태그 다중 선택 | 칩 탭 |
| 새 태그 추가 | 새 태그 생성 | + 칩 탭 |
| 저장 | 할 일 생성 | 추가하기 버튼 탭 |
| 취소 | 이전 화면 복귀 | 뒤로가기 |

#### 4. API 정보

**F01. 할 일 생성 (Create Todo)**
- **Method**: `POST`
- **Endpoint**: `/todos`
- **Request**:
```json
{
  "title": "string (required, max: 100)",
  "memo": "string? (optional, max: 500)",
  "dueDate": "DateTime? (optional, ISO 8601)",
  "priority": "high | normal | low (optional, default: normal)",
  "tagId": "int? (optional)",
  "isNotificationEnabled": "bool? (optional, default: true)"
}
```
- **Response (성공)**:
```json
{
  "id": "int",
  "title": "string",
  "memo": "string?",
  "dueDate": "DateTime?",
  "priority": "string",
  "tagId": "int?",
  "isCompleted": false,
  "isNotificationEnabled": true,
  "createdAt": "DateTime",
  "updatedAt": "DateTime",
  "message": "할 일이 생성되었습니다"
}
```
- **Response (실패)**:
```json
{
  "code": "VALIDATION_ERROR",
  "message": "제목을 입력해주세요"
}
```
```json
{
  "code": "TITLE_TOO_LONG",
  "message": "제목은 100자 이내로 입력해주세요"
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | 뒤로가기 + "할 일 추가" |
| 제목 입력 | Input | 필수, placeholder: "할 일을 입력해 주세요" |
| 메모 입력 | TextArea | 선택, placeholder: "메모를 입력해주세요 (선택)" |
| 마감일 | DatePicker | default: "날짜 선택 없음" |
| 우선순위 | ChipGroup/Single | 높음(빨강) / 보통(노랑) / 낮음(초록) |
| 태그 | ChipGroup/Multi | 업무 / 개인 / 학습 / + 새로 추가 |
| 추가하기 버튼 | Button/Primary | 저장 버튼 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoModel | `lib/app/data/models/todo_model.dart` | completed |
| TodoRepository (createTodo) | `lib/app/data/repositories/todo_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoAddController | `lib/app/modules/todo_add/controllers/todo_add_controller.dart` | completed |
| TodoAddBinding | `lib/app/modules/todo_add/bindings/todo_add_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoAddView | `lib/app/modules/todo_add/views/todo_add_view.dart` | completed |

---

## TASK-005: S05 할 일 상세 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S05 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-211&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[홈 화면] → [카드 탭] → [상세 화면] → [수정/삭제/완료 버튼 탭]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 할 일 없음 | todo.id로 조회 실패 | 토스트: "할 일을 찾을 수 없습니다" -> 홈 이동 |
| 삭제 확인 | 삭제 버튼 탭 | 확인 다이얼로그: "삭제하시겠습니까?" |
| API 실패 | 네트워크 오류 | 에러 토스트, 재시도 옵션 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 상세 조회 | 할 일 상세 정보 로딩 | 화면 진입 시 |
| 수정 이동 | 수정 화면 이동 | 수정 버튼 탭 |
| 삭제 | 할 일 삭제 | 삭제 버튼 탭 -> 확인 |
| 완료 처리 | 할 일 완료 | 완료 버튼 탭 |

#### 4. API 정보

**F03. 할 일 상세 조회 (Get Todo)**
- **Method**: `GET`
- **Endpoint**: `/todos/:id`
- **Response (성공)**:
```json
{
  "id": "int",
  "title": "string",
  "memo": "string?",
  "dueDate": "DateTime?",
  "priority": "high | normal | low",
  "tagId": "int?",
  "tag": { "id": "int", "name": "string", "color": "string" },
  "isCompleted": "bool",
  "completedAt": "DateTime?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```
- **Response (실패)**:
```json
{
  "code": "TODO_NOT_FOUND",
  "message": "할 일을 찾을 수 없습니다"
}
```

**F04. 할 일 수정 (Update Todo)**
- **Method**: `PUT`
- **Endpoint**: `/todos/:id`
- **Request**:
```json
{
  "title": "string? (optional, max: 100)",
  "memo": "string? (optional, max: 500)",
  "dueDate": "DateTime? (optional)",
  "priority": "high | normal | low (optional)",
  "tagId": "int? (optional)"
}
```
- **Response (성공)**:
```json
{
  "...Todo",
  "message": "할 일이 수정되었습니다"
}
```

**F05. 할 일 삭제 (Delete Todo)**
- **Method**: `DELETE`
- **Endpoint**: `/todos/:id`
- **Response (성공)**:
```json
{
  "message": "할 일이 삭제되었습니다"
}
```

**F06. 완료 처리 (Complete Todo)**
- **Method**: `PATCH`
- **Endpoint**: `/todos/:id/complete`
- **Response (성공)**:
```json
{
  "id": "int",
  "isCompleted": true,
  "completedAt": "DateTime",
  "message": "할 일을 완료했습니다"
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | 뒤로가기 + "할 일 상세" |
| 제목 | Text/Title | 할 일 제목 |
| 우선순위 뱃지 | Badge | 높음/보통/낮음 |
| 태그 칩 | Chip | 태그명 |
| 상세 정보 | List | 마감일, 생성일, 태그 |
| 메모 | Card | 메모 내용 |
| 삭제 버튼 | Button/Outline | 삭제 |
| 수정 버튼 | Button/Outline | 수정 화면 이동 |
| 완료 버튼 | Button/Success | "할 일 완료하기" |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoModel | `lib/app/data/models/todo_model.dart` | completed |
| TodoRepository (getTodo, updateTodo, deleteTodo) | `lib/app/data/repositories/todo_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoDetailController | `lib/app/modules/todo_detail/controllers/todo_detail_controller.dart` | completed |
| TodoDetailBinding | `lib/app/modules/todo_detail/bindings/todo_detail_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoDetailView | `lib/app/modules/todo_detail/views/todo_detail_view.dart` | completed |

---

## TASK-006: S06 완료 목록 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S06 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-520&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[완료 탭 진입] → [완료 목록 로딩] → [목록 표시] → [복원 아이콘 탭/스와이프 삭제]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 데이터 없음 | 완료된 할 일 없음 | Empty State UI 표시 |
| 복원 실패 | API 오류 | 에러 토스트, 재시도 |
| 삭제 확인 | 스와이프 삭제 | 확인 다이얼로그 -> 영구 삭제 |
| 전체 삭제 | Trash 아이콘 탭 | 확인 다이얼로그 -> 전체 삭제 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 완료 목록 조회 | 완료된 할 일 목록 로딩 | 화면 진입 시 |
| 복원 | 미완료 상태로 복원 | 복원 아이콘(↩) 탭 |
| 영구 삭제 | 할 일 영구 삭제 | 스와이프 -> 확인 |
| 전체 삭제 | 완료 목록 전체 삭제 | Trash 아이콘 탭 -> 확인 |

#### 4. API 정보

**F08. 완료 목록 조회 (Get Completed Todos)**
- **Method**: `GET`
- **Endpoint**: `/todos/completed`
- **Response (성공)**:
```json
{
  "todos": [
    {
      "id": "int",
      "title": "string",
      "isCompleted": true,
      "completedAt": "DateTime"
    }
  ],
  "total": "int"
}
```

**F07. 완료 복원 (Restore Todo)**
- **Method**: `PATCH`
- **Endpoint**: `/todos/:id/restore`
- **Response (성공)**:
```json
{
  "id": "int",
  "isCompleted": false,
  "completedAt": null,
  "message": "할 일이 복원되었습니다"
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | "완료 목록" + 전체 삭제(Trash) 아이콘 |
| 완료 통계 | Text/Caption | "이번 주 N개 완료" |
| 완료 카드 | Card | 체크박스(체크됨), 제목(취소선), 완료일, 복원(↩) 아이콘 |
| 스와이프 힌트 | Text/Caption | "스와이프하여 삭제" |
| 바텀 네비게이션 | BottomNav | 홈 / 검색 / 완료 / 마이 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| TodoModel | `lib/app/data/models/todo_model.dart` | completed |
| TodoRepository (getCompletedTodos, restoreTodo) | `lib/app/data/repositories/todo_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| CompletedController | `lib/app/modules/completed/controllers/completed_controller.dart` | completed |
| CompletedBinding | `lib/app/modules/completed/bindings/completed_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| CompletedView | `lib/app/modules/completed/views/completed_view.dart` | completed |

---

## TASK-007: S07 마이페이지 화면 구현

#### 1. 기본 정보
| 항목 | 내용 |
|------|------|
| 상태 | completed |
| 우선순위 | high |
| 화면 코드 | S07 |
| 디자인 | [Figma](https://www.figma.com/design/6ECUY7EYbkNyaA1VisW1Sz/Untitled?node-id=26-633&t=uKoCgAAh356tOy9c-11) |

#### 2. 사용자 흐름 (User Flow)

**정상 흐름 (Happy Path)**
```
[마이 탭 진입] → [프로필 정보 로딩] → [설정 메뉴 표시] → [메뉴 탭/토글/로그아웃]
```

**예외 흐름 (Exception Flow)**
| 케이스 | 트리거 | 처리 |
|--------|--------|------|
| 프로필 로딩 실패 | API 오류 | 에러 토스트, 기본값 표시 |
| 로그아웃 확인 | 로그아웃 버튼 탭 | 확인 다이얼로그: "로그아웃 하시겠습니까?" |
| 설정 저장 실패 | API 오류 | 에러 토스트, 원래 값 복원 |

#### 3. 기능 정의
| 기능 | 설명 | 트리거 |
|------|------|--------|
| 프로필 조회 | 내 정보 로딩 | 화면 진입 시 |
| 내 정보 수정 | 프로필 수정 화면 이동 | 메뉴 탭 |
| 알림 설정 토글 | 전체 알림 ON/OFF | 스위치 토글 |
| 푸시 알림 시간 | 알림 시간 설정 | 메뉴 탭 |
| 테마 설정 | 라이트/다크/시스템 선택 | 메뉴 탭 |
| 로그아웃 | 로그아웃 처리 | 로그아웃 버튼 탭 -> 확인 |

#### 4. API 정보

**U01. 내 정보 조회 (Get My Info)**
- **Method**: `GET`
- **Endpoint**: `/users/me`
- **Response (성공)**:
```json
{
  "id": "int",
  "email": "string",
  "nickname": "string?",
  "profileImage": "string?",
  "socialProvider": "google | apple | null",
  "isNotificationEnabled": "bool",
  "notificationTime": "string (HH:mm)",
  "themeMode": "light | dark | system"
}
```

**U02. 내 정보 수정 (Update My Info)**
- **Method**: `PUT`
- **Endpoint**: `/users/me`
- **Request**:
```json
{
  "nickname": "string? (optional, max: 30)",
  "profileImage": "string? (optional)"
}
```
- **Response (성공)**:
```json
{
  "...User",
  "message": "정보가 수정되었습니다"
}
```

**U04. 알림 설정 변경 (Update Notification)**
- **Method**: `PUT`
- **Endpoint**: `/users/me/notification`
- **Request**:
```json
{
  "isNotificationEnabled": "bool",
  "notificationTime": "string (HH:mm)"
}
```
- **Response (성공)**:
```json
{
  "isNotificationEnabled": "bool",
  "notificationTime": "string",
  "message": "알림 설정이 변경되었습니다"
}
```

**A04. 로그아웃 (Logout)**
- **Method**: `POST`
- **Endpoint**: `/auth/logout`
- **Response (성공)**:
```json
{
  "message": "로그아웃되었습니다"
}
```

#### 5. UI 구성
| 요소 | 타입 | 설명 |
|------|------|------|
| 헤더 | Header | "마이페이지" |
| 아바타 | Avatar | 프로필 이미지 |
| 닉네임 | Text/Title | 사용자 닉네임 |
| 이메일 | Text/Caption | 사용자 이메일 |
| 내 정보 수정 | ListItem | 프로필 수정 이동 |
| 알림 설정 | ListItem + Switch | 알림 ON/OFF 토글 |
| 푸시 알림 시간 | ListItem | 시간 선택 이동 |
| 테마 설정 | ListItem | 테마 선택 이동 |
| 로그아웃 버튼 | Button/Outline | 로그아웃 |
| 바텀 네비게이션 | BottomNav | 홈 / 검색 / 완료 / 마이 |

#### 6. 작업 분배

**API Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| UserModel | `lib/app/data/models/user_model.dart` | completed |
| UserRepository | `lib/app/data/repositories/user_repository.dart` | completed |

**Controller Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| MyPageController | `lib/app/modules/my_page/controllers/my_page_controller.dart` | completed |
| MyPageBinding | `lib/app/modules/my_page/bindings/my_page_binding.dart` | completed |

**UI Agent**
| 작업 | 파일 경로 | 상태 |
|------|----------|------|
| MyPageView | `lib/app/modules/my_page/views/my_page_view.dart` | completed |
