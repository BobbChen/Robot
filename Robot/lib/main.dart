import 'dart:io';
import 'dart:ui';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:robot/pages/MainScreen.dart';
import 'package:robot/storage/database.dart';

import 'common/Config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化数据库
  try {
    final directory = await getApplicationSupportDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final dbPath = '${directory.path}/robot_database.db';
    db = await $FloorAppDatabase.databaseBuilder(dbPath).addMigrations([
      Migration(1, 2, (database) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Session` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL)');
        final tables = await database.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='Message'");
        if (tables.isNotEmpty) {
          await database
              .execute('ALTER TABLE Message ADD COLUMN session_id INTEGER');
        }
        await database
            .execute("insert into Session (id, title) values (1, 'Default')");
        await database.execute("UPDATE Message SET session_id = 1 WHERE 1=1");
      })
    ]).build();
  } catch (e) {
    final directory = await getApplicationSupportDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final logFile = File('${directory.path}/db_init_error.log');
    await logFile.writeAsString('数据库初始化失败: $e');
    print('数据库初始化失败');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void getScreenSize() {
  final physicalSize = window.physicalSize;
  final pixelRatio = window.devicePixelRatio;

  final screenWidth = physicalSize.width / pixelRatio;
  final screenHeight = physicalSize.height / pixelRatio;
  print('屏幕宽度: $physicalSize.width, 高度: $physicalSize.height');

  print('屏幕宽度: $screenWidth, 高度: $screenHeight');
}
