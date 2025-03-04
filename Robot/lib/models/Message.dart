import 'package:floor/floor.dart';

// 注解用于标记了该类为持久类
@entity
class Message {
  // 注解用于设置主键
  @primaryKey
  final String uuid;
  final String content;
  final bool isFromUser;

  @ForeignKey(
      childColumns: ['session_id'], parentColumns: ['id'], entity: Message)
  @ColumnInfo(name: 'session_id')
  final int sessionId;

  Message(
      {required this.content,
      required this.uuid,
      required this.isFromUser,
      required this.sessionId});
}

extension MessageExtension on Message {
  Message copyWith(
      {String? uuid, String? content, bool? isFromUser, int? sessionId}) {
    return Message(
        content: content ?? this.content,
        uuid: uuid ?? this.uuid,
        isFromUser: isFromUser ?? this.isFromUser,
        sessionId: sessionId ?? this.sessionId);
  }
}
