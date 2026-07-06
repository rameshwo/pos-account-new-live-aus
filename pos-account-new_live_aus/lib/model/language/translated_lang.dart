import 'dart:convert';

List<GetTranslatedLang> getTranslatedLangFromJson(String str) =>
    List<GetTranslatedLang>.from(
        json.decode(str).map((x) => GetTranslatedLang.fromJson(x)));

String getTranslatedLangToJson(List<GetTranslatedLang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTranslatedLang {
  GetTranslatedLang({
    this.language,
    this.code,
    this.languageTranslationList,
  });

  String? language;
  String? code;
  List<LanguageTranslationList>? languageTranslationList;

  factory GetTranslatedLang.fromJson(Map<String, dynamic> json) =>
      GetTranslatedLang(
        language: json["language"],
        code: json["code"],
        languageTranslationList: json["languageTranslationList"] == null
            ? null
            : List<LanguageTranslationList>.from(json["languageTranslationList"]
                .map((x) => LanguageTranslationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "code": code,
        "languageTranslationList": languageTranslationList == null
            ? null
            : List<dynamic>.from(
                languageTranslationList!.map((x) => x.toJson())),
      };
}

class LanguageTranslationList {
  LanguageTranslationList({
    this.field,
    this.english,
    this.translated,
  });

  String? field;
  String? english;
  String? translated;

  factory LanguageTranslationList.fromJson(Map<String, dynamic> json) =>
      LanguageTranslationList(
        field: json["field"],
        english: json["english"],
        translated: json["translated"],
      );

  Map<String, dynamic> toJson() => {
        "field": field,
        "english": english,
        "translated": translated,
      };
}
