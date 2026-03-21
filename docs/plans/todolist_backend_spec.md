---
title: TodoList Backend 기획서
version: v1.3
generated: 2026-03-08
source: /Users/currencyunited/Desktop/my_projcet_setting/TodoList_기획서_v1.3_최종.pdf
---

# TodoList Backend 기획서

## 1. 개요

### 1-1. 프로젝트 목적
- 사용자가 할 일을 빠르게 추가, 관리, 완료 처리할 수 있는 TodoList 앱
- 마감일, 우선순위, 카테고리(태그) 기반 할 일 분류 및 알림 기능 제공
- 로컬 데이터 저장 기반 MVP, 추후 서버 연동 확장 가능

### 1-2. 기술 스택 권장사항
- **Flutter / Dart** - UI 프레임워크
- **GetX** - 상태 관리, 라우팅, DI
- **GetStorage / SQLite** - 로컬 데이터 저장
- **Firebase** - FCM 푸시 알림

### 1-3. 우선순위 기준 (MoSCoW)

| 우선순위 | 레이블 | 기능 목록 | 비고 |
|----------|--------|----------|------|
| Must | 없으면 출시 불가 | 회원가입/로그인, 할 일 CRUD, 완료 체크, 로컬 데이터 저장 | MVP 핵심 기능 |
| Should | 있으면 좋음 | 마감일 설정, 우선순위, 카테고리 태그, 푸시 알림, 검색/필터 | v1.0 목표 |
| Could | 여유 시 추가 | 다크모드, 반복 할 일, 위젯, 드래그앤드롭 정렬, 완료 통계 | v1.1~v1.2 |
| Won't | 이번 버전 제외 | 팀 협업/공유, AI 자동 분류, 캘린더 연동, 다국어 지원 | v2.0 이후 |

---

## 2. 데이터 모델 (Entity)

### 2-1. 핵심 엔티티

#### Todo 엔티티

| 필드명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | int | PK, auto increment | 고유 식별자 |
| title | String | required, max: 100 | 할 일 제목 |
| memo | String? | optional, max: 500 | 메모 (선택) |
| dueDate | DateTime? | optional | 마감일 (선택) |
| priority | Priority | default: normal | 우선순위 |
| tagId | int? | FK, optional | 태그 ID (선택) |
| isCompleted | bool | default: false | 완료 여부 |
| completedAt | DateTime? | optional | 완료 일시 |
| isNotificationEnabled | bool | default: true | 개별 알림 ON/OFF |
| createdAt | DateTime | required | 생성 일시 |
| updatedAt | DateTime | required | 수정 일시 |

#### Tag 엔티티

| 필드명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | int | PK, auto increment | 고유 식별자 |
| name | String | required, unique, max: 20 | 태그명 |
| color | String | required | 태그 색상 (hex) |
| createdAt | DateTime | required | 생성 일시 |

#### User 엔티티

| 필드명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | int | PK, auto increment | 고유 식별자 |
| email | String | required, unique | 이메일 |
| password | String | required, hashed | 비밀번호 |
| nickname | String? | optional, max: 30 | 닉네임 |
| profileImage | String? | optional | 프로필 이미지 URL |
| socialProvider | SocialProvider? | optional | 소셜 로그인 제공자 |
| isNotificationEnabled | bool | default: true | 전체 알림 ON/OFF |
| notificationTime | String | default: "09:00" | 알림 시간 |
| themeMode | ThemeMode | default: system | 테마 설정 |
| createdAt | DateTime | required | 가입 일시 |
| updatedAt | DateTime | required | 수정 일시 |

### 2-2. Enum 정의

```dart
enum Priority {
  high,    // 높음 (빨강)
  normal,  // 보통 (노랑) - 기본값
  low      // 낮음 (초록)
}

enum SocialProvider {
  google,
  apple
}

enum ThemeMode {
  light,
  dark,
  system  // 기본값
}

enum TodoFilter {
  today,   // 오늘 마감
  all,     // 전체
  byTag    // 태그별
}
```

---

## 3. API 명세

### 3-1. 엔드포인트 목록

| ID | Method | Endpoint | 설명 | 우선순위 |
|----|--------|----------|------|----------|
| A01 | POST | /auth/register | 회원가입 | Must |
| A02 | POST | /auth/login | 로그인 | Must |
| A03 | POST | /auth/social | 소셜 로그인 | Must |
| A04 | POST | /auth/logout | 로그아웃 | Must |
| A05 | DELETE | /auth/withdraw | 회원탈퇴 | Must |
| F01 | POST | /todos | 할 일 생성 | Must |
| F02 | GET | /todos | 할 일 목록 조회 | Must |
| F03 | GET | /todos/:id | 할 일 상세 조회 | Must |
| F04 | PUT | /todos/:id | 할 일 수정 | Must |
| F05 | DELETE | /todos/:id | 할 일 삭제 | Must |
| F06 | PATCH | /todos/:id/complete | 완료 처리 | Must |
| F07 | PATCH | /todos/:id/restore | 완료 복원 | Must |
| F08 | GET | /todos/completed | 완료 목록 조회 | Must |
| F09 | GET | /todos/search | 검색 | Should |
| T01 | GET | /tags | 태그 목록 조회 | Should |
| T02 | POST | /tags | 태그 생성 | Should |
| T03 | DELETE | /tags/:id | 태그 삭제 | Should |
| U01 | GET | /users/me | 내 정보 조회 | Must |
| U02 | PUT | /users/me | 내 정보 수정 | Must |
| U03 | PUT | /users/me/password | 비밀번호 변경 | Must |
| U04 | PUT | /users/me/notification | 알림 설정 변경 | Should |

### 3-2. API 상세 명세

#### F01. 할 일 생성 (Create Todo)

```yaml
Method: POST
Endpoint: /todos
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Body:
    title: String (required, max: 100)
    memo: String? (optional, max: 500)
    dueDate: DateTime? (optional, ISO 8601)
    priority: String? (optional, enum: high|normal|low, default: normal)
    tagId: int? (optional)
    isNotificationEnabled: bool? (optional, default: true)

Response:
  Success (201):
    id: int
    title: String
    memo: String?
    dueDate: DateTime?
    priority: String
    tagId: int?
    isCompleted: bool
    isNotificationEnabled: bool
    createdAt: DateTime
    updatedAt: DateTime
    message: "할 일이 생성되었습니다"

  Error (400):
    code: "VALIDATION_ERROR"
    message: "제목을 입력해주세요"

  Error (400):
    code: "TITLE_TOO_LONG"
    message: "제목은 100자 이내로 입력해주세요"
```

#### F02. 할 일 목록 조회 (Get Todos)

```yaml
Method: GET
Endpoint: /todos
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Query Parameters:
    filter: String? (optional, enum: today|all|byTag, default: all)
    tagId: int? (optional, required if filter=byTag)
    sortBy: String? (optional, enum: dueDate|priority|createdAt, default: createdAt)
    sortOrder: String? (optional, enum: asc|desc, default: desc)

Response:
  Success (200):
    todos: Array<Todo>
    total: int
    completedCount: int
    progressRate: float (완료율, 0.0 ~ 1.0)
```

#### F04. 할 일 수정 (Update Todo)

```yaml
Method: PUT
Endpoint: /todos/:id
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Path Parameters:
    id: int (required)
  Body:
    title: String? (optional, max: 100)
    memo: String? (optional, max: 500)
    dueDate: DateTime? (optional)
    priority: String? (optional, enum: high|normal|low)
    tagId: int? (optional)
    isNotificationEnabled: bool? (optional)

Response:
  Success (200):
    ...Todo
    message: "할 일이 수정되었습니다"

  Error (404):
    code: "TODO_NOT_FOUND"
    message: "할 일을 찾을 수 없습니다"
```

#### F05. 할 일 삭제 (Delete Todo)

```yaml
Method: DELETE
Endpoint: /todos/:id
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Path Parameters:
    id: int (required)

Response:
  Success (200):
    message: "할 일이 삭제되었습니다"

  Error (404):
    code: "TODO_NOT_FOUND"
    message: "할 일을 찾을 수 없습니다"
```

#### F06. 완료 처리 (Complete Todo)

```yaml
Method: PATCH
Endpoint: /todos/:id/complete
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Path Parameters:
    id: int (required)

Response:
  Success (200):
    id: int
    isCompleted: true
    completedAt: DateTime
    message: "할 일을 완료했습니다"
```

#### F07. 완료 복원 (Restore Todo)

```yaml
Method: PATCH
Endpoint: /todos/:id/restore
Priority: Must Have

Request:
  Headers:
    Authorization: Bearer {token}
  Path Parameters:
    id: int (required)

Response:
  Success (200):
    id: int
    isCompleted: false
    completedAt: null
    message: "할 일이 복원되었습니다"
```

#### F09. 검색 (Search Todos)

```yaml
Method: GET
Endpoint: /todos/search
Priority: Should Have

Request:
  Headers:
    Authorization: Bearer {token}
  Query Parameters:
    keyword: String? (optional, 제목/메모 검색)
    tagId: int? (optional)
    startDate: DateTime? (optional)
    endDate: DateTime? (optional)
    includeCompleted: bool? (optional, default: true)

Response:
  Success (200):
    todos: Array<Todo>
    total: int
```

---

## 4. 비즈니스 로직

| 기능 ID | 기능명 | 트리거 | 처리 로직 | 예외 처리 |
|---------|--------|--------|-----------|-----------|
| F01 | 할 일 생성 | 저장 버튼 탭 | 1. 유효성 검사 (제목 필수, 100자 제한) 2. 로컬 DB 저장 3. 홈 목록 갱신 | 제목 미입력: 토스트 "제목을 입력해주세요" |
| F02 | 할 일 수정 | 수정 화면 저장 탭 | 1. 기존 데이터 prefill 2. 변경사항 유효성 검사 3. updatedAt 갱신 후 저장 | 뒤로가기 시 확인 다이얼로그 |
| F03 | 할 일 삭제 | 삭제 버튼 탭 | 1. 확인 다이얼로그 표시 2. 확인 시 DB에서 제거 3. 목록 갱신 | 취소 시 아무 동작 없음 |
| F04 | 완료 처리 | 체크박스 탭 | 1. isCompleted=true 2. completedAt=now() 3. 완료 목록으로 이동 | - |
| F05 | 완료 복원 | 복원 아이콘 탭 | 1. isCompleted=false 2. completedAt=null 3. 미완료 목록으로 복원 | - |
| F06 | 마감 알림 | 스케줄러 | 1. 마감 1일 전 오전 9시 알림 2. 마감 당일 오전 9시 알림 | 알림 OFF 시 발송 안함 |
| F07 | 마감일 경고 | 날짜 선택 시 | 과거 날짜 선택 시 경고 다이얼로그 표시 후 저장 허용 | - |

---

## 5. 화면-API 매핑

| 화면 | 데이터 흐름 | API 호출 | 처리 |
|------|-------------|----------|------|
| 홈 -> 상세 | todo.id (라우트 파라미터) | GET /todos/:id | id로 DB 조회 후 화면 렌더링 |
| 홈 -> 추가 | 없음 (신규 생성) | POST /todos | 빈 폼 렌더링, 저장 시 새 id 생성 |
| 상세 -> 수정 | todo 전체 객체 | PUT /todos/:id | 기존 데이터 prefill, 저장 시 updatedAt 갱신 |
| 체크박스 탭 | todo.id, isCompleted | PATCH /todos/:id/complete | isCompleted=true, completedAt=now() |
| 검색 -> 상세 | 검색 키워드 + todo.id | GET /todos/search -> GET /todos/:id | 검색 결과 중 탭한 항목 상세 진입 |
| 완료 목록 | - | GET /todos/completed | 완료 날짜 기준 정렬 |
| 복원 탭 | todo.id | PATCH /todos/:id/restore | isCompleted=false, completedAt=null |

---

## 6. 개발 우선순위

### Phase 1: MVP (Must Have)

- [ ] 회원가입 / 로그인 (이메일, 소셜)
- [ ] 할 일 CRUD (생성, 조회, 수정, 삭제)
- [ ] 완료 체크 / 복원
- [ ] 로컬 데이터 저장 (GetStorage / SQLite)
- [ ] 홈 화면 목록 (오늘/전체/태그별 탭)
- [ ] 완료 목록 화면
- [ ] 마이페이지 기본 (프로필, 로그아웃)

### Phase 2: v1.0 (Should Have)

- [ ] 마감일 설정 및 날짜 피커
- [ ] 우선순위 설정 (높음/보통/낮음)
- [ ] 카테고리 태그 CRUD
- [ ] 푸시 알림 (마감 1일 전, 당일 오전 9시)
- [ ] 검색 / 필터 기능
- [ ] 알림 설정 (전체 ON/OFF, 시간 설정)

### Phase 3: v1.1~v1.2 (Could Have)

- [ ] 다크모드 / 테마 설정
- [ ] 반복 할 일
- [ ] 홈 위젯
- [ ] 드래그앤드롭 정렬
- [ ] 완료 통계 / 리포트

### Phase 4: v2.0 이후 (Won't - 현재 제외)

- [ ] 팀 협업 / 공유
- [ ] AI 자동 분류
- [ ] 캘린더 연동
- [ ] 다국어 지원

---

## 7. 로컬 저장소 스키마 (GetStorage)

```dart
// Todo 저장 키
const String TODOS_KEY = 'todos';
const String TAGS_KEY = 'tags';
const String USER_KEY = 'user';
const String SETTINGS_KEY = 'settings';

// 저장 구조 예시
{
  "todos": [
    {
      "id": 1,
      "title": "프로젝트 기획서 작성",
      "memo": "Figma 디자인 시스템 참고",
      "dueDate": "2026-03-10T18:00:00",
      "priority": "high",
      "tagId": 1,
      "isCompleted": false,
      "completedAt": null,
      "isNotificationEnabled": true,
      "createdAt": "2026-03-05T09:30:00",
      "updatedAt": "2026-03-05T09:30:00"
    }
  ],
  "tags": [
    {
      "id": 1,
      "name": "업무",
      "color": "#2563EB"
    }
  ]
}
```

---

## 8. 에러 코드 정의

| 코드 | HTTP Status | 메시지 | 설명 |
|------|-------------|--------|------|
| VALIDATION_ERROR | 400 | 유효성 검사 실패 | 필수 필드 누락 |
| TITLE_REQUIRED | 400 | 제목을 입력해주세요 | 제목 미입력 |
| TITLE_TOO_LONG | 400 | 제목은 100자 이내로 입력해주세요 | 제목 길이 초과 |
| MEMO_TOO_LONG | 400 | 메모는 500자 이내로 입력해주세요 | 메모 길이 초과 |
| TODO_NOT_FOUND | 404 | 할 일을 찾을 수 없습니다 | 존재하지 않는 Todo |
| TAG_NOT_FOUND | 404 | 태그를 찾을 수 없습니다 | 존재하지 않는 Tag |
| UNAUTHORIZED | 401 | 인증이 필요합니다 | 로그인 필요 |
| INVALID_CREDENTIALS | 401 | 이메일 또는 비밀번호가 올바르지 않습니다 | 로그인 실패 |
