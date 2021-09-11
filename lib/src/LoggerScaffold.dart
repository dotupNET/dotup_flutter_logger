import 'dart:async';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:flutter/material.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('cool');

class LoggerScaffold extends StatefulWidget {
  const LoggerScaffold({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _LoggerScaffoldState createState() => _LoggerScaffoldState();
}

class _LoggerScaffoldState extends State<LoggerScaffold> {
  late final LoggerListController controller;
  LoggerListSettings? settings;

  @override
  void initState() {
    settings = null;
    controller = LoggerListController(stackSize: 50, logEntryReader: logEntryReader);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add entry',
            onPressed: () async {
              logger.debug('Debug');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () async {
              final newSettings = await Navigator.of(context).push<LoggerListSettings>(MaterialPageRoute(
                builder: (context) => LoggerListSettingsPage(settings: settings),
              ));

              if (newSettings != null) {
                controller.setFilter(newSettings.logLevelStates);
                controller.stackSize = newSettings.pageSize;
                settings = newSettings;
              }
            },
          ),
        ],
      ),
      body: Center(
        child: LoggerView(
          loggerListController: controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.setLiveMode(!controller.liveMode);
          setState(() {});
        },
        tooltip: 'Pause/Resume',
        child: controller.liveMode ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
      ), 
    );
  }

  Future<List<LogEntry>> logEntryReader(int currentItemsCount, int partialItemsCount) async {
    final repo = SqfLiteLoggerManager.getLoggerRepository();
    final result = await repo.readPaged(skip: currentItemsCount, take: partialItemsCount, orderBy: 'timeStamp desc');
    return result?.map((e) => LoggerMapper.toLogEntry(e)).toList() ?? [];
  }
}
