/// SNS 소셜 로그인 응답 모델.
///
/// 카카오 / 구글 등 외부 SNS 인증 후 서버로부터 전달받는 인증 정보를 표현한다.
class SocialAuthModel {
  /// 회원 고유 ID
  String? _userId;

  /// 액세스 토큰 (Authorization 헤더용)
  String? _accessToken;

  /// 리프레시 토큰
  String? _refreshToken;

  /// 토큰 만료 시각 (ISO 8601)
  String? _expiresAt;

  /// 소셜 제공자 ('kakao' | 'google' | 'apple')
  String? _provider;

  /// 신규 가입 여부 (true: 회원가입 직후, false: 기존 회원 로그인)
  bool? _isNewUser;

  /// 사용자 이메일
  String? _email;

  /// 사용자 닉네임
  String? _nickname;

  /// 프로필 이미지 URL
  String? _profileImageUrl;

  /// 혼인 상태 ('married' | 'single' | 'unspecified')
  String? _maritalStatus;

  /// 생성일시
  String? _createdAt;

  /// 수정일시
  String? _updatedAt;

  // 생성자
  SocialAuthModel({
    String? userId,
    String? accessToken,
    String? refreshToken,
    String? expiresAt,
    String? provider,
    bool? isNewUser,
    String? email,
    String? nickname,
    String? profileImageUrl,
    String? maritalStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    _userId = userId;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiresAt = expiresAt;
    _provider = provider;
    _isNewUser = isNewUser;
    _email = email;
    _nickname = nickname;
    _profileImageUrl = profileImageUrl;
    _maritalStatus = maritalStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  // Getter / Setter
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;

  String? get accessToken => _accessToken;
  set accessToken(String? accessToken) => _accessToken = accessToken;

  String? get refreshToken => _refreshToken;
  set refreshToken(String? refreshToken) => _refreshToken = refreshToken;

  String? get expiresAt => _expiresAt;
  set expiresAt(String? expiresAt) => _expiresAt = expiresAt;

  String? get provider => _provider;
  set provider(String? provider) => _provider = provider;

  bool? get isNewUser => _isNewUser;
  set isNewUser(bool? isNewUser) => _isNewUser = isNewUser;

  String? get email => _email;
  set email(String? email) => _email = email;

  String? get nickname => _nickname;
  set nickname(String? nickname) => _nickname = nickname;

  String? get profileImageUrl => _profileImageUrl;
  set profileImageUrl(String? profileImageUrl) =>
      _profileImageUrl = profileImageUrl;

  String? get maritalStatus => _maritalStatus;
  set maritalStatus(String? maritalStatus) => _maritalStatus = maritalStatus;

  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;

  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  /// JSON 역직렬화
  SocialAuthModel.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _accessToken = json['accessToken'];
    _refreshToken = json['refreshToken'];
    _expiresAt = json['expiresAt'];
    _provider = json['provider'];
    _isNewUser = json['isNewUser'];
    _email = json['email'];
    _nickname = json['nickname'];
    _profileImageUrl = json['profileImageUrl'];
    _maritalStatus = json['maritalStatus'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = _userId;
    data['accessToken'] = _accessToken;
    data['refreshToken'] = _refreshToken;
    data['expiresAt'] = _expiresAt;
    data['provider'] = _provider;
    data['isNewUser'] = _isNewUser;
    data['email'] = _email;
    data['nickname'] = _nickname;
    data['profileImageUrl'] = _profileImageUrl;
    data['maritalStatus'] = _maritalStatus;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }
}
