class Message {
  Message({
    this.title,
    this.message,
  });

  final String? title;
  final String? message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
      };
}
