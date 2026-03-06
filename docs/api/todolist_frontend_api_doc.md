---
title: TodoList Frontend API 문서
version: 1.3
generated: 2026-03-05
source: docs/plans/todolist_backend_spec.md
language: Flutter/Dart
---

# TodoList Frontend API 문서

## 1. API 개요

### Base URL

```json
{
  "development": "http://localhost:8080/api/v1",
  "staging": "https://staging-api.todolist.com/v1",
  "production": "https://api.todolist.com/v1"
}
```

### 공통 헤더

```json
{
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Accept-Language": "ko-KR",
  "Authorization": "Bearer {token}"
}
```

### 공통 응답 형식

```json
{
  "success_response": {
    "success": true,
    "data": {},
    "message": "성공 메시지"
  },
  "error_response": {
    "success": false,
    "error": {
      "code": "ERROR_CODE",
      "message": "에러 메시지",
      "details": {}
    }
  }
}
```

### Flutter 공통 응답 모델

```dart
/// 공통 API 응답 모델
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] as bool,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// API 에러 모델
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
}
```

---

## 2. API 엔드포인트

### 2-1. API 목록 요약

```json
{
  "apis": [
    { "id": "API-001", "method": "POST", "endpoint": "/todos", "description": "할 일 생성", "auth": true, "priority": "Must" },
    { "id": "API-002", "method": "GET", "endpoint": "/todos", "description": "할 일 목록 조회", "auth": true, "priority": "Must" },
    { "id": "API-003", "method": "GET", "endpoint": "/todos/{id}", "description": "할 일 상세 조회", "auth": true, "priority": "Must" },
    { "id": "API-004", "method": "PUT", "endpoint": "/todos/{id}", "description": "할 일 수정", "auth": true, "priority": "Must" },
    { "id": "API-005", "method": "DELETE", "endpoint": "/todos/{id}", "description": "할 일 삭제", "auth": true, "priority": "Must" },
    { "id": "API-006", "method": "PATCH", "endpoint": "/todos/{id}/complete", "description": "완료 처리", "auth": true, "priority": "Must" },
    { "id": "API-007", "method": "PATCH", "endpoint": "/todos/{id}/restore", "description": "완료 취소", "auth": true, "priority": "Must" },
    { "id": "API-008", "method": "GET", "endpoint": "/todos/completed", "description": "완료 목록 조회", "auth": true, "priority": "Must" },
    { "id": "API-009", "method": "GET", "endpoint": "/todos/search", "description": "검색", "auth": true, "priority": "Should" },
    { "id": "API-010", "method": "POST", "endpoint": "/auth/register", "description": "회원가입", "auth": false, "priority": "Must" },
    { "id": "API-011", "method": "POST", "endpoint": "/auth/login", "description": "로그인", "auth": false, "priority": "Must" },
    { "id": "API-012", "method": "POST", "endpoint": "/auth/social", "description": "소셜 로그인", "auth": false, "priority": "Must" },
    { "id": "API-013", "method": "GET", "endpoint": "/tags", "description": "태그 목록 조회", "auth": true, "priority": "Should" },
    { "id": "API-014", "method": "POST", "endpoint": "/tags", "description": "태그 생성", "auth": true, "priority": "Should" },
    { "id": "API-015", "method": "GET", "endpoint": "/users/me", "description": "내 정보 조회", "auth": true, "priority": "Must" },
    { "id": "API-016", "method": "PUT", "endpoint": "/users/me", "description": "내 정보 수정", "auth": true, "priority": "Should" },
    { "id": "API-017", "method": "PUT", "endpoint": "/users/me/settings", "description": "설정 수정", "auth": true, "priority": "Should" }
  ]
}
```

---

### 2-2. API 상세 명세

---

#### API-001: 할 일 생성

```json
{
  "id": "API-001",
  "name": "할 일 생성",
  "method": "POST",
  "endpoint": "/todos",
  "description": "새로운 할 일을 생성합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Request Body**

```json
{
  "title": "프로젝트 회의 준비",
  "memo": "Figma 시안 피드백을 발표 자료에 포함시키기",
  "dueDate": "2026-03-10T18:00:00Z",
  "priority": "high",
  "tagIds": [1, 2]
}
```

**Request 파라미터 정의**

```json
{
  "parameters": [
    { "name": "title", "type": "String", "required": true, "constraints": "max:100", "description": "할 일 제목" },
    { "name": "memo", "type": "String?", "required": false, "constraints": "max:500", "description": "메모" },
    { "name": "dueDate", "type": "DateTime?", "required": false, "constraints": "ISO 8601", "description": "마감일" },
    { "name": "priority", "type": "Priority", "required": false, "default": "normal", "description": "우선순위 (high/normal/low)" },
    { "name": "tagIds", "type": "List<int>?", "required": false, "description": "태그 ID 목록" }
  ]
}
```

**Response (Success - 201)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "프로젝트 회의 준비",
    "memo": "Figma 시안 피드백을 발표 자료에 포함시키기",
    "dueDate": "2026-03-10T18:00:00Z",
    "priority": "high",
    "isCompleted": false,
    "completedAt": null,
    "tags": [
      { "id": 1, "name": "업무", "color": "#FF5733" },
      { "id": 2, "name": "중요", "color": "#C70039" }
    ],
    "createdAt": "2026-03-05T09:30:00Z",
    "updatedAt": "2026-03-05T09:30:00Z"
  },
  "message": "할 일이 생성되었습니다"
}
```

**Error Cases**

```json
{
  "errors": [
    { "status": 400, "code": "VALIDATION_ERROR", "message": "제목을 입력해주세요", "cause": "title 미입력" },
    { "status": 400, "code": "VALIDATION_ERROR", "message": "제목은 100자 이내로 입력해주세요", "cause": "title > 100자" },
    { "status": 401, "code": "UNAUTHORIZED", "message": "인증이 필요합니다", "cause": "토큰 없음/만료" }
  ]
}
```

**Flutter 코드**

```dart
/// 할 일 생성 요청 모델
class CreateTodoRequest {
  final String title;
  final String? memo;
  final DateTime? dueDate;
  final Priority priority;
  final List<int>? tagIds;

  const CreateTodoRequest({
    required this.title,
    this.memo,
    this.dueDate,
    this.priority = Priority.normal,
    this.tagIds,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    if (memo != null) 'memo': memo,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    'priority': priority.name,
    if (tagIds != null) 'tagIds': tagIds,
  };
}

/// API 호출 예시
Future<Todo> createTodo(CreateTodoRequest request) async {
  final response = await _dio.post('/todos', data: request.toJson());
  final apiResponse = ApiResponse<Todo>.fromJson(
    response.data,
    (json) => Todo.fromJson(json),
  );
  if (apiResponse.success && apiResponse.data != null) {
    return apiResponse.data!;
  }
  throw ApiException(
    code: apiResponse.error?.code ?? 'UNKNOWN_ERROR',
    message: apiResponse.error?.message ?? '알 수 없는 오류',
  );
}
```

---

#### API-002: 할 일 목록 조회

```json
{
  "id": "API-002",
  "name": "할 일 목록 조회",
  "method": "GET",
  "endpoint": "/todos",
  "description": "미완료 할 일 목록을 조회합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Query Parameters**

```json
{
  "parameters": [
    { "name": "filter", "type": "String?", "default": "all", "description": "필터 (all/today/tag)" },
    { "name": "tagId", "type": "int?", "description": "태그별 필터 시 태그 ID" },
    { "name": "sort", "type": "String?", "default": "createdAt", "description": "정렬 기준 (createdAt/dueDate/priority)" },
    { "name": "order", "type": "String?", "default": "desc", "description": "정렬 순서 (asc/desc)" },
    { "name": "page", "type": "int?", "default": 1, "description": "페이지 번호" },
    { "name": "limit", "type": "int?", "default": 20, "description": "페이지당 개수 (max: 100)" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "todos": [
      {
        "id": 1,
        "title": "프로젝트 회의 준비",
        "memo": "Figma 시안 피드백",
        "dueDate": "2026-03-05T18:00:00Z",
        "priority": "high",
        "isCompleted": false,
        "completedAt": null,
        "tags": [{ "id": 1, "name": "업무", "color": "#FF5733" }],
        "createdAt": "2026-03-05T09:30:00Z",
        "updatedAt": "2026-03-05T09:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "totalPages": 1,
      "hasNext": false,
      "hasPrev": false
    },
    "summary": {
      "total": 5,
      "completed": 2,
      "progressRate": 40
    }
  }
}
```

**Flutter 코드**

```dart
/// 할 일 목록 조회 파라미터
class GetTodosParams {
  final String? filter;
  final int? tagId;
  final String? sort;
  final String? order;
  final int? page;
  final int? limit;

  const GetTodosParams({
    this.filter,
    this.tagId,
    this.sort,
    this.order,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toQueryParams() => {
    if (filter != null) 'filter': filter,
    if (tagId != null) 'tagId': tagId.toString(),
    if (sort != null) 'sort': sort,
    if (order != null) 'order': order,
    if (page != null) 'page': page.toString(),
    if (limit != null) 'limit': limit.toString(),
  };
}

/// API 호출 예시
Future<TodoListResponse> getTodos([GetTodosParams? params]) async {
  final response = await _dio.get(
    '/todos',
    queryParameters: params?.toQueryParams(),
  );
  return TodoListResponse.fromJson(response.data['data']);
}
```

---

#### API-003: 할 일 상세 조회

```json
{
  "id": "API-003",
  "name": "할 일 상세 조회",
  "method": "GET",
  "endpoint": "/todos/{id}",
  "description": "특정 할 일의 상세 정보를 조회합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Path Parameters**

```json
{
  "parameters": [
    { "name": "id", "type": "int", "required": true, "description": "할 일 ID" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "프로젝트 회의 준비",
    "memo": "Figma 시안 피드백을 발표 자료에 포함시키기",
    "dueDate": "2026-03-10T18:00:00Z",
    "priority": "high",
    "isCompleted": false,
    "completedAt": null,
    "tags": [
      { "id": 1, "name": "업무", "color": "#FF5733" }
    ],
    "createdAt": "2026-03-05T09:30:00Z",
    "updatedAt": "2026-03-05T09:30:00Z"
  }
}
```

**Error Cases**

```json
{
  "errors": [
    { "status": 404, "code": "NOT_FOUND", "message": "할 일을 찾을 수 없습니다", "cause": "존재하지 않는 id" }
  ]
}
```

**Flutter 코드**

```dart
/// API 호출 예시
Future<Todo> getTodoById(int id) async {
  final response = await _dio.get('/todos/$id');
  final apiResponse = ApiResponse<Todo>.fromJson(
    response.data,
    (json) => Todo.fromJson(json),
  );
  if (apiResponse.success && apiResponse.data != null) {
    return apiResponse.data!;
  }
  throw ApiException(
    code: apiResponse.error?.code ?? 'NOT_FOUND',
    message: apiResponse.error?.message ?? '할 일을 찾을 수 없습니다',
  );
}
```

---

#### API-004: 할 일 수정

```json
{
  "id": "API-004",
  "name": "할 일 수정",
  "method": "PUT",
  "endpoint": "/todos/{id}",
  "description": "할 일 정보를 수정합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Path Parameters**

```json
{
  "parameters": [
    { "name": "id", "type": "int", "required": true, "description": "할 일 ID" }
  ]
}
```

**Request Body**

```json
{
  "title": "프로젝트 회의 준비 (수정)",
  "memo": "수정된 메모",
  "dueDate": "2026-03-11T18:00:00Z",
  "priority": "normal",
  "tagIds": [1, 3]
}
```

**Request 파라미터 정의**

```json
{
  "parameters": [
    { "name": "title", "type": "String?", "required": false, "constraints": "max:100", "description": "할 일 제목" },
    { "name": "memo", "type": "String?", "required": false, "constraints": "max:500", "description": "메모" },
    { "name": "dueDate", "type": "DateTime?", "required": false, "description": "마감일 (null로 설정 가능)" },
    { "name": "priority", "type": "Priority?", "required": false, "description": "우선순위" },
    { "name": "tagIds", "type": "List<int>?", "required": false, "description": "태그 ID 목록" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "프로젝트 회의 준비 (수정)",
    "memo": "수정된 메모",
    "dueDate": "2026-03-11T18:00:00Z",
    "priority": "normal",
    "isCompleted": false,
    "completedAt": null,
    "tags": [
      { "id": 1, "name": "업무", "color": "#FF5733" },
      { "id": 3, "name": "개인", "color": "#3498DB" }
    ],
    "createdAt": "2026-03-05T09:30:00Z",
    "updatedAt": "2026-03-05T10:00:00Z"
  },
  "message": "할 일이 수정되었습니다"
}
```

**Flutter 코드**

```dart
/// 할 일 수정 요청 모델
class UpdateTodoRequest {
  final String? title;
  final String? memo;
  final DateTime? dueDate;
  final Priority? priority;
  final List<int>? tagIds;

  const UpdateTodoRequest({
    this.title,
    this.memo,
    this.dueDate,
    this.priority,
    this.tagIds,
  });

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (memo != null) 'memo': memo,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    if (priority != null) 'priority': priority!.name,
    if (tagIds != null) 'tagIds': tagIds,
  };
}

/// API 호출 예시
Future<Todo> updateTodo(int id, UpdateTodoRequest request) async {
  final response = await _dio.put('/todos/$id', data: request.toJson());
  final apiResponse = ApiResponse<Todo>.fromJson(
    response.data,
    (json) => Todo.fromJson(json),
  );
  if (apiResponse.success && apiResponse.data != null) {
    return apiResponse.data!;
  }
  throw ApiException(
    code: apiResponse.error?.code ?? 'UNKNOWN_ERROR',
    message: apiResponse.error?.message ?? '수정 실패',
  );
}
```

---

#### API-005: 할 일 삭제

```json
{
  "id": "API-005",
  "name": "할 일 삭제",
  "method": "DELETE",
  "endpoint": "/todos/{id}",
  "description": "할 일을 삭제합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Path Parameters**

```json
{
  "parameters": [
    { "name": "id", "type": "int", "required": true, "description": "할 일 ID" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "deleted": true
  },
  "message": "할 일이 삭제되었습니다"
}
```

**Flutter 코드**

```dart
/// API 호출 예시
Future<void> deleteTodo(int id) async {
  final response = await _dio.delete('/todos/$id');
  final apiResponse = ApiResponse.fromJson(response.data, null);
  if (!apiResponse.success) {
    throw ApiException(
      code: apiResponse.error?.code ?? 'DELETE_FAILED',
      message: apiResponse.error?.message ?? '삭제 실패',
    );
  }
}
```

---

#### API-006: 완료 처리

```json
{
  "id": "API-006",
  "name": "완료 처리",
  "method": "PATCH",
  "endpoint": "/todos/{id}/complete",
  "description": "할 일을 완료 상태로 변경합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Path Parameters**

```json
{
  "parameters": [
    { "name": "id", "type": "int", "required": true, "description": "할 일 ID" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "isCompleted": true,
    "completedAt": "2026-03-05T14:30:00Z"
  },
  "message": "할 일을 완료했습니다"
}
```

**Flutter 코드**

```dart
/// API 호출 예시
Future<void> completeTodo(int id) async {
  final response = await _dio.patch('/todos/$id/complete');
  final apiResponse = ApiResponse.fromJson(response.data, null);
  if (!apiResponse.success) {
    throw ApiException(
      code: apiResponse.error?.code ?? 'COMPLETE_FAILED',
      message: apiResponse.error?.message ?? '완료 처리 실패',
    );
  }
}
```

---

#### API-007: 완료 취소 (복원)

```json
{
  "id": "API-007",
  "name": "완료 취소 (복원)",
  "method": "PATCH",
  "endpoint": "/todos/{id}/restore",
  "description": "완료된 할 일을 미완료 상태로 복원합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Path Parameters**

```json
{
  "parameters": [
    { "name": "id", "type": "int", "required": true, "description": "할 일 ID" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "isCompleted": false,
    "completedAt": null
  },
  "message": "할 일이 복원되었습니다"
}
```

**Flutter 코드**

```dart
/// API 호출 예시
Future<void> restoreTodo(int id) async {
  final response = await _dio.patch('/todos/$id/restore');
  final apiResponse = ApiResponse.fromJson(response.data, null);
  if (!apiResponse.success) {
    throw ApiException(
      code: apiResponse.error?.code ?? 'RESTORE_FAILED',
      message: apiResponse.error?.message ?? '복원 실패',
    );
  }
}
```

---

#### API-008: 완료 목록 조회

```json
{
  "id": "API-008",
  "name": "완료 목록 조회",
  "method": "GET",
  "endpoint": "/todos/completed",
  "description": "완료된 할 일 목록을 조회합니다",
  "auth_required": true,
  "priority": "Must Have"
}
```

**Query Parameters**

```json
{
  "parameters": [
    { "name": "sort", "type": "String?", "default": "completedAt", "description": "정렬 기준" },
    { "name": "order", "type": "String?", "default": "desc", "description": "정렬 순서" },
    { "name": "page", "type": "int?", "default": 1, "description": "페이지 번호" },
    { "name": "limit", "type": "int?", "default": 20, "description": "페이지당 개수" }
  ]
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "todos": [
      {
        "id": 2,
        "title": "이메일 확인",
        "memo": null,
        "dueDate": null,
        "priority": "normal",
        "isCompleted": true,
        "completedAt": "2026-03-05T14:22:00Z",
        "tags": [],
        "createdAt": "2026-03-05T08:00:00Z",
        "updatedAt": "2026-03-05T14:22:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "totalPages": 1,
      "hasNext": false,
      "hasPrev": false
    }
  }
}
```

---

#### API-009: 검색

```json
{
  "id": "API-009",
  "name": "검색",
  "method": "GET",
  "endpoint": "/todos/search",
  "description": "키워드, 태그, 날짜로 할 일을 검색합니다",
  "auth_required": true,
  "priority": "Should Have"
}
```

**Query Parameters**

```json
{
  "parameters": [
    { "name": "q", "type": "String?", "description": "검색 키워드 (제목, 메모)" },
    { "name": "tagIds", "type": "String?", "description": "태그 ID (콤마 구분: 1,2,3)" },
    { "name": "startDate", "type": "String?", "description": "검색 시작일 (YYYY-MM-DD)" },
    { "name": "endDate", "type": "String?", "description": "검색 종료일 (YYYY-MM-DD)" },
    { "name": "isCompleted", "type": "bool?", "description": "완료 여부 필터" },
    { "name": "priority", "type": "String?", "description": "우선순위 필터" }
  ]
}
```

**Flutter 코드**

```dart
/// 검색 파라미터
class SearchTodosParams {
  final String? query;
  final List<int>? tagIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isCompleted;
  final Priority? priority;

  const SearchTodosParams({
    this.query,
    this.tagIds,
    this.startDate,
    this.endDate,
    this.isCompleted,
    this.priority,
  });

  Map<String, dynamic> toQueryParams() => {
    if (query != null) 'q': query,
    if (tagIds != null) 'tagIds': tagIds!.join(','),
    if (startDate != null) 'startDate': startDate!.toIso8601String().split('T')[0],
    if (endDate != null) 'endDate': endDate!.toIso8601String().split('T')[0],
    if (isCompleted != null) 'isCompleted': isCompleted.toString(),
    if (priority != null) 'priority': priority!.name,
  };
}

/// API 호출 예시
Future<List<Todo>> searchTodos(SearchTodosParams params) async {
  final response = await _dio.get(
    '/todos/search',
    queryParameters: params.toQueryParams(),
  );
  final data = response.data['data']['todos'] as List;
  return data.map((e) => Todo.fromJson(e)).toList();
}
```

---

#### API-010: 회원가입

```json
{
  "id": "API-010",
  "name": "회원가입",
  "method": "POST",
  "endpoint": "/auth/register",
  "description": "이메일로 회원가입합니다",
  "auth_required": false,
  "priority": "Must Have"
}
```

**Request Body**

```json
{
  "email": "user@example.com",
  "password": "password123",
  "nickname": "홍길동"
}
```

**Request 파라미터 정의**

```json
{
  "parameters": [
    { "name": "email", "type": "String", "required": true, "constraints": "email format", "description": "이메일" },
    { "name": "password", "type": "String", "required": true, "constraints": "min:8", "description": "비밀번호" },
    { "name": "nickname", "type": "String?", "required": false, "constraints": "max:50", "description": "닉네임" }
  ]
}
```

**Response (Success - 201)**

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "nickname": "홍길동",
      "profileImage": null,
      "provider": "email",
      "createdAt": "2026-03-05T09:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2026-03-12T09:00:00Z"
  },
  "message": "회원가입이 완료되었습니다"
}
```

**Error Cases**

```json
{
  "errors": [
    { "status": 400, "code": "VALIDATION_ERROR", "message": "올바른 이메일 형식이 아닙니다", "cause": "이메일 형식 오류" },
    { "status": 400, "code": "VALIDATION_ERROR", "message": "비밀번호는 8자 이상이어야 합니다", "cause": "비밀번호 < 8자" },
    { "status": 409, "code": "EMAIL_ALREADY_EXISTS", "message": "이미 사용 중인 이메일입니다", "cause": "중복 이메일" }
  ]
}
```

**Flutter 코드**

```dart
/// 회원가입 요청 모델
class RegisterRequest {
  final String email;
  final String password;
  final String? nickname;

  const RegisterRequest({
    required this.email,
    required this.password,
    this.nickname,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (nickname != null) 'nickname': nickname,
  };
}

/// API 호출 예시
Future<AuthResponse> register(RegisterRequest request) async {
  final response = await _dio.post('/auth/register', data: request.toJson());
  return AuthResponse.fromJson(response.data['data']);
}
```

---

#### API-011: 로그인

```json
{
  "id": "API-011",
  "name": "로그인",
  "method": "POST",
  "endpoint": "/auth/login",
  "description": "이메일/비밀번호로 로그인합니다",
  "auth_required": false,
  "priority": "Must Have"
}
```

**Request Body**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "nickname": "홍길동",
      "profileImage": null,
      "provider": "email",
      "createdAt": "2026-03-05T09:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2026-03-12T09:00:00Z"
  }
}
```

**Error Cases**

```json
{
  "errors": [
    { "status": 401, "code": "INVALID_CREDENTIALS", "message": "이메일 또는 비밀번호가 올바르지 않습니다", "cause": "로그인 실패" }
  ]
}
```

**Flutter 코드**

```dart
/// 로그인 요청 모델
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

/// API 호출 예시
Future<AuthResponse> login(LoginRequest request) async {
  final response = await _dio.post('/auth/login', data: request.toJson());
  return AuthResponse.fromJson(response.data['data']);
}
```

---

#### API-012: 소셜 로그인

```json
{
  "id": "API-012",
  "name": "소셜 로그인",
  "method": "POST",
  "endpoint": "/auth/social",
  "description": "Google/Apple 계정으로 로그인합니다",
  "auth_required": false,
  "priority": "Must Have"
}
```

**Request Body**

```json
{
  "provider": "google",
  "idToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Success - 200)**

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@gmail.com",
      "nickname": "홍길동",
      "profileImage": "https://...",
      "provider": "google",
      "createdAt": "2026-03-05T09:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2026-03-12T09:00:00Z",
    "isNewUser": false
  }
}
```

**Flutter 코드**

```dart
/// 소셜 로그인 요청 모델
class SocialLoginRequest {
  final AuthProvider provider;
  final String idToken;

  const SocialLoginRequest({required this.provider, required this.idToken});

  Map<String, dynamic> toJson() => {
    'provider': provider.name,
    'idToken': idToken,
  };
}

/// API 호출 예시
Future<AuthResponse> socialLogin(SocialLoginRequest request) async {
  final response = await _dio.post('/auth/social', data: request.toJson());
  return AuthResponse.fromJson(response.data['data']);
}
```

---

## 3. 테이블 상세 정의

### 3-1. 테이블 목록

```json
{
  "tables": [
    { "name": "todos", "description": "할 일", "relations": ["tags (M:N via todo_tags)", "users (N:1)"] },
    { "name": "tags", "description": "태그", "relations": ["todos (M:N via todo_tags)"] },
    { "name": "todo_tags", "description": "할 일-태그 연결", "relations": ["todos (N:1)", "tags (N:1)"] },
    { "name": "users", "description": "사용자", "relations": ["user_settings (1:1)", "todos (1:N)"] },
    { "name": "user_settings", "description": "사용자 설정", "relations": ["users (1:1)"] }
  ]
}
```

### 3-2. 테이블 상세

#### todos 테이블

```json
{
  "table": "todos",
  "columns": [
    { "name": "id", "type": "INTEGER", "constraints": ["PK", "AUTO_INCREMENT"], "nullable": false, "default": null, "description": "고유 식별자" },
    { "name": "user_id", "type": "INTEGER", "constraints": ["FK(users.id)", "NOT NULL"], "nullable": false, "default": null, "description": "사용자 ID" },
    { "name": "title", "type": "VARCHAR(100)", "constraints": ["NOT NULL"], "nullable": false, "default": null, "description": "할 일 제목" },
    { "name": "memo", "type": "TEXT", "constraints": [], "nullable": true, "default": "NULL", "description": "메모" },
    { "name": "due_date", "type": "TIMESTAMP", "constraints": [], "nullable": true, "default": "NULL", "description": "마감일" },
    { "name": "priority", "type": "ENUM('high','normal','low')", "constraints": ["NOT NULL"], "nullable": false, "default": "'normal'", "description": "우선순위" },
    { "name": "is_completed", "type": "BOOLEAN", "constraints": ["NOT NULL"], "nullable": false, "default": "false", "description": "완료 여부" },
    { "name": "completed_at", "type": "TIMESTAMP", "constraints": [], "nullable": true, "default": "NULL", "description": "완료 일시" },
    { "name": "created_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP", "description": "생성 일시" },
    { "name": "updated_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP ON UPDATE", "description": "수정 일시" }
  ],
  "indexes": [
    { "name": "PRIMARY", "columns": ["id"], "type": "PK", "purpose": "기본 키" },
    { "name": "idx_user_id", "columns": ["user_id"], "type": "INDEX", "purpose": "사용자별 조회" },
    { "name": "idx_is_completed", "columns": ["is_completed"], "type": "INDEX", "purpose": "완료 필터" },
    { "name": "idx_due_date", "columns": ["due_date"], "type": "INDEX", "purpose": "마감일 정렬" },
    { "name": "idx_priority", "columns": ["priority"], "type": "INDEX", "purpose": "우선순위 정렬" }
  ],
  "relations": [
    { "target": "users", "type": "N:1", "fk": "user_id", "ref": "id", "on_delete": "CASCADE" },
    { "target": "todo_tags", "type": "1:N", "fk": null, "ref": "todo_id", "on_delete": "CASCADE" }
  ]
}
```

#### tags 테이블

```json
{
  "table": "tags",
  "columns": [
    { "name": "id", "type": "INTEGER", "constraints": ["PK", "AUTO_INCREMENT"], "nullable": false, "default": null, "description": "고유 식별자" },
    { "name": "user_id", "type": "INTEGER", "constraints": ["FK(users.id)", "NOT NULL"], "nullable": false, "default": null, "description": "사용자 ID" },
    { "name": "name", "type": "VARCHAR(50)", "constraints": ["NOT NULL"], "nullable": false, "default": null, "description": "태그명" },
    { "name": "color", "type": "VARCHAR(7)", "constraints": [], "nullable": true, "default": "NULL", "description": "태그 색상 (HEX)" },
    { "name": "created_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP", "description": "생성 일시" }
  ],
  "indexes": [
    { "name": "PRIMARY", "columns": ["id"], "type": "PK", "purpose": "기본 키" },
    { "name": "idx_user_id", "columns": ["user_id"], "type": "INDEX", "purpose": "사용자별 조회" },
    { "name": "uq_user_name", "columns": ["user_id", "name"], "type": "UNIQUE", "purpose": "사용자별 태그명 중복 방지" }
  ]
}
```

#### todo_tags 테이블

```json
{
  "table": "todo_tags",
  "columns": [
    { "name": "todo_id", "type": "INTEGER", "constraints": ["FK(todos.id)", "NOT NULL"], "nullable": false, "description": "할 일 ID" },
    { "name": "tag_id", "type": "INTEGER", "constraints": ["FK(tags.id)", "NOT NULL"], "nullable": false, "description": "태그 ID" }
  ],
  "indexes": [
    { "name": "PRIMARY", "columns": ["todo_id", "tag_id"], "type": "PK", "purpose": "복합 기본 키" },
    { "name": "idx_tag_id", "columns": ["tag_id"], "type": "INDEX", "purpose": "태그별 조회" }
  ]
}
```

#### users 테이블

```json
{
  "table": "users",
  "columns": [
    { "name": "id", "type": "INTEGER", "constraints": ["PK", "AUTO_INCREMENT"], "nullable": false, "default": null, "description": "고유 식별자" },
    { "name": "email", "type": "VARCHAR(255)", "constraints": ["UNIQUE", "NOT NULL"], "nullable": false, "default": null, "description": "이메일" },
    { "name": "password_hash", "type": "VARCHAR(255)", "constraints": [], "nullable": true, "default": "NULL", "description": "비밀번호 해시" },
    { "name": "nickname", "type": "VARCHAR(50)", "constraints": [], "nullable": true, "default": "NULL", "description": "닉네임" },
    { "name": "profile_image", "type": "VARCHAR(500)", "constraints": [], "nullable": true, "default": "NULL", "description": "프로필 이미지 URL" },
    { "name": "provider", "type": "ENUM('email','google','apple')", "constraints": ["NOT NULL"], "nullable": false, "default": "'email'", "description": "로그인 제공자" },
    { "name": "provider_id", "type": "VARCHAR(255)", "constraints": [], "nullable": true, "default": "NULL", "description": "소셜 로그인 ID" },
    { "name": "created_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP", "description": "가입 일시" },
    { "name": "updated_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP ON UPDATE", "description": "수정 일시" }
  ],
  "indexes": [
    { "name": "PRIMARY", "columns": ["id"], "type": "PK", "purpose": "기본 키" },
    { "name": "uq_email", "columns": ["email"], "type": "UNIQUE", "purpose": "이메일 중복 방지" },
    { "name": "idx_provider", "columns": ["provider", "provider_id"], "type": "INDEX", "purpose": "소셜 로그인 조회" }
  ]
}
```

#### user_settings 테이블

```json
{
  "table": "user_settings",
  "columns": [
    { "name": "user_id", "type": "INTEGER", "constraints": ["PK", "FK(users.id)"], "nullable": false, "description": "사용자 ID" },
    { "name": "notification_enabled", "type": "BOOLEAN", "constraints": ["NOT NULL"], "nullable": false, "default": "true", "description": "알림 활성화" },
    { "name": "notification_time", "type": "TIME", "constraints": [], "nullable": true, "default": "'09:00:00'", "description": "알림 시간" },
    { "name": "theme_mode", "type": "ENUM('light','dark','system')", "constraints": ["NOT NULL"], "nullable": false, "default": "'system'", "description": "테마 모드" },
    { "name": "updated_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "nullable": false, "default": "CURRENT_TIMESTAMP ON UPDATE", "description": "수정 일시" }
  ]
}
```

---

## 4. 타입 정의 (Flutter/Dart)

### 4-1. Entity 모델

```dart
/// Todo 엔티티
class Todo {
  final int id;
  final String title;
  final String? memo;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final List<Tag> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Todo({
    required this.id,
    required this.title,
    this.memo,
    this.dueDate,
    required this.priority,
    required this.isCompleted,
    this.completedAt,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      memo: json['memo'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: Priority.fromString(json['priority'] as String),
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'memo': memo,
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority.name,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
    'tags': tags.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Todo copyWith({
    int? id,
    String? title,
    String? memo,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? completedAt,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Tag 엔티티
class Tag {
  final int id;
  final String name;
  final String? color;

  const Tag({
    required this.id,
    required this.name,
    this.color,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
  };
}

/// User 엔티티
class User {
  final int id;
  final String email;
  final String? nickname;
  final String? profileImage;
  final AuthProvider provider;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.nickname,
    this.profileImage,
    required this.provider,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      profileImage: json['profileImage'] as String?,
      provider: AuthProvider.fromString(json['provider'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nickname': nickname,
    'profileImage': profileImage,
    'provider': provider.name,
    'createdAt': createdAt.toIso8601String(),
  };
}

/// UserSettings 엔티티
class UserSettings {
  final bool notificationEnabled;
  final String? notificationTime;
  final ThemeMode themeMode;

  const UserSettings({
    required this.notificationEnabled,
    this.notificationTime,
    required this.themeMode,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notificationEnabled: json['notificationEnabled'] as bool,
      notificationTime: json['notificationTime'] as String?,
      themeMode: ThemeMode.fromString(json['themeMode'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'notificationEnabled': notificationEnabled,
    'notificationTime': notificationTime,
    'themeMode': themeMode.name,
  };
}

/// 인증 응답 모델
class AuthResponse {
  final User user;
  final String token;
  final DateTime expiresAt;
  final bool? isNewUser;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.expiresAt,
    this.isNewUser,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isNewUser: json['isNewUser'] as bool?,
    );
  }
}

/// 할 일 목록 응답 모델
class TodoListResponse {
  final List<Todo> todos;
  final Pagination pagination;
  final TodoSummary? summary;

  const TodoListResponse({
    required this.todos,
    required this.pagination,
    this.summary,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      summary: json['summary'] != null
          ? TodoSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// 페이지네이션
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrev: json['hasPrev'] as bool,
    );
  }
}

/// 할 일 요약
class TodoSummary {
  final int total;
  final int completed;
  final int progressRate;

  const TodoSummary({
    required this.total,
    required this.completed,
    required this.progressRate,
  });

  factory TodoSummary.fromJson(Map<String, dynamic> json) {
    return TodoSummary(
      total: json['total'] as int,
      completed: json['completed'] as int,
      progressRate: json['progressRate'] as int,
    );
  }
}
```

### 4-2. Enum 타입

```dart
/// 우선순위
enum Priority {
  high,
  normal,
  low;

  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Priority.normal,
    );
  }

  String get displayName {
    switch (this) {
      case Priority.high:
        return '높음';
      case Priority.normal:
        return '보통';
      case Priority.low:
        return '낮음';
    }
  }

  String get color {
    switch (this) {
      case Priority.high:
        return '#EF4444';
      case Priority.normal:
        return '#F59E0B';
      case Priority.low:
        return '#22C55E';
    }
  }
}

/// 인증 제공자
enum AuthProvider {
  email,
  google,
  apple;

  static AuthProvider fromString(String value) {
    return AuthProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuthProvider.email,
    );
  }

  String get displayName {
    switch (this) {
      case AuthProvider.email:
        return '이메일';
      case AuthProvider.google:
        return 'Google';
      case AuthProvider.apple:
        return 'Apple';
    }
  }
}

/// 테마 모드
enum ThemeMode {
  light,
  dark,
  system;

  static ThemeMode fromString(String value) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return '라이트';
      case ThemeMode.dark:
        return '다크';
      case ThemeMode.system:
        return '시스템 설정';
    }
  }
}
```

---

## 5. 에러 코드 정의

### 5-1. 공통 에러

```json
{
  "common_errors": [
    { "status": 400, "code": "VALIDATION_ERROR", "message": "입력값이 올바르지 않습니다", "description": "유효성 검사 실패" },
    { "status": 401, "code": "UNAUTHORIZED", "message": "인증이 필요합니다", "description": "토큰 없음" },
    { "status": 401, "code": "TOKEN_EXPIRED", "message": "인증이 만료되었습니다", "description": "토큰 만료" },
    { "status": 403, "code": "FORBIDDEN", "message": "권한이 없습니다", "description": "접근 권한 없음" },
    { "status": 404, "code": "NOT_FOUND", "message": "리소스를 찾을 수 없습니다", "description": "존재하지 않는 리소스" },
    { "status": 409, "code": "CONFLICT", "message": "충돌이 발생했습니다", "description": "중복 데이터" },
    { "status": 500, "code": "INTERNAL_ERROR", "message": "서버 오류가 발생했습니다", "description": "서버 내부 오류" }
  ]
}
```

### 5-2. 도메인별 에러

```json
{
  "todo_errors": [
    { "code": "TODO_TITLE_REQUIRED", "message": "제목을 입력해주세요", "cause": "title 미입력", "handling": "제목 필드 포커스" },
    { "code": "TODO_TITLE_TOO_LONG", "message": "제목은 100자 이내로 입력해주세요", "cause": "title > 100자", "handling": "글자수 초과 안내" },
    { "code": "TODO_MEMO_TOO_LONG", "message": "메모는 500자 이내로 입력해주세요", "cause": "memo > 500자", "handling": "글자수 초과 안내" },
    { "code": "TODO_NOT_FOUND", "message": "할 일을 찾을 수 없습니다", "cause": "존재하지 않는 todo", "handling": "목록으로 이동" }
  ],
  "auth_errors": [
    { "code": "INVALID_EMAIL_FORMAT", "message": "올바른 이메일 형식이 아닙니다", "cause": "이메일 형식 오류", "handling": "이메일 필드 에러 표시" },
    { "code": "PASSWORD_TOO_SHORT", "message": "비밀번호는 8자 이상이어야 합니다", "cause": "비밀번호 < 8자", "handling": "비밀번호 필드 에러 표시" },
    { "code": "INVALID_CREDENTIALS", "message": "이메일 또는 비밀번호가 올바르지 않습니다", "cause": "로그인 실패", "handling": "토스트 메시지" },
    { "code": "EMAIL_ALREADY_EXISTS", "message": "이미 사용 중인 이메일입니다", "cause": "중복 이메일", "handling": "다른 이메일 안내" },
    { "code": "SOCIAL_AUTH_FAILED", "message": "소셜 로그인에 실패했습니다", "cause": "OAuth 오류", "handling": "재시도 안내" }
  ]
}
```

### 5-3. Flutter 에러 처리

```dart
/// API 예외 클래스
class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException: [$code] $message';
}

/// Dio 에러 핸들링
ApiException handleDioError(DioException e) {
  if (e.response != null) {
    final data = e.response!.data;
    if (data is Map<String, dynamic> && data['error'] != null) {
      return ApiException(
        code: data['error']['code'] as String,
        message: data['error']['message'] as String,
        statusCode: e.response!.statusCode,
      );
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiException(
        code: 'TIMEOUT',
        message: '요청 시간이 초과되었습니다',
      );
    case DioExceptionType.connectionError:
      return const ApiException(
        code: 'NETWORK_ERROR',
        message: '네트워크 연결을 확인해주세요',
      );
    default:
      return const ApiException(
        code: 'UNKNOWN_ERROR',
        message: '알 수 없는 오류가 발생했습니다',
      );
  }
}

/// 에러 코드별 처리 (UI에서 사용)
void handleApiError(BuildContext context, ApiException error, {VoidCallback? onUnauthorized}) {
  switch (error.code) {
    case 'UNAUTHORIZED':
    case 'TOKEN_EXPIRED':
      onUnauthorized?.call();
      break;

    case 'NOT_FOUND':
    case 'TODO_NOT_FOUND':
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
      Navigator.pop(context);
      break;

    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
  }
}
```

---

## 6. 화면별 API 호출 가이드

### 6-1. 화면-API 매핑

```json
{
  "screen_api_mapping": [
    {
      "screen": "온보딩",
      "on_enter": null,
      "actions": [
        { "action": "시작하기", "api": null, "navigation": "로그인 화면" }
      ]
    },
    {
      "screen": "로그인",
      "on_enter": null,
      "actions": [
        { "action": "로그인 버튼", "api": "POST /auth/login", "navigation": "홈 화면" },
        { "action": "Google 로그인", "api": "POST /auth/social", "navigation": "홈 화면" },
        { "action": "Apple 로그인", "api": "POST /auth/social", "navigation": "홈 화면" },
        { "action": "회원가입 링크", "api": null, "navigation": "회원가입 화면" }
      ]
    },
    {
      "screen": "회원가입",
      "on_enter": null,
      "actions": [
        { "action": "가입 버튼", "api": "POST /auth/register", "navigation": "홈 화면" }
      ]
    },
    {
      "screen": "홈",
      "on_enter": "GET /todos",
      "actions": [
        { "action": "체크박스 탭", "api": "PATCH /todos/{id}/complete", "navigation": null },
        { "action": "카드 탭", "api": null, "navigation": "상세 화면" },
        { "action": "FAB(+) 탭", "api": null, "navigation": "추가 화면" },
        { "action": "탭 전환", "api": "GET /todos?filter=today/all/tag", "navigation": null }
      ]
    },
    {
      "screen": "추가",
      "on_enter": "GET /tags",
      "actions": [
        { "action": "저장 버튼", "api": "POST /todos", "navigation": "홈 화면" }
      ]
    },
    {
      "screen": "상세",
      "on_enter": "GET /todos/{id}",
      "actions": [
        { "action": "수정 버튼", "api": null, "navigation": "수정 화면" },
        { "action": "삭제 버튼", "api": "DELETE /todos/{id}", "navigation": "홈 화면" },
        { "action": "완료 버튼", "api": "PATCH /todos/{id}/complete", "navigation": "홈 화면" }
      ]
    },
    {
      "screen": "수정",
      "on_enter": "GET /todos/{id}, GET /tags",
      "actions": [
        { "action": "저장 버튼", "api": "PUT /todos/{id}", "navigation": "홈 화면" }
      ]
    },
    {
      "screen": "완료 목록",
      "on_enter": "GET /todos/completed",
      "actions": [
        { "action": "복원 아이콘", "api": "PATCH /todos/{id}/restore", "navigation": null },
        { "action": "스와이프 삭제", "api": "DELETE /todos/{id}", "navigation": null }
      ]
    },
    {
      "screen": "검색",
      "on_enter": null,
      "actions": [
        { "action": "검색 실행", "api": "GET /todos/search", "navigation": null }
      ]
    },
    {
      "screen": "마이페이지",
      "on_enter": "GET /users/me",
      "actions": [
        { "action": "알림 토글", "api": "PUT /users/me/settings", "navigation": null },
        { "action": "로그아웃", "api": null, "navigation": "로그인 화면" }
      ]
    }
  ]
}
```

### 6-2. Riverpod Provider 패턴

```dart
// ===== Providers =====

/// 할 일 목록 Provider
@riverpod
Future<TodoListResponse> todos(TodosRef ref, {String? filter, int? tagId}) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getTodos(GetTodosParams(filter: filter, tagId: tagId));
}

/// 할 일 상세 Provider
@riverpod
Future<Todo> todoDetail(TodoDetailRef ref, int id) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getTodoById(id);
}

/// 완료 목록 Provider
@riverpod
Future<TodoListResponse> completedTodos(CompletedTodosRef ref) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getCompletedTodos();
}

/// 태그 목록 Provider
@riverpod
Future<List<Tag>> tags(TagsRef ref) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getTags();
}

/// 현재 사용자 Provider
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
}

// ===== Notifier =====

@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  Future<TodoListResponse> build() async {
    return ref.watch(todoRepositoryProvider).getTodos();
  }

  Future<void> createTodo(CreateTodoRequest request) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.createTodo(request);
    ref.invalidateSelf();
  }

  Future<void> completeTodo(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.completeTodo(id);
    ref.invalidateSelf();
    ref.invalidate(completedTodosProvider);
  }

  Future<void> restoreTodo(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.restoreTodo(id);
    ref.invalidateSelf();
    ref.invalidate(completedTodosProvider);
  }

  Future<void> deleteTodo(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.deleteTodo(id);
    ref.invalidateSelf();
  }
}
```

---

## 7. 유효성 검사 규칙

### 7-1. 유효성 검사 정의

```json
{
  "todo_validation": [
    { "field": "title", "rules": ["required", "max:100"], "messages": { "required": "제목을 입력해주세요", "max": "제목은 100자 이내로 입력해주세요" } },
    { "field": "memo", "rules": ["max:500"], "messages": { "max": "메모는 500자 이내로 입력해주세요" } },
    { "field": "dueDate", "rules": ["valid_date"], "messages": { "valid_date": "올바른 날짜를 선택해주세요" } },
    { "field": "priority", "rules": ["enum:high,normal,low"], "messages": { "enum": "올바른 우선순위를 선택해주세요" } }
  ],
  "auth_validation": [
    { "field": "email", "rules": ["required", "email"], "messages": { "required": "이메일을 입력해주세요", "email": "올바른 이메일 형식이 아닙니다" } },
    { "field": "password", "rules": ["required", "min:8"], "messages": { "required": "비밀번호를 입력해주세요", "min": "비밀번호는 8자 이상이어야 합니다" } },
    { "field": "nickname", "rules": ["max:50"], "messages": { "max": "닉네임은 50자 이내로 입력해주세요" } }
  ]
}
```

### 7-2. Flutter Validator

```dart
/// 유효성 검사 유틸리티
class Validators {
  static String? required(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? '필수 입력 항목입니다';
    }
    return null;
  }

  static String? email(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return message ?? '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  static String? minLength(String? value, int min, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (value.length < min) {
      return message ?? '$min자 이상 입력해주세요';
    }
    return null;
  }

  static String? maxLength(String? value, int max, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (value.length > max) {
      return message ?? '$max자 이내로 입력해주세요';
    }
    return null;
  }

  /// 복합 검증
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

// 사용 예시
final titleValidator = Validators.combine([
  (v) => Validators.required(v, '제목을 입력해주세요'),
  (v) => Validators.maxLength(v, 100, '제목은 100자 이내로 입력해주세요'),
]);

final emailValidator = Validators.combine([
  (v) => Validators.required(v, '이메일을 입력해주세요'),
  (v) => Validators.email(v, '올바른 이메일 형식이 아닙니다'),
]);

final passwordValidator = Validators.combine([
  (v) => Validators.required(v, '비밀번호를 입력해주세요'),
  (v) => Validators.minLength(v, 8, '비밀번호는 8자 이상이어야 합니다'),
]);
```

---

## 8. 부록

### 8-1. 날짜/시간 형식

```json
{
  "date_formats": {
    "storage": "ISO 8601 (2026-03-05T09:30:00Z)",
    "display": {
      "full": "2026년 3월 5일 오전 9:30",
      "date_only": "2026년 3월 5일",
      "time_only": "오전 9:30",
      "relative_today": "오늘 9:30",
      "relative_yesterday": "어제",
      "relative_week": "월요일"
    },
    "timezone": "UTC 저장, 로컬 타임존 표시"
  }
}
```

```dart
/// 날짜 포맷 유틸리티
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return '오늘 ${DateFormat('a h:mm', 'ko_KR').format(date)}';
    }

    if (targetDate == today.subtract(const Duration(days: 1))) {
      return '어제';
    }

    if (date.difference(now).inDays.abs() < 7) {
      return DateFormat('EEEE', 'ko_KR').format(date);
    }

    return DateFormat('M월 d일', 'ko_KR').format(date);
  }

  static String formatFullDateTime(DateTime date) {
    return DateFormat('yyyy년 M월 d일 a h:mm', 'ko_KR').format(date);
  }

  static String formatDateOnly(DateTime date) {
    return DateFormat('yyyy년 M월 d일', 'ko_KR').format(date);
  }
}
```

### 8-2. 페이지네이션

```json
{
  "pagination": {
    "request": {
      "page": { "type": "int", "default": 1, "description": "페이지 번호 (1부터 시작)" },
      "limit": { "type": "int", "default": 20, "max": 100, "description": "페이지당 항목 수" }
    },
    "response": {
      "page": "현재 페이지",
      "limit": "페이지당 개수",
      "total": "전체 항목 수",
      "totalPages": "전체 페이지 수",
      "hasNext": "다음 페이지 존재 여부",
      "hasPrev": "이전 페이지 존재 여부"
    }
  }
}
```

### 8-3. 정렬 옵션

```json
{
  "sort_options": [
    { "value": "createdAt", "description": "생성일 기준", "default_order": "desc" },
    { "value": "dueDate", "description": "마감일 기준", "default_order": "asc" },
    { "value": "priority", "description": "우선순위 기준", "default_order": "desc" },
    { "value": "completedAt", "description": "완료일 기준", "default_order": "desc" }
  ],
  "order_options": [
    { "value": "asc", "description": "오름차순" },
    { "value": "desc", "description": "내림차순" }
  ]
}
```

### 8-4. HTTP 상태 코드

```json
{
  "status_codes": [
    { "code": 200, "meaning": "OK", "usage": "조회/수정/삭제 성공" },
    { "code": 201, "meaning": "Created", "usage": "생성 성공" },
    { "code": 400, "meaning": "Bad Request", "usage": "유효성 검사 실패" },
    { "code": 401, "meaning": "Unauthorized", "usage": "인증 필요/토큰 만료" },
    { "code": 403, "meaning": "Forbidden", "usage": "권한 없음" },
    { "code": 404, "meaning": "Not Found", "usage": "리소스 없음" },
    { "code": 409, "meaning": "Conflict", "usage": "중복 (이메일 등)" },
    { "code": 500, "meaning": "Internal Server Error", "usage": "서버 오류" }
  ]
}
```
