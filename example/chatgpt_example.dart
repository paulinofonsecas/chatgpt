import 'package:chatgpt/chatgpt.dart';
import 'package:chatgpt/src/model/chat_completation/request/chat_completation_request.dart';
import 'package:hive/hive.dart';

void main() async {
  var openai = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(receiveTimeout: 10000, connectTimeout: 10000),
    isLogger: true,
  );

  final request = ChatCompletionRequest(
    messages: [
      Message(
          role: 'system',
          content:
              'Você é um chatbot chamado Professor, que ajuda os alunos a'' resolverem problemas escolares de forma divertida em portugês.'),
      Message(
          role: 'user',
          content:
              'Olá professor, Me esplique em pequenas frases a segunda teoria de newton?'),
    ],
  );

  var stream =
      openai.onChatCompleteStream(request: request).asBroadcastStream();

  stream.listen((res) {
    print(res?.choices?.first.message);
  }, onDone: _onDone).onError((err) {
    print("$err");
  });
}

void _onDone() async {
  Hive.deleteFromDisk();
}
