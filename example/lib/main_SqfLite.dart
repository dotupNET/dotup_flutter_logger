import 'dart:async';
import 'dart:io';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('cool');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dotup.de Logger Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoggerScaffold(
        title: 'dotup Logger',
      ),
    );
  }
}
