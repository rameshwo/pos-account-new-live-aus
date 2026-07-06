class LoginRes {
  LoginRes({
    this.isSuperAdmin,
    this.token,
    this.refreshToken,
    this.idToken,
    this.userId,
    this.employeeId,
    this.name,
    this.phoneNumber,
    this.email,
    this.image,
    this.qrImage,
    this.is2FaEnabled,
    this.isLockedOut,
    this.twoFaQrImage,
    this.isEmailConfirmed,
    this.googleImage,
    this.message,
    // this.storeDetailsLoginResponseViewModels,
  });

  bool? isSuperAdmin;
  String? token;
  String? refreshToken;
  String? idToken;
  String? userId;
  String? employeeId;
  String? name;
  String? phoneNumber;
  String? email;
  String? image;
  String? qrImage;
  bool? is2FaEnabled;
  bool? isLockedOut;
  String? twoFaQrImage;
  bool? isEmailConfirmed;
  String? googleImage;
  String? message;
  // List<StoreDetailsLoginResponseViewModel>? storeDetailsLoginResponseViewModels;

  factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        isSuperAdmin: json["isSuperAdmin"],
        token: json["token"],
        refreshToken: json["refreshToken"],
        idToken: json["idToken"],
        userId: json["userId"],
        employeeId: json["employeeId"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        image: json["image"],
        qrImage: json["qrImage"],
        is2FaEnabled: json["is2FaEnabled"],
        isLockedOut: json["isLockedOut"],
        twoFaQrImage: json["twoFaQRImage"],
        isEmailConfirmed: json["isEmailConfirmed"],
        googleImage: json["googleImage"],
        message: json["message"],
        // storeDetailsLoginResponseViewModels:
        //     json["storeDetailsLoginResponseViewModels"] == null
        //         ? null
        //         : List<StoreDetailsLoginResponseViewModel>.from(
        //             json["storeDetailsLoginResponseViewModels"].map(
        //                 (x) => StoreDetailsLoginResponseViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuperAdmin": isSuperAdmin,
        "token": token,
        "refreshToken": refreshToken,
        "idToken": idToken,
        "userId": userId,
        "employeeId": employeeId,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "image": image,
        "qrImage": qrImage,
        "is2FaEnabled": is2FaEnabled,
        "isLockedOut": isLockedOut,
        "twoFaQRImage": twoFaQrImage,
        "isEmailConfirmed": isEmailConfirmed,
        "googleImage": googleImage,
        "message": message,
        // "storeDetailsLoginResponseViewModels":
        //     storeDetailsLoginResponseViewModels == null
        //         ? null
        //         : List<dynamic>.from(storeDetailsLoginResponseViewModels!
        //             .map((x) => x.toJson())),
      };
}
