# Neulpick - Repository 작성 가이드

API 호출을 담당하는 Repository 작성 시 프로젝트 컨벤션을 따르는 지침서입니다.

---

## 1. 파일 구조

### 1.1 파일 위치

```
lib/app/data/repositories/
├── auth_repository.dart        # 인증 관련 API
├── user_repository.dart        # 사용자 관련 API
├── customer_repository.dart    # 고객 관련 API
├── schedule_repository.dart    # 일정 관련 API
├── plans_repository.dart       # 이용권 관련 API
├── notification_repository.dart # 알림 관련 API
├── mypage_repository.dart      # 마이페이지 관련 API
└── app_repository.dart         # 앱 설정 관련 API
```

### 1.2 네이밍 규칙

| 용도 | 파일명 | 클래스명 |
|------|--------|----------|
| 도메인별 API | `feature_repository.dart` | `FeatureRepository` |

---

## 2. 기본 구조

### 2.1 Repository 템플릿

```dart
import 'dart:developer';

import 'package:neulpick/app/data/models/featureResponse.dart';
import 'package:neulpick/app/data/models/createFeatureParameter.dart';
import 'package:neulpick/app/data/models/updateFeatureParameter.dart';
import 'package:neulpick/services/api_service.dart';

class FeatureRepository {
  FeatureRepository();

  /// 1. 목록 조회
  /// GET /features
  Future<List<FeatureResponse>?> getFeatures({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await ApiService.to.get(
        '/features',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (ApiService.to.isSuccessResponse(response)) {
        if (response.data['data'] is List) {
          return (response.data['data'] as List)
              .map((item) => FeatureResponse.fromJson(item))
              .toList();
        }
        return null;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get features failed: $e');
      rethrow;
    }
  }

  /// 2. 단일 조회
  /// GET /features/{id}
  Future<FeatureResponse?> getFeature(String id) async {
    try {
      final response = await ApiService.to.get('/features/$id');

      if (ApiService.to.isSuccessResponse(response)) {
        return FeatureResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get feature failed: $e');
      rethrow;
    }
  }

  /// 3. 생성
  /// POST /features
  Future<FeatureResponse?> createFeature(
    CreateFeatureParameter parameter,
  ) async {
    try {
      final response = await ApiService.to.post(
        '/features',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return FeatureResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Create feature failed: $e');
      rethrow;
    }
  }

  /// 4. 수정
  /// PATCH /features/{id}
  Future<FeatureResponse?> updateFeature(
    String id,
    UpdateFeatureParameter parameter,
  ) async {
    try {
      final response = await ApiService.to.patch(
        '/features/$id',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return FeatureResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Update feature failed: $e');
      rethrow;
    }
  }

  /// 5. 삭제
  /// DELETE /features/{id}
  Future<bool> deleteFeature(String id) async {
    try {
      final response = await ApiService.to.delete('/features/$id');

      return ApiService.to.isSuccessResponse(response);
    } on Exception catch (e) {
      log('Delete feature failed: $e');
      rethrow;
    }
  }
}
```

---

## 3. API 메서드 패턴

### 3.1 목록 조회 (GET - List)

```dart
/// 목록 조회
/// GET /features
Future<List<FeatureResponse>?> getFeatures({
  String? search,
  String? startDate,
  String? endDate,
}) async {
  try {
    final queryParams = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (startDate != null) {
      queryParams['startDate'] = startDate;
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate;
    }

    final response = await ApiService.to.get(
      '/features',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (ApiService.to.isSuccessResponse(response)) {
      if (response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => FeatureResponse.fromJson(item))
            .toList();
      }
      return null;
    } else {
      return null;
    }
  } on Exception catch (e) {
    log('Get features failed: $e');
    rethrow;
  }
}
```

### 3.2 단일 조회 (GET - Single)

```dart
/// 단일 조회
/// GET /features/{id}
Future<FeatureResponse?> getFeature(String id) async {
  try {
    final response = await ApiService.to.get('/features/$id');

    if (ApiService.to.isSuccessResponse(response)) {
      return FeatureResponse.fromJson(response.data['data']);
    } else {
      return null;
    }
  } on Exception catch (e) {
    log('Get feature failed: $e');
    rethrow;
  }
}
```

### 3.3 생성 (POST)

```dart
/// 생성
/// POST /features
Future<FeatureResponse?> createFeature(
  CreateFeatureParameter parameter,
) async {
  try {
    final response = await ApiService.to.post(
      '/features',
      data: parameter.toJson(),
    );

    if (ApiService.to.isSuccessResponse(response)) {
      return FeatureResponse.fromJson(response.data['data']);
    } else {
      return null;
    }
  } on Exception catch (e) {
    log('Create feature failed: $e');
    rethrow;
  }
}
```

### 3.4 수정 (PATCH)

```dart
/// 수정
/// PATCH /features/{id}
Future<FeatureResponse?> updateFeature(
  String id,
  UpdateFeatureParameter parameter,
) async {
  try {
    final response = await ApiService.to.patch(
      '/features/$id',
      data: parameter.toJson(),
    );

    if (ApiService.to.isSuccessResponse(response)) {
      return FeatureResponse.fromJson(response.data['data']);
    } else {
      return null;
    }
  } on Exception catch (e) {
    log('Update feature failed: $e');
    rethrow;
  }
}
```

### 3.5 삭제 (DELETE)

```dart
/// 삭제
/// DELETE /features/{id}
Future<bool> deleteFeature(String id) async {
  try {
    final response = await ApiService.to.delete('/features/$id');

    return ApiService.to.isSuccessResponse(response);
  } on Exception catch (e) {
    log('Delete feature failed: $e');
    rethrow;
  }
}
```

### 3.6 특수 작업 (Action)

```dart
/// 예약 취소
/// DELETE /schedules/{id}/cancel
Future<bool> cancelSchedule(String id) async {
  try {
    final response = await ApiService.to.delete('/schedules/$id/cancel');

    return ApiService.to.isSuccessResponse(response);
  } on Exception catch (e) {
    log('Cancel schedule failed: $e');
    rethrow;
  }
}

/// 이용권 차감
/// PATCH /customers/{customerId}/plans/{planId}/deduct
Future<CustomerPlanResponse?> deductCustomerPlan(
  String customerId,
  String planId, {
  int count = 1,
}) async {
  try {
    final response = await ApiService.to.patch(
      '/customers/$customerId/plans/$planId/deduct',
      data: {'count': count},
    );

    if (ApiService.to.isSuccessResponse(response)) {
      return CustomerPlanResponse.fromJson(response.data['data']);
    } else {
      return null;
    }
  } on Exception catch (e) {
    log('Deduct customer plan failed: $e');
    rethrow;
  }
}
```

---

## 4. 응답 처리

### 4.1 단일 객체 응답

```dart
// API 응답: { "data": { ... } }
if (ApiService.to.isSuccessResponse(response)) {
  return FeatureResponse.fromJson(response.data['data']);
} else {
  return null;
}
```

### 4.2 리스트 응답

```dart
// API 응답: { "data": [ {...}, {...} ] }
if (ApiService.to.isSuccessResponse(response)) {
  if (response.data['data'] is List) {
    return (response.data['data'] as List)
        .map((item) => FeatureResponse.fromJson(item))
        .toList();
  }
  return null;
} else {
  return null;
}
```

### 4.3 Boolean 응답 (성공/실패)

```dart
// 삭제, 취소 등 성공 여부만 반환
return ApiService.to.isSuccessResponse(response);
```

---

## 5. 에러 처리

### 5.1 기본 패턴

```dart
try {
  final response = await ApiService.to.get('/features/$id');
  // ...
} on Exception catch (e) {
  log('Get feature failed: $e');
  rethrow;  // Controller에서 처리하도록 다시 던짐
}
```

### 5.2 로그 메시지 형식

```dart
log('Get features failed: $e');      // 조회 실패
log('Create feature failed: $e');    // 생성 실패
log('Update feature failed: $e');    // 수정 실패
log('Delete feature failed: $e');    // 삭제 실패
log('Cancel schedule failed: $e');   // 취소 실패
```

---

## 6. HTTP 메서드 사용

### 6.1 ApiService 메서드

| HTTP Method | ApiService 메서드 | 용도 |
|-------------|-------------------|------|
| GET | `ApiService.to.get()` | 조회 |
| POST | `ApiService.to.post()` | 생성 |
| PATCH | `ApiService.to.patch()` | 부분 수정 |
| PUT | `ApiService.to.put()` | 전체 수정 |
| DELETE | `ApiService.to.delete()` | 삭제 |

### 6.2 파라미터 전달

```dart
// Query Parameters (GET)
await ApiService.to.get(
  '/features',
  queryParameters: {'search': 'keyword', 'page': 1},
);

// Request Body (POST, PATCH, PUT)
await ApiService.to.post(
  '/features',
  data: parameter.toJson(),
);

// Path Parameter
await ApiService.to.get('/features/$id');
await ApiService.to.patch('/features/$id', data: parameter.toJson());
await ApiService.to.delete('/features/$id');
```

---

## 7. 문서화 주석

### 7.1 메서드 주석 형식

```dart
/// 1. 스케줄 목록 조회
/// GET /schedules
Future<List<ScheduleResponse>?> getSchedules({
  required String startDate,
  required String endDate,
}) async {
  // ...
}

/// 2. 스케줄 생성
/// POST /schedules
Future<ScheduleResponse?> createSchedule(
  CreateScheduleParameter parameter,
) async {
  // ...
}

/// 3. 스케줄 상세 조회
/// GET /schedules/{id}
Future<ScheduleResponse?> getSchedule(String id) async {
  // ...
}
```

---

## 8. 체크리스트

Repository 작성 시 확인 사항:

- [ ] 파일명: `feature_repository.dart`
- [ ] 클래스명: `FeatureRepository`
- [ ] 빈 생성자: `FeatureRepository();`
- [ ] `ApiService.to` 사용
- [ ] `ApiService.to.isSuccessResponse()` 응답 체크
- [ ] `response.data['data']` 데이터 추출
- [ ] 리스트 응답 시 `is List` 타입 체크
- [ ] `try-catch` 에러 처리
- [ ] `log()` 에러 로깅
- [ ] `rethrow` 예외 전파
- [ ] 메서드 문서화 주석 (번호, HTTP Method, Path)

---

## 9. 전체 예시

### schedule_repository.dart

```dart
import 'dart:developer';

import 'package:neulpick/app/data/models/createScheduleParameter.dart';
import 'package:neulpick/app/data/models/updateScheduleParameter.dart';
import 'package:neulpick/app/data/models/scheduleResponse.dart';
import 'package:neulpick/services/api_service.dart';

class ScheduleRepository {
  ScheduleRepository();

  /// 1. 스케줄 목록 조회
  /// GET /schedules
  Future<List<ScheduleResponse>?> getSchedules({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await ApiService.to.get(
        '/schedules',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );

      if (ApiService.to.isSuccessResponse(response)) {
        if (response.data['data'] is List) {
          return (response.data['data'] as List)
              .map((item) => ScheduleResponse.fromJson(item))
              .toList();
        }
        return null;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get schedules failed: $e');
      rethrow;
    }
  }

  /// 2. 스케줄 생성
  /// POST /schedules
  Future<ScheduleResponse?> createSchedule(
    CreateScheduleParameter parameter,
  ) async {
    try {
      final response = await ApiService.to.post(
        '/schedules',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Create schedule failed: $e');
      rethrow;
    }
  }

  /// 3. 스케줄 상세 조회
  /// GET /schedules/{id}
  Future<ScheduleResponse?> getSchedule(String id) async {
    try {
      final response = await ApiService.to.get('/schedules/$id');

      if (ApiService.to.isSuccessResponse(response)) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get schedule failed: $e');
      rethrow;
    }
  }

  /// 4. 스케줄 수정
  /// PATCH /schedules/{id}
  Future<ScheduleResponse?> updateSchedule(
    String id,
    UpdateScheduleParameter parameter,
  ) async {
    try {
      final response = await ApiService.to.patch(
        '/schedules/$id',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Update schedule failed: $e');
      rethrow;
    }
  }

  /// 5. 스케줄 삭제
  /// DELETE /schedules/{id}
  Future<bool> deleteSchedule(String id) async {
    try {
      final response = await ApiService.to.delete('/schedules/$id');

      return ApiService.to.isSuccessResponse(response);
    } on Exception catch (e) {
      log('Delete schedule failed: $e');
      rethrow;
    }
  }

  /// 6. 예약 취소
  /// DELETE /schedules/{id}/cancel
  Future<bool> cancelSchedule(String id) async {
    try {
      final response = await ApiService.to.delete('/schedules/$id/cancel');

      return ApiService.to.isSuccessResponse(response);
    } on Exception catch (e) {
      log('Cancel schedule failed: $e');
      rethrow;
    }
  }
}
```

---

## 10. 참고

- [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) - 프로젝트 구조
- [MODEL_GUIDE.md](MODEL_GUIDE.md) - Model 작성 가이드
- [SERVICE_GUIDE.md](SERVICE_GUIDE.md) - Service 작성 가이드
