import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:dotup_flutter_logger/src/Utils.dart';
import 'package:flutter/material.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('cool');

class LoggerScaffold extends StatefulWidget {
  const LoggerScaffold({
    Key? key,
    required this.title,
    this.appBar,
    this.logEntryReader,
    this.loggerListController,
  }) : super(key: key);

  final String title;

  final AppBar? appBar;

  final LogEntryReader? logEntryReader;

  final LoggerListController? loggerListController;

  @override
  State<LoggerScaffold> createState() => _LoggerScaffoldState();
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _LoggerScaffoldState extends State<LoggerScaffold> {
  late final LoggerListController controller;
  LoggerListSettings? settings;

  @override
  void initState() {
    settings = null;
    controller =
        widget.loggerListController ?? LoggerListController(stackSize: 50, logEntryReader: widget.logEntryReader);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            title: Text(widget.title),
            actions: [
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: LoggerView(
              loggerListController: controller,
            ),
          ),
        ],
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
}
