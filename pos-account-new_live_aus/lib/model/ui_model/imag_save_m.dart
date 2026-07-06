class ImageSaveModel {
  ImageSaveModel({
    required this.isSuccess,
    required this.filePath,
  });

  bool isSuccess;
  String filePath;

  factory ImageSaveModel.fromJson(Map<String, dynamic> json) => ImageSaveModel(
        isSuccess: json["isSuccess"],
        filePath: json["filePath"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "filePath": filePath,
      };
}
