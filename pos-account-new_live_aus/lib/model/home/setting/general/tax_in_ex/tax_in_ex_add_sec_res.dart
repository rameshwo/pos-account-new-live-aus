// import 'package:pos_account/model/common/table_location.dart';

// class TaxInExAddSecRes {
//   TaxInExAddSecRes({
//     this.taxType,
//   });

//   List<TableLocation>? taxType;

//   factory TaxInExAddSecRes.fromJson(Map<String, dynamic> json) =>
//       TaxInExAddSecRes(
//         taxType: json["taxType"] == null
//             ? null
//             : List<TableLocation>.from(
//                 json["taxType"].map((x) => TableLocation.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "taxType": taxType == null
//             ? null
//             : List<dynamic>.from(taxType!.map((x) => x.toJson())),
//       };
// }
