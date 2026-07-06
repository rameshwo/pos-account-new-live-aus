class CountryCode {
  CountryCode({
    required this.code,
    required this.name,
  });

  String code;
  String name;

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}

List<CountryCode> get LANG_LIST =>
    _languageList.map((e) => CountryCode.fromJson(e)).toList();

var _languageList = [
  {"code": "en", "name": "English"},
  {"code": "zh-cn", "name": "Chinese (Simplified)"},
  {"code": "ko", "name": "Korean"},
  {"code": "ja", "name": "Japanese"},
  {"code": "es", "name": "Spanish; Castilian"},
];
