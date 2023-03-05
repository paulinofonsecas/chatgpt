import 'package:chatgpt/src/utils/constants.dart';

class ChatCompletionRequest {
  String? model;
  List<Message>? messages;

  ChatCompletionRequest({
    required this.messages,
    this.model = kGptTurbo,
  });

  ChatCompletionRequest.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? role;
  String? content;

  Message({this.role, this.content});

  Message.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = "$role";
    data['content'] = "$content";
    return data;
  }
}
