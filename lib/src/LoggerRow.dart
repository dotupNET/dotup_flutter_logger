import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:flutter/material.dart';

final _debugColor = Colors.grey.shade900; // AnsiEscape(foregroundColor: 15, italic: true);
final _infoColor = Colors.blueAccent.shade400; // // AnsiEscape(foregroundColor: 81);
final _warnColor = Colors.yellow.shade600; // AnsiEscape(foregroundColor: 208);
const _errorColor = Colors.red; // AnsiEscape(foregroundColor: 196);
const _exceptionColor = Colors.red; // AnsiEscape(backgroundColor: 196, foregroundColor: 15);

class LoggerRow extends StatelessWidget {
  final LogEntry logEntry;

  const LoggerRow({
    super.key,
    required this.logEntry,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // horizontalTitleGap: -10,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      minLeadingWidth: 10,
      // contentPadding: EdgeInsets.only(left: 4, right: 4),
      leading: getLogLevelIcon(logEntry),
      title: _getTitle(logEntry),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      subtitle: _getSubtitle(logEntry),
    );
  }

  Widget _getSubtitle(LogEntry logEntry) {
    final source = "Source: ${logEntry.source ?? '--'}";
    final time = logEntry.timeStamp.toIso8601String().split('T')[1];
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        _getSubtitleRow1('$time | $source'),
        // SizedBox(height: 8),
        // _getSubtitleRow2(context),
      ],
    );
  }

  Widget _getSubtitleRow1(String? subtitle) {
    return Text(
      subtitle ?? "",
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    );
  }

  Widget _getTitle(LogEntry logEntry) {
    final title = '${logEntry.loggerName}: ${logEntry.message}';
    return Text(
      title,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    );
  }

  getLogLevelIcon(LogEntry logEntry) {
    if (logEntry.logLevel == LogLevel.Debug) {
      return Icon(Icons.ac_unit, color: _debugColor);
    } else if (logEntry.logLevel == LogLevel.Error) {
      return const Icon(Icons.error_outline, color: _errorColor);
    } else if (logEntry.logLevel == LogLevel.Exception) {
      return const Icon(Icons.access_alarm, color: _exceptionColor);
    } else if (logEntry.logLevel == LogLevel.Info) {
      return Icon(Icons.info_outline, color: _infoColor);
    } else if (logEntry.logLevel == LogLevel.Warn) {
      return Icon(Icons.warning_amber, color: _warnColor);
    } else {
      return const Icon(Icons.device_unknown_outlined);
    }
  }
}
