import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';

import '../dotup_flutter_logger.dart';

class LoggerListSettings {
  final List<LogLevelFilter> logLevelStates;
  final int pageSize;

  LoggerListSettings({required this.logLevelStates, required this.pageSize});

  factory LoggerListSettings.standard() {
    return LoggerListSettings(
      logLevelStates: [
        // LogLevelState(LogLevel.All),
        LogLevelFilter(LogLevel.Debug),
        LogLevelFilter(LogLevel.Error),
        LogLevelFilter(LogLevel.Exception),
        LogLevelFilter(LogLevel.Info),
        LogLevelFilter(LogLevel.Warn),
      ],
      pageSize: 20,
    );
  }
}

class LoggerListSettingsPage extends StatefulWidget {
  const LoggerListSettingsPage({Key? key, this.settings}) : super(key: key);

  final LoggerListSettings? settings;

  @override
  State<LoggerListSettingsPage> createState() => _LoggerListSettingsPageState();
}

class _LoggerListSettingsPageState extends State<LoggerListSettingsPage> {
  late final List<LogLevelFilter> logLevelStates;
  late int pageSize;

  @override
  void initState() {
    super.initState();
    final initialSettings = widget.settings ?? LoggerListSettings.standard();
    pageSize = initialSettings.pageSize;
    logLevelStates = initialSettings.logLevelStates;
  }

  @override
  build(BuildContext context) {
    const space = 4.0;
    final color = Theme.of(context).colorScheme.secondary; // Colors.white70;
    // final theme = Provider.of<ThemeProvider>(context, listen: false);

    final checkboxes = logLevelStates.map((e) {
      return SectionTile.checkbox(
        titleText: e.value.name,
        onChanged: (bool? value) {
          setState(() {
            e.levelEnabled = !e.levelEnabled;
            // widget.loggerListController.filter(logLevelStates);
          });
        },
        value: e.levelEnabled,
        dense: true,
        color: color,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Änderungen übernehmen',
            onPressed: () {
              Navigator.of(context).pop(LoggerListSettings(logLevelStates: logLevelStates, pageSize: pageSize));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SectionView(
          padding: const EdgeInsets.fromLTRB(space, space, space, space),
          children: [
            Section(
              header: SectionHeader(
                text: 'Allgemein',
              ),
              children: [
                SectionTile.dropdownButton<int>(
                  titleText: 'Anzahl Datensätze pro Seite',
                  color: color,
                  items: [10, 20, 50, 100, 200].map((int category) {
                    return category;
                  }).toList(),
                  // icon: Icon(Icons.arrow_drop_down),
                  onChanged: (value) {
                    setState(() {
                      pageSize = value ?? 20;
                    });
                  },
                  value: pageSize,
                  dense: true,
                ),
              ],
            ),
            Section(
              // margin: EdgeInsets.zero,
              header: SectionHeader(
                text: 'Log levels',
              ),
              children: checkboxes,
            ),
          ],
        ),
      ),
    );
  }
}
