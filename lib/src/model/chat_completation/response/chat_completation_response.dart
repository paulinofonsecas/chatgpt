import 'package:dart_chatgpt/src/model/usage.dart';

import 'choices.dart';

class CCResponse {
  String? id;
  String? object;
  int? created;
  String? model;
  Usage? usage;
  List<Choices>? choices;

  CCResponse(
      {this.id,
      this.object,
      this.created,
      this.model,
      this.usage,
      this.choices});

  CCResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    object = json["object"];
    created = json["created"];
    model = json["model"];
    usage = json["usage"] == null ? null : Usage.fromJson(json["usage"]);
    choices = json["choices"] == null
        ? null
        : (json["choices"] as List).map((e) => Choices.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["object"] = object;
    data["created"] = created;
    data["model"] = model;
    if (usage != null) {
      data["usage"] = usage?.toJson();
    }
    if (choices != null) {
      data["choices"] = choices?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
