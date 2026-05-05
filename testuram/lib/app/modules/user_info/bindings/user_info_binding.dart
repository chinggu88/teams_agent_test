import 'package:get/get.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 정보 수집 모듈의 의존성을 등록하는 바인딩.
class UserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserInfoController>(() => UserInfoController());
  }
}
