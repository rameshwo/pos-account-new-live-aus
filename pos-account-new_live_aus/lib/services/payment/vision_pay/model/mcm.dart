class MagneticCardMessage {
  String? completedUtcDateTime;
  String? createdUtcDateTime;
  String? externalReference;
  String? im30Reference;
  int? magneticState;
  String? trackData1;
  String? trackData2;
  String? trackData3;

  MagneticCardMessage({
    this.completedUtcDateTime,
    this.createdUtcDateTime,
    this.externalReference,
    this.im30Reference,
    this.magneticState,
    this.trackData1,
    this.trackData2,
    this.trackData3,
  });

  factory MagneticCardMessage.fromJson(Map<String, dynamic> json) =>
      MagneticCardMessage(
        completedUtcDateTime: json["completedUTCDateTime"],
        createdUtcDateTime: json["createdUTCDateTime"],
        externalReference: json["externalReference"],
        im30Reference: json["im30Reference"],
        magneticState: json["magneticState"],
        trackData1: json["trackData1"],
        trackData2: json["trackData2"],
        trackData3: json["trackData3"],
      );

  Map<String, dynamic> toJson() => {
        "completedUTCDateTime": completedUtcDateTime,
        "createdUTCDateTime": createdUtcDateTime,
        "externalReference": externalReference,
        "im30Reference": im30Reference,
        "magneticState": magneticState,
        "trackData1": trackData1,
        "trackData2": trackData2,
        "trackData3": trackData3,
      };
}
