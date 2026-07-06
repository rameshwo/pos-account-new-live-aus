class RefreshTokenModel {
  String? refreshToken;
  String? accessToken;
  bool? isRefreshTokenValid;

  RefreshTokenModel({
    this.refreshToken,
    this.accessToken,
    this.isRefreshTokenValid,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      RefreshTokenModel(
        refreshToken: json["refreshToken"],
        accessToken: json["accessToken"],
        isRefreshTokenValid: json["isRefreshTokenValid"],
      );

  Map<String, dynamic> toJson() => {
        "refreshToken": refreshToken,
        "accessToken": accessToken,
        "isRefreshTokenValid": isRefreshTokenValid,
      };
}
