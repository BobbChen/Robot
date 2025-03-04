import 'dart:async';

import 'package:floor/floor.dart';
import 'package:robot/storage/MessageDao.dart';
import 'package:robot/storage/SessionDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/Message.dart';
import '../models/Session.dart';

part 'database.g.dart'; // floor_generator会根据此注解生成文件

@Database(version: 3, entities: [Message, Session])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
  SessionDao get sessionDao;
}
