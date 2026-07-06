import 'package:pos_account/model/common/table_location.dart';

class SyncSecListRes {
  SyncSecListRes({
    this.channels,
  });

  List<TableLocation>? channels;

  factory SyncSecListRes.fromJson(Map<String, dynamic> json) => SyncSecListRes(
        channels: json["channels"] == null
            ? null
            : List<TableLocation>.from(
                json["channels"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channels": channels == null
            ? null
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
      };
}
