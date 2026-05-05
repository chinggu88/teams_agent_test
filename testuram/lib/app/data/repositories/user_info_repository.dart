import 'dart:developer';

import 'package:testuram/app/data/models/user_info_model.dart';
import 'package:testuram/services/api_service.dart';

/// 온보딩 사용자 정보 수집 / 저장 API.
///
/// - 정보 수집 단계에서 입력한 데이터를 서버에 저장
/// - 저장된 정보를 다시 조회
/// - 부분 수정
class UserInfoRepository {
  UserInfoRepository();

  /// 1. 사용자 정보 단일 조회
  /// GET /user-info/me
  Future<UserInfoModel?> getMyUserInfo() async {
    try {
      final response = await ApiService.to.get('/user-info/me');

      if (ApiService.to.isSuccessResponse(response)) {
        return UserInfoModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get my user info failed: $e');
      rethrow;
    }
  }

  /// 2. 사용자 정보 저장 (온보딩 완료)
  /// POST /user-info
  Future<UserInfoModel?> createUserInfo(UserInfoModel parameter) async {
    try {
      final response = await ApiService.to.post(
        '/user-info',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return UserInfoModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Create user info failed: $e');
      rethrow;
    }
  }

  /// 3. 사용자 정보 수정
  /// PATCH /user-info/{id}
  Future<UserInfoModel?> updateUserInfo(
    String id,
    UserInfoModel parameter,
  ) async {
    try {
      final response = await ApiService.to.patch(
        '/user-info/$id',
        data: parameter.toJson(),
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return UserInfoModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Update user info failed: $e');
      rethrow;
    }
  }
}
