class HeartbeatRes {
  String? deviceId;
  int? timestamp;
  int? serverTime;

  HeartbeatRes({
    this.deviceId,
    this.timestamp,
    this.serverTime,
  });

  factory HeartbeatRes.fromJson(Map<String, dynamic> json) => HeartbeatRes(
        deviceId: json["deviceId"],
        timestamp: json["timestamp"],
        serverTime: json["serverTime"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "timestamp": timestamp,
        "serverTime": serverTime,
      };
}
