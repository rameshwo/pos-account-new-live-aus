class SyncNotiData {
  final String? actiontype;
  final String? navigation;
  // final String? datatype;
  final String? sound;
  final String? storeid;
  String? payload;

  SyncNotiData({
    this.actiontype,
    this.navigation,
    // this.datatype,
    this.sound,
    this.storeid,
    this.payload,
  });

  factory SyncNotiData.fromJson(Map<String, dynamic> json) => SyncNotiData(
        actiontype: json["actiontype"],
        navigation: json["navigation"],
        // datatype: json["datatype"],
        sound: json["sound"],
        storeid: json["storeid"],
        payload: json["payload"],
      );

  Map<String, dynamic> toJson() => {
        "actiontype": actiontype,
        "navigation": navigation,
        // "datatype": datatype,
        "sound": sound,
        "storeid": storeid,
        "payload": payload,
      };
}
