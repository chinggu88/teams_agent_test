import 'yuram_coordinate_model.dart';

/// 종합 리포트 데이터 모델.
///
/// 회원가입 후 생성되는 종합 리포트 정보를 표현한다.
/// 유람 좌표 결과와 더불어 운세 / 성향 / 추천 키워드 등을 포함한다.
class ReportModel {
  /// 리포트 ID
  String? _id;

  /// 사용자 ID
  String? _userId;

  /// 리포트 제목
  String? _title;

  /// 리포트 요약 (한 단락)
  String? _summary;

  /// 유람 좌표 결과 (중첩 객체)
  YuramCoordinateModel? _yuramCoordinate;

  /// 리포트 섹션 목록
  ///
  /// 각 섹션은 `{ "heading": String, "body": String }` 형태이다.
  List<ReportSectionModel>? _sections;

  /// 추천 키워드 목록
  List<String>? _recommendKeywords;

  /// 생성일시
  String? _createdAt;

  /// 수정일시
  String? _updatedAt;

  // 생성자
  ReportModel({
    String? id,
    String? userId,
    String? title,
    String? summary,
    YuramCoordinateModel? yuramCoordinate,
    List<ReportSectionModel>? sections,
    List<String>? recommendKeywords,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _title = title;
    _summary = summary;
    _yuramCoordinate = yuramCoordinate;
    _sections = sections;
    _recommendKeywords = recommendKeywords;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  // Getter / Setter
  String? get id => _id;
  set id(String? id) => _id = id;

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;

  String? get title => _title;
  set title(String? title) => _title = title;

  String? get summary => _summary;
  set summary(String? summary) => _summary = summary;

  YuramCoordinateModel? get yuramCoordinate => _yuramCoordinate;
  set yuramCoordinate(YuramCoordinateModel? yuramCoordinate) =>
      _yuramCoordinate = yuramCoordinate;

  List<ReportSectionModel>? get sections => _sections;
  set sections(List<ReportSectionModel>? sections) => _sections = sections;

  List<String>? get recommendKeywords => _recommendKeywords;
  set recommendKeywords(List<String>? recommendKeywords) =>
      _recommendKeywords = recommendKeywords;

  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;

  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  /// JSON 역직렬화
  ReportModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['userId'];
    _title = json['title'];
    _summary = json['summary'];
    _yuramCoordinate = json['yuramCoordinate'] != null
        ? YuramCoordinateModel.fromJson(json['yuramCoordinate'])
        : null;
    _sections = json['sections'] != null
        ? (json['sections'] as List)
            .map((item) => ReportSectionModel.fromJson(item))
            .toList()
        : null;
    _recommendKeywords = json['recommendKeywords'] != null
        ? List<String>.from(json['recommendKeywords'])
        : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['userId'] = _userId;
    data['title'] = _title;
    data['summary'] = _summary;
    data['yuramCoordinate'] = _yuramCoordinate?.toJson();
    data['sections'] = _sections?.map((item) => item.toJson()).toList();
    data['recommendKeywords'] = _recommendKeywords;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }
}

/// 종합 리포트의 단일 섹션 모델.
///
/// 종합 리포트는 여러 개의 섹션(예: '성향', '관계 운', '재물 운')으로 구성된다.
class ReportSectionModel {
  /// 섹션 제목
  String? _heading;

  /// 섹션 본문
  String? _body;

  /// 섹션 아이콘 키 (선택, 클라이언트에서 매핑)
  String? _iconKey;

  // 생성자
  ReportSectionModel({String? heading, String? body, String? iconKey}) {
    _heading = heading;
    _body = body;
    _iconKey = iconKey;
  }

  // Getter / Setter
  String? get heading => _heading;
  set heading(String? heading) => _heading = heading;

  String? get body => _body;
  set body(String? body) => _body = body;

  String? get iconKey => _iconKey;
  set iconKey(String? iconKey) => _iconKey = iconKey;

  /// JSON 역직렬화
  ReportSectionModel.fromJson(Map<String, dynamic> json) {
    _heading = json['heading'];
    _body = json['body'];
    _iconKey = json['iconKey'];
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['heading'] = _heading;
    data['body'] = _body;
    data['iconKey'] = _iconKey;
    return data;
  }
}
