// class PayInvoiceDetailRes {
//   PayInvoiceDetailRes({
//     this.orderId,
//     this.orderNumber,
//     this.taxAmount,
//     this.tipAmount,
//     this.discount,
//     this.totalAmount,
//     this.address,
//     this.dateTime,
//     this.tableNo,
//     this.abnNumber,
//     this.cashier,
//     this.orderBy,
//     this.productName,
//     this.holidaySurcharge,
//     this.creditCardSurcharge,
//     this.storeEmail,
//     this.storePhoneNumber,
//     this.storeName,
//     this.fromEmail,
//     this.tosEmail,
//     this.productWithPriceViewModels,
//   });

//   String? orderId;
//   String? orderNumber;
//   String? taxAmount;
//   String? tipAmount;
//   String? discount;
//   String? totalAmount;
//   String? address;
//   String? dateTime;
//   String? tableNo;
//   String? abnNumber;
//   String? cashier;
//   String? orderBy;
//   String? productName;
//   String? holidaySurcharge;
//   String? creditCardSurcharge;
//   String? storeEmail;
//   String? storePhoneNumber;
//   String? storeName;
//   FromEmail? fromEmail;
//   List<TosEmail>? tosEmail;
//   List<ProductWithPriceViewModel>? productWithPriceViewModels;

//   factory PayInvoiceDetailRes.fromJson(Map<String, dynamic> json) =>
//       PayInvoiceDetailRes(
//         orderId: json["orderId"],
//         orderNumber: json["orderNumber"],
//         taxAmount: json["taxAmount"],
//         tipAmount: json["tipAmount"],
//         discount: json["discount"],
//         totalAmount: json["totalAmount"],
//         address: json["address"],
//         dateTime: json["dateTime"],
//         tableNo: json["tableNo"],
//         abnNumber: json["abnNumber"],
//         cashier: json["cashier"],
//         orderBy: json["orderBy"],
//         productName: json["productName"],
//         holidaySurcharge: json["holidaySurcharge"],
//         creditCardSurcharge: json["creditCardSurcharge"],
//         storeEmail: json["storeEmail"],
//         storePhoneNumber: json["storePhoneNumber"],
//         storeName: json["storeName"],
//         fromEmail: json["fromEmail"] == null
//             ? null
//             : FromEmail.fromJson(json["fromEmail"]),
//         tosEmail: json["tosEmail"] == null
//             ? null
//             : List<TosEmail>.from(
//                 json["tosEmail"].map((x) => TosEmail.fromJson(x))),
//         productWithPriceViewModels: json["productWithPriceViewModels"] == null
//             ? null
//             : List<ProductWithPriceViewModel>.from(
//                 json["productWithPriceViewModels"]
//                     .map((x) => ProductWithPriceViewModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "orderId": orderId,
//         "orderNumber": orderNumber,
//         "taxAmount": taxAmount,
//         "tipAmount": tipAmount,
//         "discount": discount,
//         "totalAmount": totalAmount,
//         "address": address,
//         "dateTime": dateTime,
//         "tableNo": tableNo,
//         "abnNumber": abnNumber,
//         "cashier": cashier,
//         "orderBy": orderBy,
//         "productName": productName,
//         "holidaySurcharge": holidaySurcharge,
//         "creditCardSurcharge": creditCardSurcharge,
//         "storeEmail": storeEmail,
//         "storePhoneNumber": storePhoneNumber,
//         "storeName": storeName,
//         "fromEmail": fromEmail?.toJson(),
//         "tosEmail": tosEmail == null
//             ? null
//             : List<dynamic>.from(tosEmail!.map((x) => x.toJson())),
//         "productWithPriceViewModels": productWithPriceViewModels == null
//             ? null
//             : List<dynamic>.from(
//                 productWithPriceViewModels!.map((x) => x.toJson())),
//       };
// }

// class ProductWithPriceViewModel {
//   ProductWithPriceViewModel({
//     this.name,
//     this.quantity,
//     this.total,
//   });

//   String? name;
//   String? quantity;
//   String? total;

//   factory ProductWithPriceViewModel.fromJson(Map<String, dynamic> json) =>
//       ProductWithPriceViewModel(
//         name: json["name"],
//         quantity: json["quantity"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "quantity": quantity,
//         "total": total,
//       };
// }

// class FromEmail {
//   FromEmail({
//     this.senderName,
//     this.email,
//   });

//   String? senderName;
//   String? email;

//   factory FromEmail.fromJson(Map<String, dynamic> json) => FromEmail(
//         senderName: json["senderName"],
//         email: json["email"],
//       );

//   Map<String, dynamic> toJson() => {
//         "senderName": senderName,
//         "email": email,
//       };
// }

// class TosEmail {
//   TosEmail({
//     this.id,
//     this.email,
//   });

//   String? id;
//   String? email;

//   factory TosEmail.fromJson(Map<String, dynamic> json) => TosEmail(
//         id: json["id"],
//         email: json["email"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "email": email,
//       };
// }
