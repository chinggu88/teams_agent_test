# Neulpick - Service 작성 가이드

전역 서비스(GetxService) 작성 시 프로젝트 컨벤션을 따르는 지침서입니다.

---

## 1. 파일 구조

### 1.1 파일 위치

```
lib/services/
├── api_service.dart            # API 통신 서비스
├── storage_service.dart        # 로컬 저장소 서비스
├── notification_service.dart   # 푸시 알림 서비스
├── easyloading_service.dart    # 로딩/토스트 서비스
└── app_service.dart            # 앱 상태 서비스
```

### 1.2 네이밍 규칙

| 용도 | 파일명 | 클래스명 |
|------|--------|----------|
| 전역 서비스 | `feature_service.dart` | `FeatureService` |

---

## 2. 기본 구조

### 2.1 Service 템플릿

```dart
import 'dart:developer';

import 'package:get/get.dart';

class FeatureService extends GetxService {
  // 1. 싱글톤 접근자
  static FeatureService get to => Get.find();

  // 2. 상태 변수
  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  // 3. 라이프사이클: onInit
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  // 4. 초기화 메서드
  Future<void> _initialize() async {
    try {
      // 초기화 로직
      _isInitialized.value = true;
      log('FeatureService initialized');
    } catch (e) {
      log('FeatureService initialization failed: $e');
    }
  }

  // 5. 비즈니스 로직 메서드
  void doSomething() {
    // ...
  }
}
```

### 2.2 비동기 초기화가 필요한 Service

```dart
class FeatureService extends GetxService {
  static FeatureService get to => Get.find();

  late final SomeLibrary _library;

  // onInit에서 비동기 초기화
  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  // init 메서드 (Get.putAsync에서 호출)
  Future<FeatureService> init() async {
    _library = await SomeLibrary.initialize();
    log('FeatureService initialized');
    return this;
  }
}
```

---

## 3. 서비스별 구현 패턴

### 3.1 StorageService (로컬 저장소)

```dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late final GetStorage _storage;

  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  /// 데이터 읽기
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// 데이터 쓰기
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// 데이터 삭제
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// 전체 삭제
  Future<void> clear() async {
    await _storage.erase();
  }

  /// 데이터 존재 여부
  bool hasData(String key) {
    return _storage.hasData(key);
  }
}
```

### 3.2 EasyloadingService (로딩/토스트)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EasyloadingService extends GetxService {
  static EasyloadingService get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    // EasyLoading 설정
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  /// 로딩 표시
  Future<void> showLoading([String? message]) async {
    await EasyLoading.show(status: message ?? '로딩 중...');
  }

  /// 로딩 숨김
  Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }

  /// 토스트 메시지
  void showToast(String message, {bool issuccess = true}) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = issuccess ? Color(0xFF5B7EFE) : Colors.red
      ..textColor = Colors.white;

    EasyLoading.showToast(
      message,
      toastPosition: EasyLoadingToastPosition.bottom,
      duration: const Duration(milliseconds: 2000),
    );
  }

  /// 성공 토스트
  void showSuccess(String message) {
    showToast(message, issuccess: true);
  }

  /// 에러 토스트
  void showError(String message) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.red
      ..textColor = Colors.white;

    if (!EasyLoading.isShow) {
      EasyLoading.showToast(
        message,
        duration: const Duration(milliseconds: 2000),
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
  }

  /// 정보 스낵바
  void showInfo(String message) {
    if (Get.isSnackbarOpen) return;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF2B7AE8),
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE8F4FD),
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      duration: const Duration(milliseconds: 1300),
      isDismissible: false,
      borderColor: const Color(0xFFD8E8FF),
      borderWidth: 1.0,
    );
  }
}
```

### 3.3 NotificationService (푸시 알림)

```dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// 백그라운드 메시지 핸들러 (Top-level 함수)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('백그라운드 메시지 수신: ${message.messageId}');
}

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // FCM 토큰
  final _fcmToken = ''.obs;
  String get fcmToken => _fcmToken.value;

  // Android 알림 채널
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        '중요 알림',
        description: '중요한 알림을 위한 채널입니다.',
        importance: Importance.high,
      );

  /// 서비스 초기화
  Future<NotificationService> init() async {
    // 백그라운드 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 로컬 알림 초기화
    await _initLocalNotifications();

    // Android 채널 생성
    await _createAndroidNotificationChannel();

    // FCM 토큰 가져오기
    await _getToken();

    // 메시지 리스너 설정
    _setupMessageListeners();

    return this;
  }

  /// FCM 토큰 가져오기
  Future<void> _getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          log('APNs 토큰을 가져올 수 없습니다.');
          return;
        }
      }

      final token = await _messaging.getToken();
      if (token != null) {
        _fcmToken.value = token;
        log('FCM Token: $token');
      }

      // 토큰 갱신 리스너
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken.value = newToken;
        log('FCM Token 갱신: $newToken');
      });
    } catch (e) {
      log('FCM 토큰 가져오기 실패: $e');
    }
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    log('토픽 구독: $topic');
  }

  /// 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    log('토픽 구독 해제: $topic');
  }
}
```

### 3.4 ApiService (HTTP 통신)

```dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_state_manager/get_state_manager.dart';

class ApiService extends GetxService {
  static ApiService get to => getx.Get.find();

  late final Dio _dio;

  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'accept': 'application/json'},
      ),
    );

    // 인터셉터 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('Error: ${error.response?.statusCode}');
          return handler.next(error);
        },
      ),
    );

    log('ApiService initialized');
  }

  /// GET 요청
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 요청
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH 요청
  Future<Response> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return await _dio.patch(path, data: data, options: options);
  }

  /// DELETE 요청
  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return await _dio.delete(path, data: data, options: options);
  }

  /// AccessToken 설정
  void setAccessToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// AccessToken 제거
  void clearAccessToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// 성공 응답 체크
  bool isSuccessResponse(Response response) {
    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }
}
```

---

## 4. 서비스 등록

### 4.1 InitialBinding에서 등록

```dart
// lib/app/bindings/initial_binding.dart
import 'package:get/get.dart';
import 'package:neulpick/services/api_service.dart';
import 'package:neulpick/services/storage_service.dart';
import 'package:neulpick/services/easyloading_service.dart';
import 'package:neulpick/services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // 동기 서비스
    Get.put(ApiService());
    Get.put(StorageService());
    Get.put(EasyloadingService());

    // 비동기 서비스
    await Get.putAsync(() => NotificationService().init());
  }
}
```

### 4.2 main.dart에서 설정

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      // ...
    );
  }
}
```

---

## 5. 서비스 사용

### 5.1 싱글톤 접근

```dart
// 어디서든 접근 가능
StorageService.to.write('key', 'value');
final value = StorageService.to.read<String>('key');

EasyloadingService.to.showLoading();
EasyloadingService.to.showInfo('완료되었습니다.');

ApiService.to.setAccessToken(token);
```

### 5.2 Controller에서 사용

```dart
class LoginController extends GetxController {
  Future<void> login() async {
    try {
      await EasyloadingService.to.showLoading('로그인 중...');

      final result = await AuthRepository().login(email, password);

      if (result != null) {
        // 토큰 저장
        await StorageService.to.write('accessToken', result.accessToken);

        // API 헤더에 토큰 설정
        ApiService.to.setAccessToken(result.accessToken!);

        // FCM 토큰 등록
        await NotificationService.to.registerDeviceToken();
      }
    } finally {
      await EasyloadingService.to.hideLoading();
    }
  }
}
```

---

## 6. GetxService vs GetxController

| 구분 | GetxService | GetxController |
|------|-------------|----------------|
| 용도 | 전역 서비스 | 화면 상태 관리 |
| 생명주기 | 앱 전체 | 화면 단위 |
| 등록 방식 | `Get.put()`, `Get.putAsync()` | Binding에서 `Get.lazyPut()` |
| 제거 시점 | 수동 제거 또는 앱 종료 | 화면 종료 시 자동 제거 |
| 사용 예 | API, Storage, 알림 | 화면 데이터, 폼 상태 |

---

## 7. 체크리스트

Service 작성 시 확인 사항:

- [ ] 파일 위치: `lib/services/`
- [ ] 클래스 상속: `extends GetxService`
- [ ] 싱글톤 접근자: `static FeatureService get to => Get.find()`
- [ ] `onInit()`에서 `super.onInit()` 호출
- [ ] 비동기 초기화 필요 시 `init()` 메서드 구현
- [ ] InitialBinding에 등록
- [ ] 로그 출력: `log()`

---

## 8. 참고

- [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) - 프로젝트 구조
- [CONTROLLER_GUIDE.md](CONTROLLER_GUIDE.md) - Controller 작성 가이드
- [GetX 공식 문서](https://pub.dev/packages/get)
