---
title: TodoList Backend 기획서
version: 1.3
generated: 2026-03-05
source: TodoList_기획서_v1.3_최종.pdf
---

# TodoList Backend 기획서

## 1. 개요

### 프로젝트 목적
사용자가 할 일을 빠르게 추가하고, 마감일/우선순위를 설정하여 효율적으로 관리할 수 있는 TodoList 앱

### 기술 스택 권장사항
- **Local DB**: Drift (SQLite)
- **상태관리**: Riverpod 3.0
- **푸시 알림**: flutter_local_notifications

### 우선순위 기준 (MoSCoW)
| 우선순위 | 레이블 | 설명 |
|----------|--------|------|
| Must | 없으면 출시 불가 | MVP 핵심 기능 |
| Should | 있으면 좋음 | v1.0 목표 |
| Could | 여유 시 추가 | v1.1~v1.2 |
| Won't | 이번 버전 제외 | v2.0 이후 |

---

## 2. 데이터 모델 (Entity)

### 2-1. 핵심 엔티티

#### Todo
| 필드 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| id | int | PK, auto | 고유 식별자 |
| title | string | required, max:100 | 할 일 제목 |
| memo | string? | max:500 | 메모 (선택) |
| dueDate | DateTime? | - | 마감일 (선택) |
| priority | Priority | default: normal | 우선순위 |
| isCompleted | bool | default: false | 완료 여부 |
| completedAt | DateTime? | - | 완료 일시 |
| createdAt | DateTime | required | 생성 일시 |
| updatedAt | DateTime | required | 수정 일시 |

#### Tag
| 필드 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| id | int | PK, auto | 고유 식별자 |
| name | string | required, unique | 태그명 |
| color | string? | - | 태그 색상 |

#### TodoTag (다대다 관계)
| 필드 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| todoId | int | FK(Todo) | 할 일 ID |
| tagId | int | FK(Tag) | 태그 ID |

#### User
| 필드 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| id | int | PK, auto | 고유 식별자 |
| email | string | required, unique | 이메일 |
| nickname | string? | max:50 | 닉네임 |
| profileImage | string? | - | 프로필 이미지 URL |
| provider | AuthProvider | - | 소셜 로그인 제공자 |

#### UserSettings
| 필드 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| userId | int | FK(User), PK | 사용자 ID |
| notificationEnabled | bool | default: true | 알림 활성화 |
| themeMode | ThemeMode | default: system | 테마 모드 |

### 2-2. Enum 정의

```dart
enum Priority { high, normal, low }

enum AuthProvider { email, google, apple }

enum ThemeMode { light, dark, system }
```

---

## 3. API 명세

### 3-1. 엔드포인트 목록

| ID | Method | Endpoint | 설명 | 우선순위 |
|----|--------|----------|------|----------|
| F01 | POST | /todos | 할 일 생성 | Must |
| F02-1 | PUT | /todos/{id} | 할 일 수정 | Must |
| F02-2 | DELETE | /todos/{id} | 할 일 삭제 | Must |
| F03-1 | PATCH | /todos/{id}/complete | 완료 처리 | Must |
| F03-2 | PATCH | /todos/{id}/restore | 완료 취소 (복원) | Must |
| - | GET | /todos | 할 일 목록 조회 | Must |
| - | GET | /todos/{id} | 할 일 상세 조회 | Must |
| - | GET | /todos/completed | 완료 목록 조회 | Must |
| - | GET | /todos/search | 검색 | Should |
| - | POST | /auth/login | 로그인 | Must |
| - | POST | /auth/register | 회원가입 | Must |
| - | POST | /auth/social | 소셜 로그인 | Must |

### 3-2. API 상세 명세

#### F01 - 할 일 생성 (Create Todo)

```yaml
Method: POST
Endpoint: /todos
Priority: Must Have

Request:
  Body:
    title: string (required, max:100)
    memo: string? (max:500)
    dueDate: DateTime?
    priority: Priority (default: normal)
    tagIds: List<int>?

Response:
  Success (201):
    id: int
    title: string
    memo: string?
    dueDate: DateTime?
    priority: Priority
    isCompleted: false
    tags: List<Tag>
    createdAt: DateTime
    message: "할 일이 생성되었습니다"

  Error (400):
    code: "VALIDATION_ERROR"
    message: "제목을 입력해주세요"
```

#### F02-1 - 할 일 수정 (Update Todo)

```yaml
Method: PUT
Endpoint: /todos/{id}
Priority: Must Have

Request:
  Params:
    id: int (required)
  Body:
    title: string? (max:100)
    memo: string? (max:500)
    dueDate: DateTime?
    priority: Priority?
    tagIds: List<int>?

Response:
  Success (200):
    id: int
    title: string
    memo: string?
    dueDate: DateTime?
    priority: Priority
    isCompleted: bool
    tags: List<Tag>
    updatedAt: DateTime
    message: "할 일이 수정되었습니다"

  Error (404):
    code: "NOT_FOUND"
    message: "할 일을 찾을 수 없습니다"
```

#### F02-2 - 할 일 삭제 (Delete Todo)

```yaml
Method: DELETE
Endpoint: /todos/{id}
Priority: Must Have

Request:
  Params:
    id: int (required)

Response:
  Success (200):
    message: "할 일이 삭제되었습니다"

  Error (404):
    code: "NOT_FOUND"
    message: "할 일을 찾을 수 없습니다"
```

#### F03-1 - 완료 처리 (Complete Todo)

```yaml
Method: PATCH
Endpoint: /todos/{id}/complete
Priority: Must Have

Request:
  Params:
    id: int (required)

Response:
  Success (200):
    id: int
    isCompleted: true
    completedAt: DateTime
    message: "할 일을 완료했습니다"
```

#### F03-2 - 완료 취소/복원 (Restore Todo)

```yaml
Method: PATCH
Endpoint: /todos/{id}/restore
Priority: Must Have

Request:
  Params:
    id: int (required)

Response:
  Success (200):
    id: int
    isCompleted: false
    completedAt: null
    message: "할 일이 복원되었습니다"
```

---

## 4. 비즈니스 로직

| 기능 ID | 기능명 | 트리거 | 처리 로직 | 예외 처리 |
|---------|--------|--------|-----------|-----------|
| F01 | 할 일 생성 | 저장 버튼 탭 | 유효성 검사 후 로컬 DB 저장 | 제목 미입력: 토스트 표시 |
| F02-1 | 할 일 수정 | 수정 저장 탭 | 기존 데이터 업데이트, updatedAt 갱신 | 뒤로가기 시 저장 확인 다이얼로그 |
| F02-2 | 할 일 삭제 | 삭제 버튼 탭 | 확인 다이얼로그 후 DB 제거 | 취소 시 아무 동작 없음 |
| F03-1 | 완료 처리 | 체크박스 탭 | isCompleted=true, completedAt=now() | - |
| F03-2 | 복원 | 복원 아이콘 탭 | isCompleted=false, completedAt=null | - |
| - | 푸시 알림 | 마감일 설정 시 | 마감 1일 전 09:00, 마감 당일 09:00 발송 | 알림 OFF 시 미발송 |

---

## 5. 화면-API 매핑

| 화면 | 데이터 흐름 | API 호출 | 처리 |
|------|-------------|----------|------|
| 홈 -> 상세 | todo.id (라우트 파라미터) | GET /todos/{id} | id로 DB 조회 후 렌더링 |
| 홈 -> 추가 | 없음 (신규 생성) | POST /todos | 빈 폼 렌더링, 저장 시 새 id 생성 |
| 상세 -> 수정 | todo 전체 객체 | PUT /todos/{id} | 기존 데이터 prefill, updatedAt 갱신 |
| 체크박스 탭 | todo.id, isCompleted | PATCH /todos/{id}/complete | isCompleted=true, completedAt=now() |
| 검색 -> 상세 | 검색 키워드 + todo.id | GET /todos/search | 검색 결과 중 탭한 항목 상세 진입 |

---

## 6. 개발 우선순위

### Phase 1: MVP (Must Have)
- [ ] 회원가입 / 로그인 (이메일, Google, Apple)
- [ ] 할 일 생성 (Create)
- [ ] 할 일 조회 (Read) - 목록/상세
- [ ] 할 일 수정 (Update)
- [ ] 할 일 삭제 (Delete)
- [ ] 완료 체크 / 복원
- [ ] 로컬 데이터 저장 (Drift)

### Phase 2: v1.0 (Should Have)
- [ ] 마감일 설정 및 Date Picker
- [ ] 우선순위 설정 (높음/보통/낮음)
- [ ] 카테고리 태그 CRUD
- [ ] 푸시 알림 (마감 1일 전, 당일)
- [ ] 검색 / 필터 기능

### Phase 3: v1.1~v1.2 (Could Have)
- [ ] 다크모드 지원
- [ ] 반복 할 일
- [ ] 홈 위젯
- [ ] 드래그앤드롭 정렬
- [ ] 완료 통계 대시보드

### Phase 4: v2.0 이후 (Won't - 현재 제외)
- 팀 협업 / 공유
- AI 자동 분류
- 캘린더 연동
- 다국어 지원
