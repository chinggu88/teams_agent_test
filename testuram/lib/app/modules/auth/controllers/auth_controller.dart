import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testuram/app/data/models/social_auth_model.dart';
import 'package:testuram/app/data/repositories/auth_repository.dart';
import 'package:testuram/app/modules/splash/controllers/splash_controller.dart';
import 'package:testuram/app/routes/app_pages.dart';
import 'package:testuram/services/easyloading_service.dart';

/// 인증(SNS 로그인 / 회원가입) 컨트롤러.
///
/// - 카카오/구글 로그인 SDK 호출(스텁) → 서버 회원가입 API 호출
/// - 혼인 여부 선택 상태 관리(선택 사항)
/// - 인증 토큰 GetStorage 저장
class AuthController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static AuthController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------
  final AuthRepository _authRepository = AuthRepository();

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------
  final _storage = GetStorage();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  /// 로그인 진행 중 여부
  final _isAuthenticating = false.obs;
  bool get isAuthenticating => _isAuthenticating.value;
  set isAuthenticating(bool value) => _isAuthenticating.value = value;

  /// 혼인 여부 ('married' | 'single' | 'unspecified')
  final _maritalStatus = 'unspecified'.obs;
  String get maritalStatus => _maritalStatus.value;
  set maritalStatus(String value) => _maritalStatus.value = value;

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 혼인 여부 선택.
  void selectMaritalStatus(String value) {
    maritalStatus = value;
  }

  /// 카카오 로그인 → 서버 회원가입.
  Future<void> signInWithKakao() async {
    await _signInWithSocial(provider: 'kakao');
  }

  /// 구글 로그인 → 서버 회원가입.
  Future<void> signInWithGoogle() async {
    await _signInWithSocial(provider: 'google');
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  Future<void> _signInWithSocial({required String provider}) async {
    if (isAuthenticating) return;

    try {
      isAuthenticating = true;
      await EasyloadingService.to.showLoading('로그인 중...');

      final idToken = await _fetchSocialIdToken(provider);
      if (idToken == null) {
        // 사용자가 인증을 취소한 경우
        EasyloadingService.to.showInfo('로그인이 취소되었습니다.');
        return;
      }

      SocialAuthModel? auth;
      try {
        auth = await _authRepository.signInWithSocial(
          provider: provider,
          idToken: idToken,
          maritalStatus: maritalStatus,
        );
      } on DioException catch (e) {
        // 중복 회원: 이미 가입된 SNS 계정으로 로그인 시도한 경우
        if (_isDuplicateAccountError(e)) {
          log('Duplicate social account detected for $provider: $e');
          EasyloadingService.to.showInfo('이미 가입된 계정입니다.');
          return;
        }
        log('Server social sign-in failed (Dio): $e');
        rethrow;
      } catch (e) {
        log('Server social sign-in failed: $e');
      }

      if (auth?.accessToken != null) {
        await _storage.write('access_token', auth!.accessToken);
        await _storage.write('refresh_token', auth.refreshToken);
        await _storage.write('user_id', auth.userId);
      }

      await _storage.write(SplashController.kKeySignUpDone, true);

      Get.offAllNamed(Routes.REPORT);
    } catch (e) {
      log('Sign in with $provider failed: $e');
      EasyloadingService.to.showInfo('로그인에 실패했습니다. 잠시 후 다시 시도해주세요.');
    } finally {
      isAuthenticating = false;
      await EasyloadingService.to.hideLoading();
    }
  }

  /// 서버 응답이 중복 계정(409 Conflict) 또는 알려진 중복 에러 코드인지 판단한다.
  ///
  /// 백엔드가 다음 중 하나의 형태로 중복을 알리는 경우를 모두 수용한다.
  /// - HTTP 409
  /// - HTTP 400/422 + `code: 'DUPLICATE_ACCOUNT' | 'ALREADY_REGISTERED'`
  bool _isDuplicateAccountError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 409) return true;

    final data = e.response?.data;
    if (data is Map) {
      final code = (data['code'] ?? data['errorCode'])?.toString().toUpperCase();
      if (code == 'DUPLICATE_ACCOUNT' || code == 'ALREADY_REGISTERED') {
        return true;
      }
    }
    return false;
  }

  /// SNS SDK를 호출하여 ID 토큰을 받는다.
  ///
  /// 실제 SDK 연동 전 단계이므로 스텁으로 임시 토큰을 반환한다.
  /// 사용자 취소를 표현하려면 null을 반환할 수 있다.
  Future<String?> _fetchSocialIdToken(String provider) async {
    // TODO: kakao_flutter_sdk / google_sign_in 연동 후 실제 토큰 반환
    await Future.delayed(const Duration(milliseconds: 600));
    return 'stub_${provider}_id_token';
  }
}
