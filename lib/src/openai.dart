import 'dart:async';
import 'dart:io';

import 'package:chatgpt/src/client/client.dart';
import 'package:chatgpt/src/model/chat_completation/request/chat_completation_request.dart';
import 'package:chatgpt/src/model/chat_completation/response/chat_completation_response.dart';
import 'package:chatgpt/src/model/client/http_setup.dart';
import 'package:chatgpt/src/model/complete_text/request/complete_text.dart';
import 'package:chatgpt/src/model/complete_text/response/complete_response.dart';
import 'package:chatgpt/src/model/gen_image/request/generate_image.dart';
import 'package:chatgpt/src/model/gen_image/response/GenImgResponse.dart';
import 'package:chatgpt/src/model/openai_engine/engine_model.dart';
import 'package:chatgpt/src/model/openai_model/openai_models.dart';
import 'package:chatgpt/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'client/exception/openai_exception.dart';
import 'client/interceptor/interceptor_wrapper.dart';

class OpenAI {
  OpenAI._();

  ///instance of openai [instance]
  static OpenAI instance = OpenAI._();

  late OpenAIClient _client;

  /// openai token
  /// use for access for chat gpt [_token]
  static String? _token;

  static Box<String>? _box;
  static final dirPath = '${path.current}\\.data';

  ///new instance prefs for keep my data
  void _buildShared() async {
    Hive.init(dirPath);
    _box = await Hive.openBox('token_ai');
  }

  /// set new token
  void setToken(String token) async {
    _token = token;
    await _box?.put(kTokenKey, token);
  }

  String getToken() => "$_token";

  ///build environment for openai [build]
  ///setup http client
  ///setup logger
  OpenAI build({String? token, HttpSetup? baseOption, bool isLogger = false}) {
    _buildShared();

    if ("$token".isEmpty) throw MissionTokenException();
    final setup = baseOption ?? HttpSetup();

    final dio = Dio(BaseOptions(
        sendTimeout: setup.sendTimeout,
        connectTimeout: setup.connectTimeout,
        receiveTimeout: setup.receiveTimeout));

    dio.interceptors.add(InterceptorWrapper(_box, token!));

    _client = OpenAIClient(dio: dio, isLogging: isLogger);
    setToken(token);

    return instance;
  }

  ///find all list model ai [listModel]
  Future<AiModel> listModel() async {
    return _client.get<AiModel>(
      "$kURL$kModelList",
      onSuccess: (it) {
        return AiModel.fromJson(it);
      },
    );
  }

  /// find all list engine ai [listEngine]
  Future<EngineModel> listEngine() async {
    return _client.get<EngineModel>("$kURL$kEngineList", onSuccess: (it) {
      return EngineModel.fromJson(it);
    });
  }

  ///### About Method [onCompleteText]
  /// - Answer questions based on existing knowledge.
  /// - Create code to call the Stripe API using natural language.
  /// - Classify items into categories via example.
  /// - look more
  /// https://beta.openai.com/examples
  Future<CTResponse?> onCompleteText({required CompleteText request}) async {
    return _client.post("$kURL$kCompletion", request.toJson(), onSuccess: (it) {
      return CTResponse.fromJson(it);
    });
  }

  ///### About Method [onCompleteText]
  /// - Answer questions based on existing knowledge.
  /// - Create code to call the Stripe API using natural language.
  /// - Classify items into categories via example.
  /// - look more
  /// https://beta.openai.com/examples
  Stream<CTResponse?> onCompleteStream({required CompleteText request}) {
    _completeText(request: request);
    return _completeControl.stream;
  }

  Stream<ChatCompletationResponse?> onChatCompleteStream(
      {required ChatCompletionRequest request}) {
    _chatCompleteText(request: request);
    return _chatCompleteControl.stream;
  }

  final _completeControl = StreamController<CTResponse>.broadcast();
  void _completeText({required CompleteText request}) {
    _client.postStream("$kURL$kCompletion", request.toJson()).listen((rawData) {
      if (rawData.statusCode != HttpStatus.ok) {
        _client.log.errorLog(code: rawData.statusCode, error: rawData.data);
        _completeControl
          ..sink
          ..addError(
              "complete error: ${rawData.statusMessage} code: ${rawData.statusCode} data: ${rawData.data}");
      } else {
        _client.log.debugString(
            "============= success ==================\nresponse body :${rawData.data}");
        _completeControl
          ..sink
          ..add(CTResponse.fromJson(rawData.data));
      }
    }).onError((err) {
      if (err is DioError) {
        _completeControl
          ..sink
          ..addError(
              "complete error: status code :${err.error}\n error body :${err.response?.data}");
      }
    });
  }

  final _chatCompleteControl =
      StreamController<ChatCompletationResponse>.broadcast();
  void _chatCompleteText({required ChatCompletionRequest request}) {
    _client
        .postStream("$kURL$kChatCompletion", request.toJson())
        .listen((rawData) {
      if (rawData.statusCode != HttpStatus.ok) {
        _client.log.errorLog(code: rawData.statusCode, error: rawData.data);
        _chatCompleteControl
          ..sink
          ..addError(
              "complete error: ${rawData.statusMessage} code: ${rawData.statusCode} data: ${rawData.data}");
      } else {
        _client.log.debugString(
            "============= success ==================\nresponse body :${rawData.data}");
        _chatCompleteControl
          ..sink
          ..add(ChatCompletationResponse.fromJson(rawData.data));
      }
    }).onError((err) {
      if (err is DioError) {
        _chatCompleteControl
          ..sink
          ..addError(
              "complete error: status code :${err.error}\n error body :${err.response?.data}");
      }
    });
  }

  ///### close complete stream
  ///free memory [close]
  void close() {
    _completeControl.close();
  }

  ///generate image with prompt [generateImageStream]
  Stream<GenImgResponse> generateImageStream(GenerateImage request) {
    _generateImage(request);
    return _genImgController.stream;
  }

  final _genImgController = StreamController<GenImgResponse>.broadcast();
  void _generateImage(GenerateImage request) {
    _client
        .postStream("$kURL$kGenerateImage", request.toJson())
        .listen((rawData) {
      if (rawData.statusCode != HttpStatus.ok) {
        _client.log.errorLog(code: rawData.statusCode, error: rawData.data);
        _genImgController
          ..sink
          ..addError(
              "generate image error: ${rawData.statusMessage} code: ${rawData.statusCode} data: ${rawData.data}");
      } else {
        _client.log.debugString(
            "============= success ==================\nresponse body :${rawData.data}");
        _genImgController
          ..sink
          ..add(GenImgResponse.fromJson(rawData.data));
      }
    }).onError((err) => {
              if (err is DioError)
                {
                  _genImgController
                    ..sink
                    ..addError(
                        "generate image error: status code :${err.error}\nerror body :${err.response?.data}")
                }
            });
  }

  /// close generate image stream[genImgClose]
  /// free memory
  void genImgClose() {
    _genImgController.close();
  }

  ///generate image with prompt
  Future<GenImgResponse?> generateImage(GenerateImage request) async {
    return _client.post("$kURL$kGenerateImage", request.toJson(),
        onSuccess: (it) {
      return GenImgResponse.fromJson(it);
    });
  }
}