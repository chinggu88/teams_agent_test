import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testuram/app/data/models/user_info_model.dart';
import 'package:testuram/app/data/repositories/user_info_repository.dart';
import 'package:testuram/app/modules/splash/controllers/splash_controller.dart';
import 'package:testuram/app/routes/app_pages.dart';
import 'package:testuram/services/easyloading_service.dart';

/// 정보 수집 컨트롤러.
///
/// 단계별 입력 폼(이름·성별·생년월일·태어난 시간·태어난 지역) 상태를 관리하고,
/// 필수 항목 유효성 검증 후 서버에 사용자 정보를 저장한다.
///
/// 단계 정의
/// - 0: 이름(국문)
/// - 1: 이름(한자) [선택]
/// - 2: 성별
/// - 3: 생년월일 + 태어난 시간(시간은 선택)
/// - 4: 태어난 지역 [선택]
class UserInfoController extends GetxController {
  // ---------------------------------------------------------------------------
  // Singleton accessor
  // ---------------------------------------------------------------------------
  static UserInfoController get to => Get.find();

  // ---------------------------------------------------------------------------
  // Constants
  // ---------------------------------------------------------------------------
  static const int totalSteps = 5;

  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------
  final UserInfoRepository _userInfoRepository = UserInfoRepository();

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------
  final _storage = GetStorage();

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  /// 현재 단계 (0 ~ totalSteps - 1)
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;
  set currentStep(int value) => _currentStep.value = value;

  /// 제출 진행 중 여부
  final _isSubmitting = false.obs;
  bool get isSubmitting => _isSubmitting.value;
  set isSubmitting(bool value) => _isSubmitting.value = value;

  /// 이름 (국문, 필수)
  final _name = ''.obs;
  String get name => _name.value;
  set name(String value) => _name.value = value;

  /// 이름 (한자, 선택)
  final _hanjaName = ''.obs;
  String get hanjaName => _hanjaName.value;
  set hanjaName(String value) => _hanjaName.value = value;

  /// 성별 ('male' | 'female')
  final _gender = RxnString();
  String? get gender => _gender.value;
  set gender(String? value) => _gender.value = value;

  /// 생년월일 (YYYY-MM-DD)
  final _birthDate = RxnString();
  String? get birthDate => _birthDate.value;
  set birthDate(String? value) => _birthDate.value = value;

  /// 태어난 시간 (HH:mm) - 미입력 시 'unknown'
  final _birthTime = RxnString();
  String? get birthTime => _birthTime.value;
  set birthTime(String? value) => _birthTime.value = value;

  /// 태어난 시간 모름 토글
  final _birthTimeUnknown = false.obs;
  bool get birthTimeUnknown => _birthTimeUnknown.value;
  set birthTimeUnknown(bool value) => _birthTimeUnknown.value = value;

  /// 태어난 지역 (선택)
  final _birthLocation = ''.obs;
  String get birthLocation => _birthLocation.value;
  set birthLocation(String value) => _birthLocation.value = value;

  // ---------------------------------------------------------------------------
  // UI Controllers
  // ---------------------------------------------------------------------------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hanjaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final PageController pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_onNameChanged);
    hanjaController.addListener(_onHanjaChanged);
    locationController.addListener(_onLocationChanged);
  }

  @override
  void onClose() {
    nameController.removeListener(_onNameChanged);
    hanjaController.removeListener(_onHanjaChanged);
    locationController.removeListener(_onLocationChanged);
    nameController.dispose();
    hanjaController.dispose();
    locationController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Listeners
  // ---------------------------------------------------------------------------

  void _onNameChanged() {
    name = nameController.text.trim();
  }

  void _onHanjaChanged() {
    hanjaName = hanjaController.text.trim();
  }

  void _onLocationChanged() {
    birthLocation = locationController.text.trim();
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  /// 현재 단계의 필수 입력이 충족되었는지 여부.
  bool get canProceedCurrentStep {
    switch (currentStep) {
      case 0:
        return _isValidName(name);
      case 1:
        return true;
      case 2:
        return gender != null && gender!.isNotEmpty;
      case 3:
        return _isValidBirthDate(birthDate);
      case 4:
        return true;
      default:
        return false;
    }
  }

  bool _isValidName(String value) {
    if (value.isEmpty) return false;
    final regex = RegExp(r'^[가-힣A-Za-z]{1,20}$');
    return regex.hasMatch(value);
  }

  bool _isValidBirthDate(String? value) {
    if (value == null || value.isEmpty) return false;
    final date = DateTime.tryParse(value);
    if (date == null) return false;
    final now = DateTime.now();
    if (date.isAfter(now)) return false;
    if (date.year < 1900) return false;
    return true;
  }

  // ---------------------------------------------------------------------------
  // Business Logic Methods
  // ---------------------------------------------------------------------------

  /// 다음 단계로 이동.
  ///
  /// 현재 단계의 유효성 검증 실패 시 안내 메시지를 표시한다.
  void nextStep() {
    if (!canProceedCurrentStep) {
      EasyloadingService.to.showInfo(_invalidMessage());
      return;
    }

    if (currentStep < totalSteps - 1) {
      currentStep = currentStep + 1;
      _animateTo(currentStep);
    } else {
      submit();
    }
  }

  /// 이전 단계로 이동.
  void previousStep() {
    if (currentStep > 0) {
      currentStep = currentStep - 1;
      _animateTo(currentStep);
    } else {
      Get.back();
    }
  }

  /// 성별 선택.
  void selectGender(String value) {
    gender = value;
  }

  /// 생년월일 선택.
  ///
  /// [date] 사용자가 DatePicker로 선택한 날짜.
  void selectBirthDate(DateTime date) {
    final formatted =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    birthDate = formatted;
  }

  /// 태어난 시간 선택.
  void selectBirthTime(TimeOfDay time) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    birthTime = formatted;
    birthTimeUnknown = false;
  }

  /// 태어난 시간 '모름' 토글.
  void toggleBirthTimeUnknown(bool value) {
    birthTimeUnknown = value;
    if (value) {
      birthTime = 'unknown';
    } else {
      birthTime = null;
    }
  }

  /// 정보 수집 제출.
  ///
  /// 서버 저장 후 온보딩(유람 좌표) 화면으로 이동한다.
  Future<void> submit() async {
    if (!_isAllRequiredValid()) {
      EasyloadingService.to.showInfo('필수 항목을 모두 입력해주세요.');
      return;
    }

    try {
      isSubmitting = true;
      await EasyloadingService.to.showLoading('저장 중...');

      final model = UserInfoModel(
        name: name,
        hanjaName: hanjaName.isEmpty ? null : hanjaName,
        gender: gender,
        birthDate: birthDate,
        birthTime: birthTime ?? 'unknown',
        birthLocation: birthLocation.isEmpty ? null : birthLocation,
      );

      // 서버 저장 (실패해도 로컬에는 보관)
      try {
        await _userInfoRepository.createUserInfo(model);
      } catch (e) {
        log('Persist user info to server failed: $e');
      }

      _persistLocally(model);
      await _storage.write(SplashController.kKeyUserInfoDone, true);

      Get.offAllNamed(Routes.ONBOARDING);
    } catch (e) {
      log('Submit user info failed: $e');
      EasyloadingService.to.showInfo('저장에 실패했습니다. 잠시 후 다시 시도해주세요.');
    } finally {
      isSubmitting = false;
      await EasyloadingService.to.hideLoading();
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  bool _isAllRequiredValid() {
    return _isValidName(name) &&
        gender != null &&
        gender!.isNotEmpty &&
        _isValidBirthDate(birthDate);
  }

  String _invalidMessage() {
    switch (currentStep) {
      case 0:
        return '이름을 정확히 입력해주세요. (한글/영문 1~20자)';
      case 2:
        return '성별을 선택해주세요.';
      case 3:
        return '생년월일을 정확히 선택해주세요.';
      default:
        return '입력 값을 확인해주세요.';
    }
  }

  void _animateTo(int page) {
    if (!pageController.hasClients) return;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _persistLocally(UserInfoModel model) {
    _storage.write('user_info', model.toJson());
  }
}
