import 'package:pos_account/model/common/table_location.dart';

class DeliTrackStatus {
  List<TableLocation>? deliveryTrackingStatus;

  DeliTrackStatus({
    this.deliveryTrackingStatus,
  });

  factory DeliTrackStatus.fromJson(Map<String, dynamic> json) =>
      DeliTrackStatus(
        deliveryTrackingStatus: json["deliveryTrackingStatus"] == null
            ? []
            : List<TableLocation>.from(json["deliveryTrackingStatus"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "deliveryTrackingStatus": deliveryTrackingStatus == null
            ? []
            : List<dynamic>.from(
                deliveryTrackingStatus!.map((x) => x.toJson())),
      };
}
