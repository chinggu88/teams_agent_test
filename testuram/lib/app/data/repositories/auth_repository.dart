import 'dart:developer';

import 'package:testuram/app/data/models/social_auth_model.dart';
import 'package:testuram/services/api_service.dart';

/// SNS 로그인 / 회원가입 API.
///
/// 카카오, 구글 등 외부 SNS 인증을 마친 뒤
/// 발급된 ID 토큰을 서버에 전달하여 회원가입 또는 로그인을 처리한다.
class AuthRepository {
  AuthRepository();

  /// 1. SNS 로그인 / 회원가입
  /// POST /auth/social
  ///
  /// [provider] 'kakao' | 'google' | 'apple'
  /// [idToken] 외부 SNS SDK가 발급한 ID 토큰
  /// [maritalStatus] 'married' | 'single' | 'unspecified' (선택)
  Future<SocialAuthModel?> signInWithSocial({
    required String provider,
    required String idToken,
    String? maritalStatus,
  }) async {
    try {
      final body = <String, dynamic>{
        'provider': provider,
        'idToken': idToken,
      };
      if (maritalStatus != null) {
        body['maritalStatus'] = maritalStatus;
      }

      final response = await ApiService.to.post(
        '/auth/social',
        data: body,
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return SocialAuthModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Sign in with social failed: $e');
      rethrow;
    }
  }

  /// 2. 토큰 재발급
  /// POST /auth/refresh
  Future<SocialAuthModel?> refreshToken(String refreshToken) async {
    try {
      final response = await ApiService.to.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return SocialAuthModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Refresh token failed: $e');
      rethrow;
    }
  }

  /// 3. 로그아웃
  /// POST /auth/logout
  Future<bool> signOut() async {
    try {
      final response = await ApiService.to.post('/auth/logout');
      return ApiService.to.isSuccessResponse(response);
    } on Exception catch (e) {
      log('Sign out failed: $e');
      rethrow;
    }
  }

  /// 4. 혼인 여부 부분 업데이트
  /// PATCH /auth/me/marital-status
  Future<bool> updateMaritalStatus(String status) async {
    try {
      final response = await ApiService.to.patch(
        '/auth/me/marital-status',
        data: {'maritalStatus': status},
      );
      return ApiService.to.isSuccessResponse(response);
    } on Exception catch (e) {
      log('Update marital status failed: $e');
      rethrow;
    }
  }
}
