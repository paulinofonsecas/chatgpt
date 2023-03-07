# Dart ChatGPT API

This package requires a valid token from <a href="https://platform.openai.com/account/api-keys/">OpenAi Account</a> to access official REST API.

## Exemple

```dart
var openai = OpenAI.instance.build(
    token: '<your opanAI Token>',
    baseOption: HttpSetup(receiveTimeout: 10000, connectTimeout: 10000),
    isLogger: true,
  );

  final request = ChatCompletionRequest(
    messages: [
      Message(
          role: 'system',
          content: 'Você é um chatbot chamado Professor, que ajuda os alunos a'
              ' resolverem problemas escolares de forma divertida em portugês.'),
      Message(
          role: 'user',
          content:
              'Olá professor, Me esplique em pequenas frases a segunda teoria de newton?'),
    ],
  );

  var stream =
      openai.onChatCompleteStream(request: request).asBroadcastStream();

  stream.listen(
    (res) {
      print(res?.choices?.first.message);
    },
  ).onError((err) {
    print("$err");
  });
```

## Credit 
Huge thanks to <a href="https://pub.dev/publishers/justec.dev">justec.dev</a> for creating <a href="https://pub.dev/packages/flutter_chatgpt_api">Flutter ChatGPT API</a> 💪
