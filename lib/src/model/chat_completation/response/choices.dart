import 'message.dart';

class Choices {
  Message? message;
  String? finishReason;
  int? index;

  Choices({this.message, this.finishReason, this.index});

  Choices.fromJson(Map<String, dynamic> json) {
    message =
        json["message"] == null ? null : Message.fromJson(json["message"]);
    finishReason = json["finish_reason"];
    index = json["index"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data["message"] = message?.toJson();
    }
    data["finish_reason"] = finishReason;
    data["index"] = index;
    return data;
  }
}
