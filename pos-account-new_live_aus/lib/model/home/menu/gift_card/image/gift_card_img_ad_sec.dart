import 'package:pos_account/model/common/table_location.dart';

class GiftCardImageAddSec {
  String? code;
  List<TableLocation>? giftCardTemplates;

  GiftCardImageAddSec({
    this.code,
    this.giftCardTemplates,
  });

  GiftCardImageAddSec copyWith({
    String? code,
    List<TableLocation>? giftCardTemplates,
  }) =>
      GiftCardImageAddSec(
        code: code ?? this.code,
        giftCardTemplates: giftCardTemplates ?? this.giftCardTemplates,
      );

  factory GiftCardImageAddSec.fromJson(Map<String, dynamic> json) =>
      GiftCardImageAddSec(
        code: json["code"],
        giftCardTemplates: json["giftCardTemplateGroups"] == null
            ? []
            : List<TableLocation>.from(json["giftCardTemplateGroups"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "giftCardTemplateGroups": giftCardTemplates == null
            ? []
            : List<dynamic>.from(giftCardTemplates!.map((x) => x.toJson())),
      };
}
