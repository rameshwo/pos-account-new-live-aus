class NotifyModel {
  NotifyModel({
    this.navigation,
  });

  String? navigation;

  factory NotifyModel.fromJson(Map<String, dynamic> json) => NotifyModel(
        navigation: json["navigation"],
      );

  Map<String, dynamic> toJson() => {
        "navigation": navigation,
      };
}
