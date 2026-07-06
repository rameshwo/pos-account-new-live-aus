class DataSyncEvent {
  String? posDeviceId;
  List<int>? dataTypeList;

  DataSyncEvent({
    this.posDeviceId,
    this.dataTypeList,
  });

  factory DataSyncEvent.fromJson(Map<String, dynamic> json) => DataSyncEvent(
        posDeviceId: json["posDeviceId"],
        dataTypeList: json["dataTypeList"] == null
            ? []
            : List<int>.from(json["dataTypeList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "posDeviceId": posDeviceId,
        "dataTypeList": dataTypeList == null
            ? []
            : List<dynamic>.from(dataTypeList!.map((x) => x)),
      };
}
