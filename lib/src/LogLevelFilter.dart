import 'package:dotup_dart_logger/dotup_dart_logger.dart';

class LogLevelFilter {
  final LogLevel value;
  bool levelEnabled;
  // Widget? checkbox;
  LogLevelFilter(this.value, [this.levelEnabled = true]);
}
