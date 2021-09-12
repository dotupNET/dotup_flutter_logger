import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/src/LogLevelFilter.dart';
import 'package:flutter/widgets.dart';

import 'SizeLimitedList.dart';

abstract class ILoggerController with ChangeNotifier {
  late final SizeLimitedList<LogEntry> entries;
  late final CallbackLogWriter logWriter;

  set stackSize(int value);
  int get stackSize;
  // bool get isNotifing;
  void filter(List<LogLevelFilter> logLevelStates);
  Future<void> setLiveMode(bool isLive);
}
