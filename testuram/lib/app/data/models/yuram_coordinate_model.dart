/// 유람 좌표 분류 결과 모델.
///
/// 사용자의 출생 정보를 기반으로 분석된 "유람 좌표" 결과를 표현한다.
/// 좌표 결과는 카테고리(예: 별자리 기반 분류)와 그에 따른 메시지를 포함한다.
class YuramCoordinateModel {
  /// 좌표 결과 ID
  String? _id;

  /// 사용자 ID
  String? _userId;

  /// 좌표 코드 (예: 'A1', 'B3')
  String? _code;

  /// 좌표 이름 (예: '북극성형')
  String? _name;

  /// 한 줄 요약
  String? _summary;

  /// 상세 설명
  String? _description;

  /// 키워드 목록 (예: ['직관', '리더십', '도전'])
  List<String>? _keywords;

  /// 대표 이미지 URL
  String? _imageUrl;

  /// 분석된 시각
  String? _analyzedAt;

  // 생성자
  YuramCoordinateModel({
    String? id,
    String? userId,
    String? code,
    String? name,
    String? summary,
    String? description,
    List<String>? keywords,
    String? imageUrl,
    String? analyzedAt,
  }) {
    _id = id;
    _userId = userId;
    _code = code;
    _name = name;
    _summary = summary;
    _description = description;
    _keywords = keywords;
    _imageUrl = imageUrl;
    _analyzedAt = analyzedAt;
  }

  // Getter / Setter
  String? get id => _id;
  set id(String? id) => _id = id;

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;

  String? get code => _code;
  set code(String? code) => _code = code;

  String? get name => _name;
  set name(String? name) => _name = name;

  String? get summary => _summary;
  set summary(String? summary) => _summary = summary;

  String? get description => _description;
  set description(String? description) => _description = description;

  List<String>? get keywords => _keywords;
  set keywords(List<String>? keywords) => _keywords = keywords;

  String? get imageUrl => _imageUrl;
  set imageUrl(String? imageUrl) => _imageUrl = imageUrl;

  String? get analyzedAt => _analyzedAt;
  set analyzedAt(String? analyzedAt) => _analyzedAt = analyzedAt;

  /// JSON 역직렬화
  YuramCoordinateModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['userId'];
    _code = json['code'];
    _name = json['name'];
    _summary = json['summary'];
    _description = json['description'];
    _keywords = json['keywords'] != null
        ? List<String>.from(json['keywords'])
        : null;
    _imageUrl = json['imageUrl'];
    _analyzedAt = json['analyzedAt'];
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['userId'] = _userId;
    data['code'] = _code;
    data['name'] = _name;
    data['summary'] = _summary;
    data['description'] = _description;
    data['keywords'] = _keywords;
    data['imageUrl'] = _imageUrl;
    data['analyzedAt'] = _analyzedAt;
    return data;
  }
}
