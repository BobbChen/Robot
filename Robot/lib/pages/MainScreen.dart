import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:robot/models/Session.dart';
import 'package:robot/pages/ChatScreen.dart';
import 'package:robot/states/SessionState.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);
final refreshProvider = StateProvider<bool>((ref) => false);

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 选中的导航index
    var selectedIndex = ref.watch(selectedIndexProvider);

    // 缓存的会话
    final sessions = ref.watch(sessionNotifierProvider).sessionList;

    List<NavigationRailDestination> _getDestinations() {
      List<NavigationRailDestination> destinations = [
        NavigationRailDestination(icon: Icon(Icons.add), label: Text('开启新对话'))
      ];
      List<NavigationRailDestination> sessionDestinations = sessions
          .map((session) => NavigationRailDestination(
              icon: Icon(Icons.book), label: Text(session.title)))
          .toList();
      return destinations + sessionDestinations;
    }

    final refreshDestination = ref.watch(refreshProvider);
    if (refreshDestination) {
      print("是刷新信号！！！！！！");
      selectedIndex = sessions.length;
    }

    Widget selectedPage;
    print("选中项的index为:$selectedIndex,历史会话，总个数:${sessions.length}");
    switch (selectedIndex) {
      case 0:
        selectedPage = ChatScreen(session: null);
        final state = ref.watch(sessionNotifierProvider);
        state.activeSession = Session(title: '', id: -1);
        break;
      default:
        Session session = sessions[selectedIndex - 1];
        print(
            "选中历史会话，总个数:${sessions.length},传入session为:${session.title},id为:${session.id}");
        final state = ref.watch(sessionNotifierProvider);
        state.activeSession = session.copyWith(id: session.id);
        selectedPage = ChatScreen(session: session);
        break;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                  labelType: NavigationRailLabelType.none,
                  destinations: _getDestinations(),
                  onDestinationSelected: (index) {
                    print("点击的index:$index");
                    ref.read(selectedIndexProvider.notifier).state = index;
                    Future.microtask(
                        () => ref.read(refreshProvider.notifier).state = false);
                  },
                  extended: constraints.maxWidth >= 600,
                  selectedIndex: ref.watch(selectedIndexProvider)),
            ),
            Expanded(child: selectedPage)
          ],
        ),
      );
    });
  }
}
