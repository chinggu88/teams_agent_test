import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testuram/app/data/models/user_info_model.dart';
import 'package:testuram/app/data/models/yuram_coordinate_model.dart';
import 'package:testuram/app/data/repositories/report_repository.dart';
import 'package:testuram/app/routes/app_pages.dart';
import 'package:testuram/services/easyloading_service.dart';

/// 유람 좌표 분석 결과 온보딩 컨트롤러.
///
/// 정보 수집 화면을 통과한 사용자를 대상으로
/// 서버에 분석을 요청하고 결과를 화면에 표시한다.
/// "회원가입하고 종합 리포트 받기" 액션 시 SNS 회원가입 화면으로 이동한다.
class OnboardingController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static OnboardingController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------
  final ReportRepository _reportRepository = ReportRepository();

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------
  final _storage = GetStorage();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _coordinate = Rxn<YuramCoordinateModel>();
  YuramCoordinateModel? get coordinate => _coordinate.value;
  set coordinate(YuramCoordinateModel? value) => _coordinate.value = value;

  final _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _analyze();
  }

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 유람 좌표 분석을 다시 시도한다.
  Future<void> retry() async {
    await _analyze();
  }

  /// "회원가입하고 종합 리포트 받기" — SNS 회원가입 화면으로 이동.
  void goToAuth() {
    Get.toNamed(Routes.AUTH);
  }

  /// 뒤로가기 — 정보 수집 단계로 복귀.
  void goBack() {
    Get.offAllNamed(Routes.USER_INFO);
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  /// 로컬에 저장된 사용자 정보로 좌표 분석을 호출한다.
  Future<void> _analyze() async {
    try {
      isLoading = true;
      errorMessage = null;

      final raw = _storage.read('user_info');
      if (raw == null) {
        errorMessage = '사용자 정보를 찾을 수 없습니다.';
        return;
      }

      final info = UserInfoModel.fromJson(Map<String, dynamic>.from(raw));
      if (info.birthDate == null) {
        errorMessage = '생년월일이 없습니다.';
        return;
      }

      final result = await _reportRepository.analyzeYuramCoordinate(
        birthDate: info.birthDate!,
        birthTime: info.birthTime,
        birthLocation: info.birthLocation,
        gender: info.gender,
      );

      if (result != null) {
        coordinate = result;
      } else {
        errorMessage = '분석 결과를 불러오지 못했습니다.';
      }
    } catch (e) {
      log('Analyze yuram coordinate failed: $e');
      errorMessage = '네트워크 오류가 발생했습니다.';
      EasyloadingService.to.showInfo('잠시 후 다시 시도해주세요.');
    } finally {
      isLoading = false;
    }
  }
}
