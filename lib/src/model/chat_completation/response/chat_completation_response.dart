
class ChatCompletationResponse {
    String? id;
    String? object;
    int? created;
    String? model;
    Usage? usage;
    List<Choices>? choices;

    ChatCompletationResponse({this.id, this.object, this.created, this.model, this.usage, this.choices});

    ChatCompletationResponse.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        object = json["object"];
        created = json["created"];
        model = json["model"];
        usage = json["usage"] == null ? null : Usage.fromJson(json["usage"]);
        choices = json["choices"] == null ? null : (json["choices"] as List).map((e) => Choices.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["id"] = id;
        data["object"] = object;
        data["created"] = created;
        data["model"] = model;
        if(usage != null) {
            data["usage"] = usage?.toJson();
        }
        if(choices != null) {
            data["choices"] = choices?.map((e) => e.toJson()).toList();
        }
        return data;
    }
}

class Choices {
    Message? message;
    String? finishReason;
    int? index;

    Choices({this.message, this.finishReason, this.index});

    Choices.fromJson(Map<String, dynamic> json) {
        message = json["message"] == null ? null : Message.fromJson(json["message"]);
        finishReason = json["finish_reason"];
        index = json["index"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        if(message != null) {
            data["message"] = message?.toJson();
        }
        data["finish_reason"] = finishReason;
        data["index"] = index;
        return data;
    }
}

class Message {
    String? role;
    String? content;

    Message({this.role, this.content});

    Message.fromJson(Map<String, dynamic> json) {
        role = json["role"];
        content = json["content"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["role"] = role;
        data["content"] = content;
        return data;
    }
}

class Usage {
    int? promptTokens;
    int? completionTokens;
    int? totalTokens;

    Usage({this.promptTokens, this.completionTokens, this.totalTokens});

    Usage.fromJson(Map<String, dynamic> json) {
        promptTokens = json["prompt_tokens"];
        completionTokens = json["completion_tokens"];
        totalTokens = json["total_tokens"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["prompt_tokens"] = promptTokens;
        data["completion_tokens"] = completionTokens;
        data["total_tokens"] = totalTokens;
        return data;
    }
}