---
name: frontend-api-doc-agent
description: Backend 기획서를 분석하여 Flutter Frontend 개발자용 API 문서를 생성합니다. "API 문서 생성", "프론트엔드 API", "API 정리", "테이블 정의서" 요청 시 트리거됩니다.
---

# Frontend API Document Agent

Backend 기획서(backend_spec.md)를 입력받아 Flutter Frontend 개발자가 필요로 하는 API 문서를 생성합니다.

## Overview

- **입력**: `docs/plans/{project}_backend_spec.md` 파일
- **출력**: `docs/api/{project}_frontend_api_doc.md`
- **코드 형식**: Flutter/Dart
- **데이터 형식**: JSON

## Task Instructions

### Step 1: Backend 기획서 확인

사용자에게 Backend 기획서 파일 경로를 확인합니다:

"Backend 기획서 파일 경로를 알려주세요.
예: docs/plans/todolist_backend_spec.md"

### Step 2: 기획서 읽기 및 분석

1. **Read 도구로 Backend 기획서 읽기**

2. **추출할 정보**:
   - API 엔드포인트 목록
   - 각 API의 파라미터 정보
   - 각 API의 응답 정보
   - 데이터 모델 (Entity/Table) 정의
   - Enum 타입 정의
   - 비즈니스 로직
   - 에러 코드 및 처리

### Step 3: Frontend API 문서 생성

`docs/api/{project}_frontend_api_doc.md` 파일 생성:

```markdown
---
title: {프로젝트명} Frontend API 문서
version: {버전}
generated: {생성일시}
source: {원본 Backend 기획서 경로}
language: Flutter/Dart
---

# {프로젝트명} Frontend API 문서

## 1. API 개요

### Base URL

```json
{
  "development": "http://localhost:8080/api/v1",
  "staging": "https://staging-api.example.com/v1",
  "production": "https://api.example.com/v1"
}
```

### 공통 헤더

```json
{
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Authorization": "Bearer {token}"
}
```

### 공통 응답 형식

```json
// 성공 응답
{
  "success": true,
  "data": { },
  "message": "성공 메시지"
}

// 에러 응답
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "에러 메시지"
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

  ApiResponse({
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

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
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
    {
      "id": "API-001",
      "method": "POST",
      "endpoint": "/todos",
      "description": "할 일 생성",
      "auth": true,
      "priority": "Must"
    }
  ]
}
```

### 2-2. API 상세 명세

각 API별로 다음 형식으로 문서화:

#### API-001: 할 일 생성

**기본 정보**

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
  "title": "회의 준비",
  "memo": "발표 자료 준비",
  "dueDate": "2026-03-10T18:00:00Z",
  "priority": "high",
  "tagIds": [1, 2]
}
```

**Request 파라미터 정의**

```json
{
  "parameters": [
    {
      "name": "title",
      "type": "String",
      "required": true,
      "constraints": "max:100",
      "description": "할 일 제목"
    },
    {
      "name": "memo",
      "type": "String?",
      "required": false,
      "constraints": "max:500",
      "description": "메모"
    },
    {
      "name": "dueDate",
      "type": "DateTime?",
      "required": false,
      "constraints": "ISO 8601",
      "description": "마감일"
    },
    {
      "name": "priority",
      "type": "Priority",
      "required": false,
      "default": "normal",
      "description": "우선순위"
    },
    {
      "name": "tagIds",
      "type": "List<int>?",
      "required": false,
      "description": "태그 ID 목록"
    }
  ]
}
```

**Response (Success - 201)**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "회의 준비",
    "memo": "발표 자료 준비",
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
    {
      "status": 400,
      "code": "VALIDATION_ERROR",
      "message": "제목을 입력해주세요",
      "cause": "title 미입력"
    },
    {
      "status": 401,
      "code": "UNAUTHORIZED",
      "message": "인증이 필요합니다",
      "cause": "토큰 없음/만료"
    }
  ]
}
```

**Flutter Request 모델**

```dart
/// 할 일 생성 요청 모델
class CreateTodoRequest {
  final String title;
  final String? memo;
  final DateTime? dueDate;
  final Priority priority;
  final List<int>? tagIds;

  CreateTodoRequest({
    required this.title,
    this.memo,
    this.dueDate,
    this.priority = Priority.normal,
    this.tagIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (memo != null) 'memo': memo,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      'priority': priority.name,
      if (tagIds != null) 'tagIds': tagIds,
    };
  }
}
```

**Flutter Response 모델**

```dart
/// 할 일 응답 모델
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

  Todo({
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
}
```

**Flutter API 호출 예시**

```dart
/// TodoRepository - API 호출
class TodoRepository {
  final Dio _dio;

  TodoRepository(this._dio);

  /// 할 일 생성
  Future<Todo> createTodo(CreateTodoRequest request) async {
    try {
      final response = await _dio.post(
        '/todos',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<Todo>.fromJson(
        response.data,
        (json) => Todo.fromJson(json),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }

      throw ApiException(
        code: apiResponse.error?.code ?? 'UNKNOWN_ERROR',
        message: apiResponse.error?.message ?? '알 수 없는 오류가 발생했습니다',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
```

---

## 3. 테이블 상세 정의

### 3-1. 테이블 목록

```json
{
  "tables": [
    {
      "name": "todos",
      "description": "할 일",
      "relations": ["tags (M:N via todo_tags)"]
    },
    {
      "name": "tags",
      "description": "태그",
      "relations": ["todos (M:N via todo_tags)"]
    },
    {
      "name": "todo_tags",
      "description": "할 일-태그 연결",
      "relations": ["todos", "tags"]
    },
    {
      "name": "users",
      "description": "사용자",
      "relations": ["user_settings (1:1)"]
    },
    {
      "name": "user_settings",
      "description": "사용자 설정",
      "relations": ["users (1:1)"]
    }
  ]
}
```

### 3-2. 테이블 상세

#### todos 테이블

**컬럼 정의**

```json
{
  "table": "todos",
  "columns": [
    {
      "name": "id",
      "type": "INTEGER",
      "constraints": ["PK", "AUTO_INCREMENT"],
      "nullable": false,
      "default": null,
      "description": "고유 식별자"
    },
    {
      "name": "user_id",
      "type": "INTEGER",
      "constraints": ["FK(users.id)"],
      "nullable": false,
      "default": null,
      "description": "사용자 ID"
    },
    {
      "name": "title",
      "type": "VARCHAR(100)",
      "constraints": ["NOT NULL"],
      "nullable": false,
      "default": null,
      "description": "할 일 제목"
    },
    {
      "name": "memo",
      "type": "TEXT",
      "constraints": [],
      "nullable": true,
      "default": "NULL",
      "description": "메모"
    },
    {
      "name": "due_date",
      "type": "TIMESTAMP",
      "constraints": [],
      "nullable": true,
      "default": "NULL",
      "description": "마감일"
    },
    {
      "name": "priority",
      "type": "ENUM('high','normal','low')",
      "constraints": ["NOT NULL"],
      "nullable": false,
      "default": "'normal'",
      "description": "우선순위"
    },
    {
      "name": "is_completed",
      "type": "BOOLEAN",
      "constraints": ["NOT NULL"],
      "nullable": false,
      "default": "false",
      "description": "완료 여부"
    },
    {
      "name": "completed_at",
      "type": "TIMESTAMP",
      "constraints": [],
      "nullable": true,
      "default": "NULL",
      "description": "완료 일시"
    },
    {
      "name": "created_at",
      "type": "TIMESTAMP",
      "constraints": ["NOT NULL"],
      "nullable": false,
      "default": "CURRENT_TIMESTAMP",
      "description": "생성 일시"
    },
    {
      "name": "updated_at",
      "type": "TIMESTAMP",
      "constraints": ["NOT NULL"],
      "nullable": false,
      "default": "CURRENT_TIMESTAMP ON UPDATE",
      "description": "수정 일시"
    }
  ]
}
```

**인덱스**

```json
{
  "table": "todos",
  "indexes": [
    {
      "name": "PRIMARY",
      "columns": ["id"],
      "type": "PK",
      "purpose": "기본 키"
    },
    {
      "name": "idx_user_id",
      "columns": ["user_id"],
      "type": "INDEX",
      "purpose": "사용자별 조회"
    },
    {
      "name": "idx_is_completed",
      "columns": ["is_completed"],
      "type": "INDEX",
      "purpose": "완료 필터"
    },
    {
      "name": "idx_due_date",
      "columns": ["due_date"],
      "type": "INDEX",
      "purpose": "마감일 정렬"
    }
  ]
}
```

**관계**

```json
{
  "table": "todos",
  "relations": [
    {
      "target_table": "users",
      "relation_type": "N:1",
      "fk_column": "user_id",
      "reference_column": "id",
      "on_delete": "CASCADE"
    },
    {
      "target_table": "todo_tags",
      "relation_type": "1:N",
      "fk_column": null,
      "reference_column": "todo_id",
      "on_delete": "CASCADE"
    }
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

  Map<String, dynamic> toJson() {
    return {
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
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'profileImage': profileImage,
      'provider': provider.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'notificationEnabled': notificationEnabled,
      'notificationTime': notificationTime,
      'themeMode': themeMode.name,
    };
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

### 4-3. Request/Response 모델

```dart
// ===== Todo Request/Response =====

/// 할 일 생성 요청
class CreateTodoRequest {
  final String title;
  final String? memo;
  final DateTime? dueDate;
  final Priority priority;
  final List<int>? tagIds;

  CreateTodoRequest({
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

/// 할 일 수정 요청
class UpdateTodoRequest {
  final String? title;
  final String? memo;
  final DateTime? dueDate;
  final Priority? priority;
  final List<int>? tagIds;

  UpdateTodoRequest({
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

/// 할 일 목록 조회 파라미터
class GetTodosParams {
  final String? filter;
  final int? tagId;
  final String? sort;
  final String? order;
  final int? page;
  final int? limit;

  GetTodosParams({
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

/// 페이지네이션 응답
class PaginatedResponse<T> {
  final List<T> data;
  final Pagination pagination;

  PaginatedResponse({
    required this.data,
    required this.pagination,
  });
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
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

// ===== Auth Request/Response =====

/// 로그인 요청
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

/// 로그인 응답
class LoginResponse {
  final User user;
  final String token;
  final DateTime expiresAt;

  LoginResponse({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}

/// 회원가입 요청
class RegisterRequest {
  final String email;
  final String password;
  final String? nickname;

  RegisterRequest({
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

/// 소셜 로그인 요청
class SocialLoginRequest {
  final AuthProvider provider;
  final String idToken;

  SocialLoginRequest({required this.provider, required this.idToken});

  Map<String, dynamic> toJson() => {
    'provider': provider.name,
    'idToken': idToken,
  };
}
```

---

## 5. 에러 코드 정의

### 5-1. 공통 에러

```json
{
  "common_errors": [
    {
      "status": 400,
      "code": "VALIDATION_ERROR",
      "message": "입력값이 올바르지 않습니다",
      "description": "유효성 검사 실패"
    },
    {
      "status": 401,
      "code": "UNAUTHORIZED",
      "message": "인증이 필요합니다",
      "description": "토큰 없음/만료"
    },
    {
      "status": 403,
      "code": "FORBIDDEN",
      "message": "권한이 없습니다",
      "description": "접근 권한 없음"
    },
    {
      "status": 404,
      "code": "NOT_FOUND",
      "message": "리소스를 찾을 수 없습니다",
      "description": "존재하지 않는 리소스"
    },
    {
      "status": 500,
      "code": "INTERNAL_ERROR",
      "message": "서버 오류가 발생했습니다",
      "description": "서버 내부 오류"
    }
  ]
}
```

### 5-2. 도메인별 에러

```json
{
  "todo_errors": [
    {
      "code": "TODO_TITLE_REQUIRED",
      "message": "제목을 입력해주세요",
      "cause": "title 미입력",
      "handling": "제목 입력 필드 포커스"
    },
    {
      "code": "TODO_TITLE_TOO_LONG",
      "message": "제목은 100자 이내로 입력해주세요",
      "cause": "title > 100자",
      "handling": "글자수 초과 안내"
    },
    {
      "code": "TODO_NOT_FOUND",
      "message": "할 일을 찾을 수 없습니다",
      "cause": "존재하지 않는 todo",
      "handling": "목록으로 이동"
    }
  ],
  "auth_errors": [
    {
      "code": "INVALID_CREDENTIALS",
      "message": "이메일 또는 비밀번호가 올바르지 않습니다",
      "cause": "로그인 실패",
      "handling": "재입력 유도"
    },
    {
      "code": "EMAIL_ALREADY_EXISTS",
      "message": "이미 사용 중인 이메일입니다",
      "cause": "중복 이메일",
      "handling": "다른 이메일 안내"
    },
    {
      "code": "TOKEN_EXPIRED",
      "message": "인증이 만료되었습니다",
      "cause": "토큰 만료",
      "handling": "재로그인 유도"
    }
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

  ApiException({
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
      return ApiException(
        code: 'TIMEOUT',
        message: '요청 시간이 초과되었습니다',
      );
    case DioExceptionType.connectionError:
      return ApiException(
        code: 'NETWORK_ERROR',
        message: '네트워크 연결을 확인해주세요',
      );
    default:
      return ApiException(
        code: 'UNKNOWN_ERROR',
        message: '알 수 없는 오류가 발생했습니다',
      );
  }
}

/// 에러 코드별 처리 (Provider/Controller에서 사용)
void handleApiError(BuildContext context, ApiException error) {
  switch (error.code) {
    case 'UNAUTHORIZED':
    case 'TOKEN_EXPIRED':
      // 토큰 삭제 후 로그인 화면으로
      context.read<AuthProvider>().logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
      "screen": "홈",
      "on_enter": "GET /todos",
      "actions": [
        { "action": "체크박스 탭", "api": "PATCH /todos/{id}/complete" },
        { "action": "카드 탭", "api": "- (상세 화면 이동)" },
        { "action": "FAB(+) 탭", "api": "- (추가 화면 이동)" },
        { "action": "탭 전환", "api": "GET /todos?filter=today/all/tag" }
      ]
    },
    {
      "screen": "추가",
      "on_enter": "GET /tags",
      "actions": [
        { "action": "저장 버튼", "api": "POST /todos" }
      ]
    },
    {
      "screen": "상세",
      "on_enter": "GET /todos/{id}",
      "actions": [
        { "action": "수정 버튼", "api": "- (수정 화면 이동)" },
        { "action": "삭제 버튼", "api": "DELETE /todos/{id}" },
        { "action": "완료 버튼", "api": "PATCH /todos/{id}/complete" }
      ]
    },
    {
      "screen": "수정",
      "on_enter": "GET /todos/{id}, GET /tags",
      "actions": [
        { "action": "저장 버튼", "api": "PUT /todos/{id}" }
      ]
    },
    {
      "screen": "완료 목록",
      "on_enter": "GET /todos/completed",
      "actions": [
        { "action": "복원 아이콘", "api": "PATCH /todos/{id}/restore" },
        { "action": "스와이프 삭제", "api": "DELETE /todos/{id}" }
      ]
    },
    {
      "screen": "검색",
      "on_enter": "-",
      "actions": [
        { "action": "검색 실행", "api": "GET /todos/search" }
      ]
    },
    {
      "screen": "마이페이지",
      "on_enter": "GET /users/me",
      "actions": [
        { "action": "알림 토글", "api": "PUT /users/me/settings" },
        { "action": "로그아웃", "api": "- (토큰 삭제)" }
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
Future<List<Todo>> todos(TodosRef ref, {String? filter, int? tagId}) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getTodos(
    params: GetTodosParams(filter: filter, tagId: tagId),
  );
}

/// 할 일 상세 Provider
@riverpod
Future<Todo> todoDetail(TodoDetailRef ref, int id) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getTodoById(id);
}

/// 완료 목록 Provider
@riverpod
Future<List<Todo>> completedTodos(CompletedTodosRef ref) async {
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

// ===== Notifier (상태 변경) =====

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  Future<List<Todo>> build() async {
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
    {
      "field": "title",
      "rules": ["required", "max:100"],
      "messages": {
        "required": "제목을 입력해주세요",
        "max": "제목은 100자 이내로 입력해주세요"
      }
    },
    {
      "field": "memo",
      "rules": ["max:500"],
      "messages": {
        "max": "메모는 500자 이내로 입력해주세요"
      }
    },
    {
      "field": "dueDate",
      "rules": ["valid_date", "future_or_today"],
      "messages": {
        "valid_date": "올바른 날짜를 선택해주세요",
        "future_or_today": "과거 날짜는 선택할 수 없습니다"
      }
    },
    {
      "field": "priority",
      "rules": ["enum:high,normal,low"],
      "messages": {
        "enum": "올바른 우선순위를 선택해주세요"
      }
    }
  ],
  "auth_validation": [
    {
      "field": "email",
      "rules": ["required", "email"],
      "messages": {
        "required": "이메일을 입력해주세요",
        "email": "올바른 이메일 형식이 아닙니다"
      }
    },
    {
      "field": "password",
      "rules": ["required", "min:8"],
      "messages": {
        "required": "비밀번호를 입력해주세요",
        "min": "비밀번호는 8자 이상이어야 합니다"
      }
    },
    {
      "field": "nickname",
      "rules": ["max:50"],
      "messages": {
        "max": "닉네임은 50자 이내로 입력해주세요"
      }
    }
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
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
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
}
```

### 8-2. 페이지네이션

```json
{
  "pagination": {
    "request": {
      "page": "number (default: 1, 1부터 시작)",
      "limit": "number (default: 20, max: 100)"
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
    { "value": "completedAt", "description": "완료일 기준 (완료 목록)", "default_order": "desc" }
  ],
  "order_options": [
    { "value": "asc", "description": "오름차순" },
    { "value": "desc", "description": "내림차순" }
  ]
}
```
```

### Step 4: 결과 보고

생성 완료 후 다음 정보 제공:

```
Frontend API 문서 생성 완료!

생성된 파일:
docs/api/{project}_frontend_api_doc.md

문서 구성:
1. API 개요 (Base URL, 공통 헤더, 응답 형식)
2. API 엔드포인트 ({n}개 API 상세 명세) - JSON + Flutter 코드
3. 테이블 상세 정의 ({n}개 테이블) - JSON 형식
4. 타입 정의 (Flutter/Dart 모델)
5. 에러 코드 정의 - JSON + Flutter 에러 핸들링
6. 화면별 API 호출 가이드 - JSON + Riverpod Provider
7. 유효성 검사 규칙 - JSON + Flutter Validator
8. 부록 (날짜 형식, 페이지네이션, 정렬) - JSON 형식

다음 단계:
- Flutter 개발자: API 연동 개발 시작
- 모델 클래스를 lib/models/ 디렉토리로 복사하여 사용
```

---

## Output Rules

### 파일 저장 위치
```
docs/api/
└── {project}_frontend_api_doc.md
```

### 파일명 규칙
- 프로젝트명은 backend_spec.md 파일명에서 추출
- 소문자, 언더스코어 사용
- 예: `todolist_backend_spec.md` -> `todolist_frontend_api_doc.md`

### 문서 작성 규칙
1. **코드는 Flutter/Dart로 통일**
2. **정보/데이터는 JSON 형식으로 통일**
3. 모든 API에 Flutter 사용 예시 코드 포함
4. 에러 케이스별 Flutter 처리 방법 명시
5. Riverpod Provider 패턴 예시 포함

---

## Notes

- Backend 기획서의 모든 API를 빠짐없이 문서화
- 인증이 필요한 API는 명확히 표시
- 에러 처리 방법을 Flutter 관점에서 설명
- Dart 모델 클래스는 실제 코드에 바로 사용 가능하도록 ���성
- JSON 형식으로 정보를 구조화하여 파싱/자동화 가능하도록 함
