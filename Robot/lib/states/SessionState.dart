import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/Config.dart';
import '../models/Session.dart';

@freezed
class SessionState {
  List<Session> sessionList;
  Session? activeSession;

  SessionState({required this.sessionList, this.activeSession});

  SessionState copyWith({List<Session>? sessionList, Session? activeSession}) {
    return SessionState(
        sessionList: sessionList ?? this.sessionList,
        activeSession: activeSession ?? this.activeSession);
  }
}

class SessionStateNotifier extends StateNotifier<SessionState> {
  SessionStateNotifier() : super(SessionState(sessionList: [])) {
    init();
  }
  // 初始化，加载会话列表
  Future<void> init() async {
    final sessionList = await db.sessionDao.findAllSession();
    state = state.copyWith(sessionList: sessionList);
  }

  // 插入或更新会话
  Future<Session> upsertSession(Session session) async {
    var active = session;

    final id = await db.sessionDao.insertSession(session);
    active = active.copyWith(id: id);

    final updatedList = [...state.sessionList];
    final index = updatedList.indexWhere((s) => s.id == session.id);

    if (index >= 0) {
      updatedList[index] = active;
    } else {
      updatedList.add(active);
    }
    state = state.copyWith(sessionList: updatedList, activeSession: active);
    return active;
  }

  // 删除会话
  Future<void> deleteSession(Session session) async {
    await db.sessionDao.deleteSession(session);

    final updatedList =
        state.sessionList.where((s) => s.id != session.id).toList();
    final activeSession =
        state.activeSession?.id == session.id ? null : state.activeSession;

    state =
        state.copyWith(sessionList: updatedList, activeSession: activeSession);
  }

  // 设置当前会话
  void setActiveSession(Session? session) {
    state = state.copyWith(activeSession: session);
  }
}

// 提供者
final sessionNotifierProvider =
    StateNotifierProvider<SessionStateNotifier, SessionState>(
  (ref) => SessionStateNotifier(),
);
