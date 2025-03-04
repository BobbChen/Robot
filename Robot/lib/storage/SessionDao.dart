import 'package:floor/floor.dart';

import '../models/Session.dart';

@dao
abstract class SessionDao {
  @Query('SELECT * FROM Session ORDER BY id DESC') // 返回结果按照id排序
  Future<List<Session>> findAllSession(); // 查询所有会话

  // 根据id查找会话
  @Query('SELECT * FROM Session WHERE id = :id')
  Future<Session?> findSessionById(String id);

  // 插入消息：冲突策略新数据替换旧数据
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertSession(Session session);

  // 删除会话
  @delete
  Future<void> deleteSession(Session session);
}
