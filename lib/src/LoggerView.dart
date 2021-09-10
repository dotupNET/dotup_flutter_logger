import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/src/LoggerList.dart';
import 'package:dotup_flutter_logger/src/LoggerListController.dart';
import 'package:flutter/material.dart';

import 'LogLevelFilter.dart';

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
  _LoggerViewState createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  late final List<LogLevelFilter> logLevelStates;

  @override
  void initState() {
    logLevelStates = [
      // LogLevelState(LogLevel.All),
      LogLevelFilter(LogLevel.Debug),
      LogLevelFilter(LogLevel.Error),
      LogLevelFilter(LogLevel.Exception),
      LogLevelFilter(LogLevel.Info),
      LogLevelFilter(LogLevel.Warn),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = logLevelStates.map((e) {
      return CheckboxListTile(
        title: Text(e.value.name),
        onChanged: (bool? value) {
          setState(() {
            e.state = !e.state;
            widget.loggerListController.filter(logLevelStates);
          });
        },
        value: e.state,
      );
    }).toList();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ExpansionTile(
                title: const Text('LogLevel filter'),
                children: menuItems,
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<int>(
                items: [10, 20, 50, 100, 200].map((int category) {
                  return DropdownMenuItem(value: category, child: Text(category.toString()));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    widget.loggerListController.stackSize = newValue!;
                  });
                },
                value: widget.loggerListController.stackSize,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
        LoggerList(loggerListController: widget.loggerListController),
      ],
    );
  }
}
