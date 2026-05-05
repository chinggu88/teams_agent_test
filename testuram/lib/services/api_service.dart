import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

/// HTTP 통신 글로벌 서비스 (Dio 기반).
///
/// - 베이스 URL / 공통 헤더 / 타임아웃 설정
/// - GetStorage 기반 액세스 토큰 자동 첨부
/// - 응답 성공 여부 판정 헬퍼 제공
///
/// 모든 Repository는 `ApiService.to.get/post/patch/delete` 를 통해 API를 호출한다.
class ApiService extends GetxService {
  static ApiService get to => Get.find();

  /// 서버 베이스 URL (운영 환경에 맞게 변경)
  static const String _baseUrl = 'https://api.testuram.app';

  late final Dio _dio;
  final _storage = GetStorage();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 액세스 토큰이 있으면 Authorization 헤더에 첨부
          final token = _storage.read<String>('access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          log('[ApiService] error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// HTTP 응답 성공 여부.
  ///
  /// 2xx 코드를 성공으로 본다.
  bool isSuccessResponse(Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }

  /// GET 요청
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// POST 요청
  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH 요청
  Future<Response> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT 요청
  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE 요청
  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
