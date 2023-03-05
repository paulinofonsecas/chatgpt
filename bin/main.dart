import 'package:chatgpt/chatgpt.dart';

void main(List<String> args) async {
  var openai = OpenAI.instance;

  var aiModels = await openai.listModel();

  print(aiModels.data);
}
