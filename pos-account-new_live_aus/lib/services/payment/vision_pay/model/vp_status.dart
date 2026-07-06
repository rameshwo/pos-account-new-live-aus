// ignore: dangling_library_doc_comments
/// [VisionPayStatus]
/// 0: View Message
/// 10: Pay Awaiting Message
/// 11: Pay Card Read Success
/// 12: Pay Card Read Failed
/// 13: Pay Sending Online..
/// 14: Pay Sending Online Completed
/// 15: Pay Sending Online Failed
/// 16: Pay Pre-Authorization Complete
/// 161: Pay Transaction Approved
/// 16181: Pay Capture Completed Successfully
/// 169: Pay Transaction Declined
/// 98: Pay Cancelled
/// 99: Pay Timeout
/// 199: Pay Failed State
/// 999: Exception Message

class VisionPayStatus {
  int status;
  String message;

  VisionPayStatus({
    required this.status,
    required this.message,
  });

  // factory VisionPayStatus.fromJson(Map<String, dynamic> json) =>
  //     VisionPayStatus(
  //       status: json["status"],
  //       message: json["message"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "status": status,
  //       "message": message,
  //     };
}
