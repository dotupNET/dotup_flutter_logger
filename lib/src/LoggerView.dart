import 'package:dotup_flutter_logger/src/LoggerList.dart';
import 'package:dotup_flutter_logger/src/LoggerListController.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';

class LoggerView extends StatefulWidget {
  late final LoggerListController loggerListController;

  LoggerView({
    Key? key,
    LoggerListController? loggerListController,
    LogEntryReader? logEntryReader,
  })  : assert(loggerListController != null || logEntryReader != null),
        super(key: key) {
    this.loggerListController =
        loggerListController ?? LoggerListController(logEntryReader: logEntryReader!, stackSize: 50);
  }

  @override
  State<LoggerView> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoggerList(loggerListController: widget.loggerListController);
  }
}
