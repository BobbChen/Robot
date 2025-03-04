import 'package:robot/services/Deepseek_service.dart';
import 'package:robot/storage/database.dart';
import 'package:uuid/uuid.dart';

final deepSeekApi = DeepSeekService();
final uuid = Uuid();
late AppDatabase db;
