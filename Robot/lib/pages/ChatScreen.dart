import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:robot/common/UserInputWidget.dart';
import 'package:robot/widgets/messageList.dart';

import '../models/Session.dart';

class ChatScreen extends HookConsumerWidget {
  final Session? session;
  const ChatScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 消息主页面
    Widget createMainContainer() {
      return Expanded(
        child: Container(
          color: Color(0xFFF1F1F1),
          padding: EdgeInsets.only(left: 8, top: 20, right: 8, bottom: 10),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F1)),
                child: MessageList(
                    session:
                        session), // error:error: The named parameter 'session' isn't defined. (undefined_named_parameter at [robot] lib/pages/ChatScreen.dart:26)
              )),
              const SizedBox(
                height: 20,
              ),
              const UserInputWidget()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: WindowBorder(
          color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [createMainContainer()],
          )),
    );
  }
}
