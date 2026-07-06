// import 'package:pos_account/model/common/message.dart';

// class AllUsers {
//   AllUsers({
//     this.data,
//     this.message,
//     this.total,
//     this.status,
//   });

//   List<AllUserData>? data;
//   List<Message>? message;
//   int? total;
//   int? status;

//   factory AllUsers.fromJson(Map<String, dynamic> json) => AllUsers(
//         data: json["data"] == null
//             ? null
//             : List<AllUserData>.from(
//                 json["data"].map((x) => AllUserData.fromJson(x))),
//         message: json["message"] == null
//             ? null
//             : List<Message>.from(
//                 json["message"].map((x) => Message.fromJson(x))),
//         total: json["total"],
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data == null
//             ? null
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//         "message":
//             message == null ? null : List<dynamic>.from(message!.map((x) => x)),
//         "total": total,
//         "status": status,
//       };
// }

// class AllUserData {
//   AllUserData({
//     this.fullName,
//     this.id,
//     this.userType,
//     this.phoneNumber,
//     this.email,
//     this.image,
//     this.total,
//   });

//   String? fullName;
//   String? id;
//   String? userType;
//   String? phoneNumber;
//   String? email;
//   String? image;
//   int? total;

//   factory AllUserData.fromJson(Map<String, dynamic> json) => AllUserData(
//         fullName: json["fullName"],
//         id: json["id"],
//         userType: json["userType"],
//         phoneNumber: json["phoneNumber"],
//         email: json["email"],
//         image: json["image"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "fullName": fullName,
//         "id": id,
//         "userType": userType,
//         "phoneNumber": phoneNumber,
//         "email": email,
//         "image": image,
//         "total": total,
//       };
// }
