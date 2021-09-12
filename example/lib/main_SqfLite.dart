import 'dart:async';
import 'dart:io';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('Logger demo');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

    final testLogger = Logger('test');
  // bool toggle = false;
  // final t = Timer.periodic(const Duration(seconds: 1), (_) {
  //   toggle = !toggle;
  //   testLogger.debug("This is an debug entry. Disable debug entries if you're ready for production!", source: 'main');
  //   testLogger.error(UnimplementedError());
  //   // testLogger.exception();
  //   if (toggle) testLogger.info("I think you've know this information.");
  //   testLogger.warn("Uuuh it's working. Maybe you can take a look at your source code why this happens so foten?");
  // });
  mainAsync();
}

Future<void> mainAsync() async {
  var dir = await getApplicationDocumentsDirectory();
  final dbFolder = dir.path;

  if (!await Directory(dbFolder).exists()) {
    await Directory(dbFolder).create(recursive: true);
  }

  final databaseFile = '$dbFolder/logging.db';
  await SqfLiteLoggerManager.initialize(databaseFile);
  sqfLiteLogWriter = SqfLiteLoggerManager.getSqfLiteLogWriter(LogLevel.All); //  SqfLiteLogWriter(LogLevel.All);
  LoggerManager.addLogWriter(sqfLiteLogWriter);

  runApp(const LoggerDemoProvider());
}

class LoggerDemoApp extends StatelessWidget {
  const LoggerDemoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'dotup.de Logger Demo',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const LoggerScaffold(
            title: 'dotup Logger',
          ),
        );
      },
    );
  }
}

class LoggerDemoProvider extends StatelessWidget {
  const LoggerDemoProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
