import 'package:pos_account/model/common/table_location.dart';

class ReportAddSec {
  ReportAddSec({
    this.paymentMethodStore,
    this.storeChannelId,
  });

  List<TableLocation>? paymentMethodStore;
  List<TableLocation>? storeChannelId;

  factory ReportAddSec.fromJson(Map<String, dynamic> json) => ReportAddSec(
        paymentMethodStore: json["paymentMethodStore"] == null
            ? null
            : List<TableLocation>.from(json["paymentMethodStore"]
                .map((x) => TableLocation.fromJson(x))),
        storeChannelId: json["storeChannelId"] == null
            ? null
            : List<TableLocation>.from(
                json["storeChannelId"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethodStore": paymentMethodStore == null
            ? null
            : List<dynamic>.from(paymentMethodStore!.map((x) => x.toJson())),
        "storeChannelId": storeChannelId == null
            ? null
            : List<dynamic>.from(storeChannelId!.map((x) => x.toJson())),
      };
}
