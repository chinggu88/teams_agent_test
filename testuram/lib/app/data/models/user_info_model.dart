/// 온보딩 정보 수집 모델.
///
/// 사용자가 온보딩 단계에서 입력한 기본 정보를 표현한다.
/// - 이름(국문) [필수]
/// - 이름(한자) [선택]
/// - 성별 [필수]
/// - 생년월일 [필수]
/// - 태어난 시간 [선택, 미입력 시 'unknown']
/// - 태어난 지역 [선택]
class UserInfoModel {
  /// 고유 ID (서버 발급)
  String? _id;

  /// 이름 (국문, 필수)
  String? _name;

  /// 이름 (한자, 선택)
  String? _hanjaName;

  /// 성별 ('male' | 'female')
  String? _gender;

  /// 생년월일 (YYYY-MM-DD)
  String? _birthDate;

  /// 태어난 시간 (HH:mm) - 미입력 시 'unknown'
  String? _birthTime;

  /// 태어난 지역 (선택, 예: "서울특별시 강남구")
  String? _birthLocation;

  /// 생성일시
  String? _createdAt;

  /// 수정일시
  String? _updatedAt;

  // 생성자
  UserInfoModel({
    String? id,
    String? name,
    String? hanjaName,
    String? gender,
    String? birthDate,
    String? birthTime,
    String? birthLocation,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _hanjaName = hanjaName;
    _gender = gender;
    _birthDate = birthDate;
    _birthTime = birthTime;
    _birthLocation = birthLocation;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  // Getter / Setter
  String? get id => _id;
  set id(String? id) => _id = id;

  String? get name => _name;
  set name(String? name) => _name = name;

  String? get hanjaName => _hanjaName;
  set hanjaName(String? hanjaName) => _hanjaName = hanjaName;

  String? get gender => _gender;
  set gender(String? gender) => _gender = gender;

  String? get birthDate => _birthDate;
  set birthDate(String? birthDate) => _birthDate = birthDate;

  String? get birthTime => _birthTime;
  set birthTime(String? birthTime) => _birthTime = birthTime;

  String? get birthLocation => _birthLocation;
  set birthLocation(String? birthLocation) => _birthLocation = birthLocation;

  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;

  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  /// JSON 역직렬화 (서버 응답 → 객체)
  UserInfoModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _hanjaName = json['hanjaName'];
    _gender = json['gender'];
    _birthDate = json['birthDate'];
    _birthTime = json['birthTime'];
    _birthLocation = json['birthLocation'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  /// JSON 직렬화 (객체 → 서버 요청 본문)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['hanjaName'] = _hanjaName;
    data['gender'] = _gender;
    data['birthDate'] = _birthDate;
    data['birthTime'] = _birthTime;
    data['birthLocation'] = _birthLocation;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }
}
