import 'package:dotup_dart_logger/dotup_dart_logger.dart';

typedef LogEntryReader = Future<List<LogEntry>> Function(int currentItemsCount, int parialItemsCount);
