import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:robot/common/Config.dart';
import 'package:robot/models/Message.dart';
import 'package:robot/models/Session.dart';
import 'package:robot/pages/MainScreen.dart';
import 'package:robot/states/ChatUiState.dart';
import 'package:robot/states/InputState.dart';
import 'package:robot/states/MessagesState.dart';
import 'package:robot/states/SessionState.dart';

class UserInputWidget extends HookConsumerWidget {
  const UserInputWidget({super.key});

  // 发送对话内容
  void _sendMessage(WidgetRef ref, TextEditingController editController) async {
    // 构建消息
    final message = Message(
        content: editController.text,
        uuid: uuid.v4(),
        isFromUser: true,
        sessionId: 0);

    // 获取当前会话
    var activeSession = ref.watch(sessionNotifierProvider).activeSession;
    var sessionId = activeSession?.id ?? 0;
    if (sessionId <= 0) {
      activeSession = Session(title: editController.text);
      activeSession = await ref
          .read(sessionNotifierProvider.notifier)
          .upsertSession(activeSession);
      sessionId = activeSession.id!;
      ref
          .read(sessionNotifierProvider.notifier)
          .setActiveSession(activeSession.copyWith(id: sessionId));
      ref.read(refreshProvider.notifier).state = true;
    }

    ref.read(chatUiStateNotifierProvider.notifier).setRequestState(true);

    ref
        .read(messageNotifierProvider.notifier)
        .addMessage(message.copyWith(sessionId: sessionId));

    final newMessageUuid = uuid.v4();

    // 请求deepseek接口
    deepSeekApi.getData(editController.text, (text) {
      print('接收到数据:$text');
      final message = Message(
          content: text, uuid: newMessageUuid, isFromUser: false, sessionId: 0);
      ref
          .read(messageNotifierProvider.notifier)
          .addMessage(message.copyWith(sessionId: sessionId));
    }, () {
      ref.read(chatUiStateNotifierProvider.notifier).setRequestState(false);
      print('完成');
    });
    editController.clear();
  }

  Widget _getSendWidget(bool isRequesting, WidgetRef ref,
      TextEditingController textEditController) {
    return isRequesting
        ? LoadingAnimationWidget.flickr(
            leftDotColor: Colors.blueAccent,
            rightDotColor: Colors.purpleAccent,
            size: 20)
        : IconButton(
            onPressed: () => _sendMessage(ref, textEditController),
            icon: Image.asset(
                width: 25,
                height: 25,
                ref.watch(inputStateProvider).textIsEmpty
                    ? 'images/send_disable.png'
                    : 'images/send_enable.png'));
  }

  // _requestStreamData()

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditController = useTextEditingController();
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: TextField(
        controller: textEditController,
        enabled: !ref.watch(chatUiStateNotifierProvider).isRequesting,
        onChanged: (value) {
          ref
              .read(inputStateProvider.notifier)
              .setTextEmptyState(value.isEmpty);
        },
        onSubmitted: (text) => _sendMessage(ref, textEditController),
        decoration: InputDecoration(
            hintText: '请输入问题',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple, width: 1)),
            suffixIcon: _getSendWidget(
                ref.watch(chatUiStateNotifierProvider).isRequesting,
                ref,
                textEditController)),
      ),
    );
  }
}
