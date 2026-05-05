import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testuram/app/core/values/app_colors.dart';
import 'package:testuram/app/core/values/app_text_styles.dart';
import 'package:testuram/app/modules/user_info/controllers/user_info_controller.dart';

/// 정보 수집 화면.
///
/// 모든 입력 필드를 단일 스크롤 화면에 배치한다.
/// 이름·성별·생년월일·태어난 곳 섹션이 순서대로 나열되며,
/// 하단 고정 버튼으로 제출한다.
class UserInfoView extends GetView<UserInfoController> {
  const UserInfoView({super.key});

  static const Color _bgPrimary        = Color(0xFFFEFCFF);
  static const Color _labelColor       = Color(0xFF181818);
  static const Color _errorRed         = Color(0xFFF0000C);
  static const Color _placeholderGray  = Color(0xFFD6D6D6);
  static const Color _borderLight      = Color(0xFFF1F1F1);
  static const Color _genderSelBg      = Color(0xFFF7F1FE);
  static const Color _genderSelBorder  = Color(0xFFA395F4);
  static const Color _genderSelText    = Color(0xFF7B67EF);
  static const Color _genderUnselBord  = Color(0xFFE8E7ED);
  static const Color _radioText        = Color(0xFF6A6A6A);
  static const Color _accentMid        = Color(0xFFA395F4);
  static const Color _disabledBg       = Color(0xFFF1F1F1);
  static const Color _disabledText     = Color(0xFF929292);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _bgPrimary,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNameSection(context),
                        SizedBox(height: 36.h),
                        _buildGenderSection(),
                        SizedBox(height: 36.h),
                        _buildBirthDatetimeSection(context),
                        SizedBox(height: 36.h),
                        _buildBirthLocationSection(context),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 16.w, 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.lightTextPrimary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section label helper
  // ---------------------------------------------------------------------------

  Widget _buildSectionLabel(String label, {bool required = true}) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.onboardingSubButton.copyWith(
            color: _labelColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        if (required) ...[
          SizedBox(width: 2.w),
          Text(
            '*',
            style: TextStyle(
              color: _errorRed,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 1. 이름 섹션
  // ---------------------------------------------------------------------------

  Widget _buildNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('이름'),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 232.w,
              height: 50.h,
              child: TextField(
                controller: controller.nameController,
                maxLength: 6,
                style: AppTextStyles.primaryButton.copyWith(
                  color: AppColors.lightTextPrimary,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: '최대6글자 이름을 입력해주세요',
                  hintStyle: AppTextStyles.onboardingSubButton.copyWith(
                    color: _placeholderGray,
                    fontSize: 14.sp,
                  ),
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: _borderLight, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.primaryPurpleLight, width: 1.5),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showHanjaBottomSheet(context),
              child: Container(
                width: 100.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '한자 찾기',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildNameTypeRadios(),
      ],
    );
  }

  /// 이름 유형 라디오 (순우리말 / 한자 모름)
  Widget _buildNameTypeRadios() {
    // 간단한 라디오 UI — 별도 obs 없이 표시 전용
    return Row(
      children: [
        _buildRadioOption(label: '순우리말', groupTag: 'name_type', value: 'pure'),
        SizedBox(width: 16.w),
        _buildRadioOption(
            label: '한자 모름', groupTag: 'name_type', value: 'unknown_hanja'),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 한자 찾기 바텀시트
  // ---------------------------------------------------------------------------

  void _showHanjaBottomSheet(BuildContext context) {
    // 현재 입력된 이름으로 글자 탭 생성
    final currentName = controller.nameController.text.trim();
    final chars =
        currentName.isNotEmpty ? currentName.characters.toList() : ['?'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HanjaBottomSheet(
        nameChars: chars,
        hanjaController: controller.hanjaController,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. 성별 섹션
  // ---------------------------------------------------------------------------

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('성별'),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 170.w, child: _buildGenderOption(value: 'female', label: '여성')),
            SizedBox(width: 170.w, child: _buildGenderOption(value: 'male', label: '남성')),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption({required String value, required String label}) {
    return Obx(() {
      final selected = controller.gender == value;
      return GestureDetector(
        onTap: () => controller.selectGender(value),
        child: Container(
          height: 50.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: selected ? _genderSelBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? _genderSelBorder : _genderUnselBord,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _genderSelText : _radioText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      );
    });
  }



  // ---------------------------------------------------------------------------
  // 3. 생년월일 섹션
  // ---------------------------------------------------------------------------

  Widget _buildBirthDatetimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('생년월일시'),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 양력/음력 드롭다운
            _buildCalendarDropdown(),
            // 날짜 입력
            _buildDatePickerField(context),
            // 시간 입력
            _buildTimePickerField(context),
          ],
        ),
        SizedBox(height: 16.h),
        _buildBirthTimeUnknownRadio(),
      ],
    );
  }

  Widget _buildCalendarDropdown() {
    // 양력/음력 선택 (표시 전용 샘플 드롭다운)
    return Container(
      width: 100.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: _borderLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '양력',
            style: TextStyle(
              color: AppColors.lightTextPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down,
            color: _accentMid,
            size: 20.r,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Obx(() {
      final value = controller.birthDate ?? '';
      return GestureDetector(
        onTap: () => _pickDate(context),
        child: Container(
          width: 135.w,
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: _borderLight,
              width: 1,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value.isEmpty ? 'YYYY/MM/DD' : value.replaceAll('-', '/'),
            style: TextStyle(
              color: value.isEmpty
                  ? AppColors.lightTextTertiary
                  : AppColors.lightTextPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimePickerField(BuildContext context) {
    return Obx(() {
      final isUnknown = controller.birthTimeUnknown;
      final value = controller.birthTime;
      final display = isUnknown
          ? '모름'
          : (value == null || value.isEmpty || value == 'unknown'
              ? '00:00'
              : value);

      return GestureDetector(
        onTap: isUnknown ? null : () => _pickTime(context),
        child: Container(
          height: 50.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isUnknown
                ? AppColors.lightBorder.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: _borderLight,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            display,
            style: TextStyle(
              color: isUnknown ? AppColors.lightTextSecondary : AppColors.lightTextPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBirthTimeUnknownRadio() {
    return Obx(() {
      final isUnknown = controller.birthTimeUnknown;
      return GestureDetector(
        onTap: () => controller.toggleBirthTimeUnknown(!isUnknown),
        child: Row(
          children: [
            _buildRadioCircle(selected: isUnknown),
            SizedBox(width: 8.w),
            Text(
              '태어난 시간을 몰라요',
              style: AppTextStyles.onboardingSubButton.copyWith(
                color: isUnknown ? _labelColor : _radioText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // 4. 태어난 곳 섹션
  // ---------------------------------------------------------------------------

  Widget _buildBirthLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('태어난 곳'),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => _showLocationBottomSheet(context),
          child: Obx(() {
            final loc = controller.birthLocation;
            return Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: _borderLight,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      loc.isEmpty ? '서울, 대한민국' : loc,
                      style: TextStyle(
                        color: loc.isEmpty
                            ? _placeholderGray
                            : AppColors.lightTextPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: _accentMid,
                    size: 20.r,
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 12.h),
        _buildLocationUnknownRadio(),
      ],
    );
  }

  Widget _buildLocationUnknownRadio() {
    // 태어난 곳 모름 라디오 (표시 전용 — 컨트롤러에 별도 obs 없음)
    return Row(
      children: [
        _buildRadioCircle(selected: false),
        SizedBox(width: 8.w),
        Text(
          '태어난 곳을 몰라요',
          style: AppTextStyles.onboardingSubButton.copyWith(
            color: _radioText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 태어난 곳 검색 바텀시트
  // ---------------------------------------------------------------------------

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _LocationSearchBottomSheet(
        onSelect: (String location) {
          controller.locationController.text = location;
          controller.birthLocation = location;
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 하단 제출 버튼
  // ---------------------------------------------------------------------------

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 17.h),
      child: Obx(() {
        final canSubmit =
            controller.name.isNotEmpty &&
            controller.gender != null &&
            controller.birthDate != null;
        return SizedBox(
          width: 343.w,
          height: 54.h,
          child: ElevatedButton(
            onPressed: controller.isSubmitting ? null : controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit
                  ? AppColors.primaryPurple
                  : _disabledBg,
              foregroundColor: canSubmit ? AppColors.white : _disabledText,
              disabledBackgroundColor: _disabledBg,
              disabledForegroundColor: _disabledText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 0,
            ),
            child: Text(
              '우주 리포트 열기',
              style: AppTextStyles.primaryButton.copyWith(fontSize: 16.sp),
            ),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // 공통 UI 헬퍼
  // ---------------------------------------------------------------------------

  /// 라디오 원형 아이콘
  Widget _buildRadioCircle({required bool selected}) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              selected ? AppColors.primaryPurpleLight : AppColors.primaryPurple,
          width: 1.5.w,
        ),
        color: selected
            ? AppColors.primaryPurple.withValues(alpha: 0.3)
            : Colors.transparent,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryPurple,
                ),
              ),
            )
          : null,
    );
  }

  /// 표시 전용 라디오 옵션 (이름 유형 등 단순 표시)
  Widget _buildRadioOption({
    required String label,
    required String groupTag,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRadioCircle(selected: false),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.onboardingSubButton.copyWith(
            color: _radioText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DatePicker / TimePicker
  // ---------------------------------------------------------------------------

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = controller.birthDate != null
        ? (DateTime.tryParse(controller.birthDate!) ?? DateTime(2000, 1, 1))
        : DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryPurple,
            onPrimary: AppColors.white,
            surface: AppColors.lightBackgroundGradientBottom,
            onSurface: AppColors.lightTextPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) controller.selectBirthDate(picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryPurple,
            onPrimary: AppColors.white,
            surface: AppColors.lightBackgroundGradientBottom,
            onSurface: AppColors.lightTextPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) controller.selectBirthTime(picked);
  }
}

// =============================================================================
// 한자 찾기 바텀시트
// =============================================================================

/// 이름 글자별 탭으로 한자를 선택하는 바텀시트.
class _HanjaBottomSheet extends StatefulWidget {
  const _HanjaBottomSheet({
    required this.nameChars,
    required this.hanjaController,
  });

  final List<String> nameChars;
  final TextEditingController hanjaController;

  @override
  State<_HanjaBottomSheet> createState() => _HanjaBottomSheetState();
}

class _HanjaBottomSheetState extends State<_HanjaBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // 샘플 한자 데이터 (글자 → 한자 목록)
  final Map<String, List<Map<String, String>>> _hanjaData = {
    '기본': [
      {'hanja': '金', 'meaning': '금 금'},
      {'hanja': '木', 'meaning': '나무 목'},
      {'hanja': '水', 'meaning': '물 수'},
      {'hanja': '火', 'meaning': '불 화'},
      {'hanja': '土', 'meaning': '흙 토'},
      {'hanja': '山', 'meaning': '뫼 산'},
      {'hanja': '川', 'meaning': '내 천'},
      {'hanja': '日', 'meaning': '날 일'},
      {'hanja': '月', 'meaning': '달 월'},
      {'hanja': '星', 'meaning': '별 성'},
    ],
  };

  List<Map<String, String>> get _currentHanjaList {
    final key = _hanjaData.keys.first;
    return _hanjaData[key] ?? [];
  }

  String _selectedHanjas = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.nameChars.length,
      vsync: this,
    );
    _selectedHanjas = widget.hanjaController.text;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.75.sh,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // 탭 바 (글자별)
          Container(
            margin: EdgeInsets.only(top: 16.h),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primaryPurpleLight,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.lightTextPrimary,
              unselectedLabelColor: AppColors.lightTextSecondary,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: widget.nameChars
                  .map((c) => Tab(text: c))
                  .toList(),
            ),
          ),
          // 검색 필드
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.lightTextPrimary, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: '한자 검색',
                hintStyle: TextStyle(
                  color: AppColors.lightTextTertiary,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.lightTextSecondary,
                  size: 20.r,
                ),
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // 한자 목록
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.nameChars.map((_) {
                final query = _searchController.text.trim();
                final list = _currentHanjaList
                    .where((item) =>
                        query.isEmpty ||
                        item['hanja']!.contains(query) ||
                        item['meaning']!.contains(query))
                    .toList();
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) {
                    final item = list[i];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      leading: Text(
                        item['hanja']!,
                        style: TextStyle(
                          color: AppColors.lightTextPrimary,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      title: Text(
                        item['meaning']!,
                        style: TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedHanjas = item['hanja']!;
                        });
                      },
                      trailing: _selectedHanjas == item['hanja']
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.primaryPurpleLight,
                              size: 20.r,
                            )
                          : null,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          // 확인 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  widget.hanjaController.text = _selectedHanjas;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 태어난 곳 검색 바텀시트
// =============================================================================

/// 지역 검색 바텀시트.
///
/// 검색 입력 + 결과 목록을 제공한다.
/// 항목 선택 시 [onSelect] 콜백을 호출하고 바텀시트를 닫는다.
class _LocationSearchBottomSheet extends StatefulWidget {
  const _LocationSearchBottomSheet({required this.onSelect});

  final void Function(String location) onSelect;

  @override
  State<_LocationSearchBottomSheet> createState() =>
      _LocationSearchBottomSheetState();
}

class _LocationSearchBottomSheetState
    extends State<_LocationSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  // 샘플 지역 목록
  static const List<String> _allLocations = [
    '서울특별시, 대한민국',
    '부산광역시, 대한민국',
    '대구광역시, 대한민국',
    '인천광역시, 대한민국',
    '광주광역시, 대한민국',
    '대전광역시, 대한민국',
    '울산광역시, 대한민국',
    '세종특별자치시, 대한민국',
    '경기도 수원시, 대한민국',
    '경기도 성남시, 대한민국',
    '경기도 광주시, 대한민국',
    '경기도 용인시, 대한민국',
    '경기도 고양시, 대한민국',
    '강원도 춘천시, 대한민국',
    '충청북도 청주시, 대한민국',
    '충청남도 천안시, 대한민국',
    '전라북도 전주시, 대한민국',
    '전라남도 여수시, 대한민국',
    '경상북도 포항시, 대한민국',
    '경상남도 창원시, 대한민국',
    '제주특별자치도, 대한민국',
  ];

  List<String> get _filtered {
    final q = _searchController.text.trim();
    if (q.isEmpty) return _allLocations;
    return _allLocations.where((l) => l.contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.65.sh,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // 검색 필드
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: AppColors.lightTextPrimary, fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: '지역을 검색해주세요',
                hintStyle: TextStyle(
                  color: AppColors.lightTextTertiary,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.lightTextSecondary,
                  size: 20.r,
                ),
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // 결과 목록
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => Divider(
                color: AppColors.lightDivider,
                height: 1.h,
              ),
              itemBuilder: (ctx, i) {
                final loc = _filtered[i];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 6.h,
                  ),
                  title: Text(
                    loc,
                    style: TextStyle(
                      color: AppColors.lightTextPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => widget.onSelect(loc),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
