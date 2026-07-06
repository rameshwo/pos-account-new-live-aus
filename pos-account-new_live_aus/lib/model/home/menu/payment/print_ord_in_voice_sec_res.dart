// import 'package:pos_account/model/common/table_location.dart';

// class PrintOrderInVSecListRes {
//   PrintOrderInVSecListRes({
//     this.id,
//     this.departMentName,
//     this.departmentWithPrinters,
//   });

//   String? id;
//   String? departMentName;
//   List<TableLocation>? departmentWithPrinters;

//   factory PrintOrderInVSecListRes.fromJson(Map<String, dynamic> json) =>
//       PrintOrderInVSecListRes(
//         id: json["id"],
//         departMentName: json["departMentName"],
//         departmentWithPrinters: json["departmentWithPrinters"] == null
//             ? null
//             : List<TableLocation>.from(json["departmentWithPrinters"]
//                 .map((x) => TableLocation.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "departMentName": departMentName,
//         "departmentWithPrinters": departmentWithPrinters == null
//             ? null
//             : List<dynamic>.from(
//                 departmentWithPrinters!.map((x) => x.toJson())),
//       };
// }
