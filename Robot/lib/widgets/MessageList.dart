import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:robot/models/Message.dart';
import 'package:robot/models/Session.dart';
import 'package:robot/states/MessagesState.dart';
import 'package:robot/widgets/ReceiveMessageItem.dart';
import 'package:robot/widgets/SendMessageItem.dart';

import '../common/Config.dart';

final selectedIndexProvider = StateProvider<List<Message>>((ref) => []);

class MessageList extends HookConsumerWidget {
  final Session? session;
  const MessageList({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听消息

    final messages = ref.watch(messageNotifierProvider);

    final listViewController = useScrollController();

    Future<List<Message>> getMessages() async {
      return await db.messageDao.findMessageBySessionId(session?.id ?? 0);
    }

    ref.listen(messageNotifierProvider, (pre, next) {
      Future.delayed(Duration(microseconds: 50), () {
        listViewController.jumpTo(listViewController.position.maxScrollExtent);
      });
    });

    return FutureBuilder(
        future: getMessages(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapShot) {
          final messages = snapShot.data ?? [];
          return ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(scrollbars: false),
              child: ListView.separated(
                controller: listViewController,
                itemBuilder: (context, index) {
                  if (!messages.isEmpty) {
                    final message = messages[index];

                    return message.isFromUser
                        ? Sendmessageitem(
                            message: message, bgColor: Colors.lightBlueAccent)
                        : Receivemessageitem(message, Colors.white);
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text('暂无数据'),
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) =>
                    const Divider(height: 16, color: Colors.transparent),
                itemCount: messages.length,
              ));
        });
  }
}
