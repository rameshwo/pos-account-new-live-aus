import 'package:pos_account/model/common/table_location.dart';

class CompDisRes {
  List<TableLocation>? discounts;

  CompDisRes({
    this.discounts,
  });

  factory CompDisRes.fromJson(Map<String, dynamic> json) => CompDisRes(
        discounts: json["discounts"] == null
            ? []
            : List<TableLocation>.from(
                json["discounts"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "discounts": discounts == null
            ? []
            : List<dynamic>.from(discounts!.map((x) => x.toJson())),
      };
}
