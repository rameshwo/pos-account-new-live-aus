class UploadImageS3Res {
  String? uploadUrl;
  String? fileName;
  String? identifier;
  int? compressionRatio;
  String? fileExtension;
  String? contentType;
  String? filePath;

  UploadImageS3Res({
    this.uploadUrl,
    this.fileName,
    this.identifier,
    this.compressionRatio,
    this.fileExtension,
    this.contentType,
    this.filePath,
  });

  factory UploadImageS3Res.fromJson(Map<String, dynamic> json) =>
      UploadImageS3Res(
        uploadUrl: json["uploadUrl"],
        fileName: json["fileName"],
        identifier: json["identifier"],
        compressionRatio: json["compressionRatio"],
        fileExtension: json["fileExtension"],
        contentType: json["contentType"],
      );

  Map<String, dynamic> toJson() => {
        "uploadUrl": uploadUrl,
        "fileName": fileName,
        "identifier": identifier,
        "compressionRatio": compressionRatio,
        "fileExtension": fileExtension,
        "contentType": contentType,
      };
}
