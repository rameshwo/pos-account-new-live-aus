class DbLoginReq {
  String? email;
  String? password;

  DbLoginReq({
    this.email,
    this.password,
  });

  factory DbLoginReq.fromJson(Map<String, dynamic> json) => DbLoginReq(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
