import 'package:floor/floor.dart';
import 'package:robot/models/Message.dart';

@dao
abstract class MessageDao {
  // 查询所有记录
  @Query('SELECT * FROM Message')
  Future<List<Message>> findAllMessage();

  // 根据id查询记录
  @Query('SELECT * FROM Message WHERE id = :id')
  Future<Message?> findMessageById(String id);

  // 往数据库中插入消息
  // 冲突策略：替换旧数据并继续
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(Message message);

  // 删除记录
  @delete
  Future<void> deleteMessage(Message message);

  // 获取对话下的所有Message
  @Query('SELECT * FROM Message WHERE session_id = :sessionId')
  Future<List<Message>> findMessageBySessionId(int sessionId);
}
