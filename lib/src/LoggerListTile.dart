import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _debugColor = Colors.grey.shade600; // AnsiEscape(foregroundColor: 15, italic: true);
final _infoColor = Colors.blueAccent.shade400; // // AnsiEscape(foregroundColor: 81);
final _warnColor = Colors.yellow.shade600; // AnsiEscape(foregroundColor: 208);
const _errorColor = Colors.red; // AnsiEscape(foregroundColor: 196);
const _exceptionColor = Colors.red; // AnsiEscape(backgroundColor: 196, foregroundColor: 15);

class LoggerListTile extends StatelessWidget {
  final LogEntry logEntry;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');

  LoggerListTile({
    Key? key,
    required this.logEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary; // Colors.white70;
    // final theme = Provider.of<ThemeProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final subTitleStyle = theme.textTheme.titleMedium!.copyWith(fontSize: 10);
    final titleStyle = theme.textTheme.bodyMedium!; //.copyWith(color: Colors.white70);

    // final timeStamp = logEntry.timeStamp.toIso8601String().split('T').join(' ');

    final source = logEntry.source == null ? '' : ' (${logEntry.source})';
    // final title = ':$timeStamp$source';
    return ListTile(
      dense: true,
      isThreeLine: false,
      // contentPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, top: 0, right: 10),
          //   child: Column(
          //     children: [
          //       Icon(Icons.alt_route),
          //     ],
          //   ),
          // ),
          // Content
          Expanded(
            flex: 3,
            child: Text(
              logEntry.message,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              maxLines: 2,
              softWrap: true,
            ),
            // Text('SubTitle asdfkljklajds  hfl jgadhsf ljah sdlkjfhads lkjh', style: subTitleStyle),
          ),
          //Trailing
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    logEntry.logLevel.name.toUpperCase(),
                    style: subTitleStyle.copyWith(fontSize: 12, color: getLogLevelColor(logEntry)),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  getLogLevelIcon(logEntry),
                ],
              ),
              // Chip(
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   label: ,
              //   backgroundColor: Colors.transparent,
              //   elevation: 1,
              //   // padding: EdgeInsets.zero,
              //   visualDensity: VisualDensity.compact,

              //   labelPadding: EdgeInsets.zero,
              //   shape: const StadiumBorder(),
              //   avatar: getLogLevelIcon(logEntry),
              // ),
              // Text(logEntry.logLevel.name.toUpperCase()),
              Text(
                _dateFormat.format(logEntry.timeStamp),
                style: subTitleStyle,
              ),
              Text(
                _timeFormat.format(logEntry.timeStamp),
                style: subTitleStyle,
              ),
            ],
          ),
        ],
      ),
      onTap: () => debugPrint('tap'),
    );
  }

  // Widget _getSubtitle(LogEntry logEntry) {
  //   final source = "Source: ${logEntry.source ?? '--'}";
  //   final time = logEntry.timeStamp.toIso8601String().split('T')[1];
  //   return Column(
  //     // mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 4),
  //       _getSubtitleRow1('$time | $source'),
  //       // SizedBox(height: 8),
  //       // _getSubtitleRow2(context),
  //     ],
  //   );
  // }

  // Widget _getSubtitleRow1(String? subtitle) {
  //   return Text(
  //     subtitle ?? "",
  //     textAlign: TextAlign.left,
  //     overflow: TextOverflow.fade,
  //     maxLines: 1,
  //     softWrap: false,
  //   );
  // }

  // Widget _getTitle(LogEntry logEntry) {
  //   final title = '${logEntry.loggerName}: ${logEntry.message}';
  //   return Text(
  //     title,
  //     textAlign: TextAlign.left,
  //     overflow: TextOverflow.fade,
  //     maxLines: 1,
  //     softWrap: false,
  //   );
  // }

  Icon getLogLevelIcon(LogEntry logEntry) {
    const size = 14.0;
    if (logEntry.logLevel == LogLevel.Debug) {
      return Icon(Icons.ac_unit, color: _debugColor, size: size);
    } else if (logEntry.logLevel == LogLevel.Error) {
      return const Icon(Icons.error_outline, color: _errorColor, size: size);
    } else if (logEntry.logLevel == LogLevel.Exception) {
      return const Icon(Icons.access_alarm, color: _exceptionColor, size: size);
    } else if (logEntry.logLevel == LogLevel.Info) {
      return Icon(Icons.info_outline, color: _infoColor, size: size);
    } else if (logEntry.logLevel == LogLevel.Warn) {
      return Icon(Icons.warning_amber, color: _warnColor, size: size);
    } else {
      return const Icon(Icons.device_unknown_outlined, size: size);
    }
  }

  Color getLogLevelColor(LogEntry logEntry) {
    if (logEntry.logLevel == LogLevel.Debug) {
      return _debugColor;
    } else if (logEntry.logLevel == LogLevel.Error) {
      return _errorColor;
    } else if (logEntry.logLevel == LogLevel.Exception) {
      return _exceptionColor;
    } else if (logEntry.logLevel == LogLevel.Info) {
      return _infoColor;
    } else if (logEntry.logLevel == LogLevel.Warn) {
      return _warnColor;
    } else {
      return Colors.black87;
    }
  }
}
