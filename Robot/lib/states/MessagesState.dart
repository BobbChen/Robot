import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:robot/models/Message.dart';

import '../common/Config.dart';

class MessageDataList extends StateNotifier<List<Message>> {
  MessageDataList() : super([]) {
    init();
  }

  // 初始化，从数据库获取历史消息
  Future<void> init() async {
    state = await db.messageDao.findAllMessage();
  }

  // 测试方法，暂未接入数据库
  void addMessage(Message message) {
    final index = state.indexWhere((element) => element.uuid == message.uuid);

    var tempMessage = message;
    if (index >= 0) {
      // 流式请求，所以传进来的消息可能是正在展示的消息，此时对消息进行拼接
      final msg = state[index];
      tempMessage = message.copyWith(content: msg.content + message.content);
    }

    // 将消息传入数据库
    db.messageDao.upsertMessage(tempMessage);

    if (index == -1) {
      // 新消息
      state = [...state, message];
    } else {
      final msg = state[index];
      state = [...state]..[index] = tempMessage;
    }

    // state = [...state, message];
  }
}

final messageNotifierProvider =
    StateNotifierProvider<MessageDataList, List<Message>>(
  (ref) => MessageDataList(),
);
