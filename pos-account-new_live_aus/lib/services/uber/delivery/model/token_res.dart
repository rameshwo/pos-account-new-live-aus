class UberDeliTokenRes {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? scope;

  UberDeliTokenRes({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.scope,
  });

  factory UberDeliTokenRes.fromJson(Map<String, dynamic> json) =>
      UberDeliTokenRes(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        scope: json["scope"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "scope": scope,
      };
}

class UberDeliTokenResError {
  String? error;
  String? errorDescription;

  UberDeliTokenResError({
    this.error,
    this.errorDescription,
  });

  factory UberDeliTokenResError.fromJson(Map<String, dynamic> json) =>
      UberDeliTokenResError(
        error: json["error"],
        errorDescription: json["error_description"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "error_description": errorDescription,
      };
}
