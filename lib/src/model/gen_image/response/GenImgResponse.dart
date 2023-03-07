// ignore_for_file: file_names

import 'package:dart_chatgpt/src/model/gen_image/response/image_data.dart';

class GenImgResponse {
  GenImgResponse({
    this.created,
    this.data,
  });

  int? created;
  List<ImageData?>? data;

  factory GenImgResponse.fromJson(Map<String, dynamic> json) => GenImgResponse(
        created: json["created"],
        data: json["data"] == null
            ? []
            : List<ImageData?>.from(
                json["data"]!.map((x) => ImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "created": created,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}
