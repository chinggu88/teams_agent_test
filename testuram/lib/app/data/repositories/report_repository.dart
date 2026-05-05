import 'dart:developer';

import 'package:testuram/app/data/models/report_model.dart';
import 'package:testuram/app/data/models/yuram_coordinate_model.dart';
import 'package:testuram/services/api_service.dart';

/// 유람 좌표 분석 / 종합 리포트 조회 API.
///
/// - 정보 수집 완료 후 유람 좌표 분석 호출
/// - 회원가입 완료 후 종합 리포트 조회
class ReportRepository {
  ReportRepository();

  /// 1. 유람 좌표 분석 결과 조회
  /// POST /yuram-coordinate/analyze
  ///
  /// 사용자의 출생 정보를 기반으로 좌표를 분석한다.
  Future<YuramCoordinateModel?> analyzeYuramCoordinate({
    required String birthDate,
    String? birthTime,
    String? birthLocation,
    String? gender,
  }) async {
    try {
      final body = <String, dynamic>{
        'birthDate': birthDate,
        if (birthTime != null) 'birthTime': birthTime,
        if (birthLocation != null) 'birthLocation': birthLocation,
        if (gender != null) 'gender': gender,
      };

      final response = await ApiService.to.post(
        '/yuram-coordinate/analyze',
        data: body,
      );

      if (ApiService.to.isSuccessResponse(response)) {
        return YuramCoordinateModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Analyze yuram coordinate failed: $e');
      rethrow;
    }
  }

  /// 2. 내 종합 리포트 조회
  /// GET /reports/me
  Future<ReportModel?> getMyReport() async {
    try {
      final response = await ApiService.to.get('/reports/me');

      if (ApiService.to.isSuccessResponse(response)) {
        return ReportModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get my report failed: $e');
      rethrow;
    }
  }

  /// 3. 종합 리포트 단일 조회
  /// GET /reports/{id}
  Future<ReportModel?> getReport(String id) async {
    try {
      final response = await ApiService.to.get('/reports/$id');

      if (ApiService.to.isSuccessResponse(response)) {
        return ReportModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('Get report failed: $e');
      rethrow;
    }
  }
}
