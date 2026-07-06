final ScreenTimeOut = <ScreenTimeModel>[
  ScreenTimeModel(title: '10 second(s)', duration: 10, enable: true),
  ScreenTimeModel(title: '30 second(s)', duration: 30, enable: true),
  ScreenTimeModel(title: '1 minute(s)', duration: 60, enable: true),
  ScreenTimeModel(title: '2 minute(s)', duration: 60 * 2, enable: true),
  ScreenTimeModel(title: '5 minute(s)', duration: 60 * 5, enable: true),
  ScreenTimeModel(title: '10 minute(s)', duration: 60 * 10, enable: true),
  ScreenTimeModel(title: '30 minute(s)', duration: 60 * 30, enable: true),
  ScreenTimeModel(title: 'Never', duration: 0, enable: false),
];

class ScreenTimeModel {
  final String title;
  final int duration;
  final bool enable;
  // bool isAppLockEnable;

  ScreenTimeModel({
    required this.title,
    this.enable = true,
    required this.duration,
    // this.isAppLockEnable = false,
  });

  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) =>
      ScreenTimeModel(
        duration: json["duration"],
        title: json["title"],
        enable: json["enable"],
        // isAppLockEnable: json["isAppLockEnable"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "title": title,
        "enable": enable,
        // "isAppLockEnable": isAppLockEnable,
      };
}
