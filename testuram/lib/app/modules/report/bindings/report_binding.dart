import 'package:get/get.dart';
import 'package:testuram/app/modules/report/controllers/report_controller.dart';

/// 종합 리포트 모듈의 의존성을 등록하는 바인딩.
class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
