import 'dart:math';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('Logger demo');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerManager.addLogWriter(ConsoleLogWriter(LogLevel.All, formater: PrettyFormater(showColors: true)));
  runApp(const LoggerDemoProvider());
}

class LoggerDemoApp extends StatelessWidget {
  const LoggerDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.console('LoggerDemoApp build');
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'dotup.de Logger Demo',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: LoggerDemoScaffold(),
        );
      },
    );
  }
}

class LoggerDemoProvider extends StatelessWidget {
  const LoggerDemoProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.console('LoggerDemoProvider build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final themeProvider = ThemeProvider.defaultThemes();
            themeProvider.switchTheme(false);
            return themeProvider;
          },
        )
      ],
      child: const LoggerDemoApp(),
    );
  }
}

class LoggerDemoScaffold extends StatefulWidget {
  const LoggerDemoScaffold({Key? key}) : super(key: key);

  @override
  _LoggerDemoScaffoldState createState() => _LoggerDemoScaffoldState();
}

class _LoggerDemoScaffoldState extends State<LoggerDemoScaffold> {
  late LoggerListController controller;
  late LoggerListSettings settings;

  @override
  void initState() {
    super.initState();
    controller = LoggerListController(stackSize: 50);
    settings = LoggerListSettings.standard();
  }

  @override
  Widget build(BuildContext context) {
    return LoggerScaffold(
      appBar: AppBar(
        title: const Text('dotup Logger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add entry',
            onPressed: _createDemoEntry,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () async {
              logger.info('Einstellungen geöffnet');
              final newSettings = await Navigator.of(context).push<LoggerListSettings>(MaterialPageRoute(
                builder: (context) => LoggerListSettingsPage(settings: settings),
              ));

              if (newSettings != null) {
                controller.setFilter(newSettings.logLevelStates);
                controller.stackSize = newSettings.pageSize;
                settings = newSettings;
                logger.info('Neue Einstellungen übernommen');
              }
            },
          ),
        ],
      ),
      title: 'dotup Logger',
    );
  }

  void _createDemoEntry() {
    var random = Random(DateTime.now().microsecondsSinceEpoch);
    var next = 1 << random.nextInt(LogLevel.values.length);
    var nextLevel = LogLevel.fromValue(next);

    switch (nextLevel) {
      case LogLevel.Debug:
        logger.debug("This is an debug entry. Disable debug entries if you're ready for production!",
            source: 'SOURCE1');
        break;

      case LogLevel.Error:
        logger.error(MyError("We've a problem!"));
        break;

      case LogLevel.Exception:
        logger.exception(MyException('Well. It can happen..'));
        break;

      case LogLevel.Info:
        logger.info("I think you've know this information.");
        break;

      case LogLevel.Warn:
        logger.warn("Uuuh it's working. Maybe you can take a look at your source code why this happens so foten?");
        break;

      default:
        logger.warn('nextLevel == ${nextLevel.name}');
    }
  }
}

class MyError extends Error {
  final String message;
  MyError(this.message);

  @override
  String toString() {
    return message;
  }
}

class MyException implements Exception {
  final String? message;

  MyException([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception';
    return 'Exception: $message';
  }
}
