import 'package:get/get.dart';
import 'package:testuram/services/api_service.dart';
import 'package:testuram/services/easyloading_service.dart';

/// 앱 최초 부팅 시 한 번만 실행되는 글로벌 바인딩.
///
/// HTTP 클라이언트(ApiService)와 로딩/토스트 서비스(EasyloadingService)를
/// `Get.put`으로 영구 등록한다.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<EasyloadingService>(EasyloadingService(), permanent: true);
  }
}
