// class UberDeliAddress {
//   List<String?>? streetAddress;
//   String? city;
//   String? state;
//   String? zipCode;
//   String? country;

//   UberDeliAddress({
//     this.streetAddress,
//     this.city,
//     this.state,
//     this.zipCode,
//     this.country,
//   });

//   factory UberDeliAddress.fromJson(Map<String, dynamic> json) =>
//       UberDeliAddress(
//         streetAddress: json["street_address"] == null
//             ? []
//             : List<String>.from(json["street_address"]!.map((x) => x)),
//         city: json["city"],
//         state: json["state"],
//         zipCode: json["zip_code"],
//         country: json["country"],
//       );

//   Map<String, dynamic> toJson() => {
//         "street_address": streetAddress == null
//             ? []
//             : List<dynamic>.from(streetAddress!.map((x) => x)),
//         "city": city,
//         "state": state,
//         "zip_code": zipCode,
//         "country": country,
//       };
// }
