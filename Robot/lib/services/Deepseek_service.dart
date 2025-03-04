import 'package:dart_openai/dart_openai.dart';

class DeepSeekService {
  Future getData(String content, Function(String text)? callBack, Function(
      )? complete) async {
    OpenAI.apiKey = 'sk-707fdca904814749b4f61dfb17a65c20';
    OpenAI.baseUrl = 'https://api.deepseek.com';
    OpenAI.showLogs = true;
    OpenAI.requestsTimeOut = Duration(seconds: 60);

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "You are a helpful assistant",
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          content,
        )
      ],
      role: OpenAIChatMessageRole.user,
    );

    final chatStream = await OpenAI.instance.chat.createStream(
        model: 'deepseek-chat', messages: [systemMessage, userMessage]);

    chatStream.listen((streamChatCompletion) {
      final content =
          streamChatCompletion.choices.first.delta.content?.first?.text;
      if (callBack != null && content != null) {
        callBack(content);
      }
    }, onDone: () {
      if (complete != null) {
        complete();
      }
    });
  }
}
