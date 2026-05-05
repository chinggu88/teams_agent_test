import 'dart:developer';

import 'package:get/get.dart';
import 'package:testuram/app/data/models/report_model.dart';
import 'package:testuram/app/data/repositories/report_repository.dart';
import 'package:testuram/services/easyloading_service.dart';

/// 종합 리포트 컨트롤러.
///
/// 회원가입 완료 후 종합 리포트 데이터를 조회한다.
class ReportController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static ReportController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------
  final ReportRepository _reportRepository = ReportRepository();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _report = Rxn<ReportModel>();
  ReportModel? get report => _report.value;
  set report(ReportModel? value) => _report.value = value;

  final _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _loadReport();
  }

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 리포트 새로고침.
  Future<void> refreshReport() async {
    await _loadReport();
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  Future<void> _loadReport() async {
    try {
      isLoading = true;
      errorMessage = null;
      final result = await _reportRepository.getMyReport();
      if (result != null) {
        report = result;
      } else {
        errorMessage = '리포트를 불러올 수 없습니다.';
      }
    } catch (e) {
      log('Load report failed: $e');
      errorMessage = '네트워크 오류가 발생했습니다.';
      EasyloadingService.to.showInfo('리포트를 불러오는데 실패했습니다.');
    } finally {
      isLoading = false;
    }
  }
}
