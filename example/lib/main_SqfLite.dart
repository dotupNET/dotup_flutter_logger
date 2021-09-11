import 'dart:async';
import 'dart:io';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('cool');

void main() {
  bool toggle = false;
  // final t = Timer.periodic(const Duration(seconds: 1), (_) {
  //   toggle = !toggle;
  //   logger.debug('Debug');
  //   logger.error(UnimplementedError());
  //   // testLogger.exception();
  //   if (toggle) logger.info('www.dotup.de');
  //   logger.warn('Nice');
  // });
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

  // final rm = await Bootstrapper().initialize(databaseFile);
  // final repo = rm.getRepository<LoggerRepository>()!;
  // final newId = Uuid().v4();
  // final item = LoggerEntity(logLevel: LogLevel.Debug, message: 'message', id: newId, timeStamp: DateTime.now());
  // repo.create(item);
  // final all = await repo.readAll();
  // for (var item in all) {
  //   print(item.message);
  // }
  await SqfLiteLoggerManager.initialize(databaseFile);
  sqfLiteLogWriter = SqfLiteLoggerManager.getSqfLiteLogWriter(LogLevel.All); //  SqfLiteLogWriter(LogLevel.All);
  LoggerManager.addLogWriter(sqfLiteLogWriter);
  runApp(MyApp());
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'dotup.de Logger Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    Timer? t;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          IconButton(
              onPressed: () {
                bool toggle = false;
                if (t != null) {
                  t!.cancel();
                  t = null;
                  return;
                }
                t = Timer.periodic(const Duration(seconds: 1), (_) {
                  toggle = !toggle;
                  logger.debug('Debug');
                  logger.error(UnimplementedError());
                  // testLogger.exception();
                  if (toggle) logger.info('www.dotup.de');
                  logger.warn('Nice');
                });
              },
              icon: const Icon(Icons.play_for_work))
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
        child: controller.liveMode ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<LogEntry>> logEntryReader(int currentItemsCount, int partialItemsCount) async {
    final repo = SqfLiteLoggerManager.getLoggerRepository();
    final result = await repo.readPaged(skip: currentItemsCount, take: partialItemsCount, orderBy: 'timeStamp desc');
    // await Future.delayed(Duration(seconds: 2));
    print(result?.length.toString());
    return result?.map((e) => LoggerMapper.toLogEntry(e)).toList() ?? [];
  }
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   mainAsync();
// }

// Future<void> mainAsync() async {
//   var dir = await getApplicationDocumentsDirectory();
//   final dbFolder = dir.path;

//   if (!await Directory(dbFolder).exists()) {
//     await Directory(dbFolder).create(recursive: true);
//   }

//   final databaseFile = '$dbFolder/logging.db';

//   // final rm = await Bootstrapper().initialize(databaseFile);
//   // final repo = rm.getRepository<LoggerRepository>()!;
//   // final newId = Uuid().v4();
//   // final item = LoggerEntity(logLevel: LogLevel.Debug, message: 'message', id: newId, timeStamp: DateTime.now());
//   // repo.create(item);
//   // final all = await repo.readAll();
//   // for (var item in all) {
//   //   print(item.message);
//   // }
//   await SqfLiteLoggerManager.initialize(databaseFile);
//   sqfLiteLogWriter = SqfLiteLoggerManager.getSqfLiteLogWriter(LogLevel.All); //  SqfLiteLogWriter(LogLevel.All);
//   LoggerManager.addLogWriter(sqfLiteLogWriter);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'dotup.de Logger Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'dotup.de Logger Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late final LoggerListController controller;

//   @override
//   void initState() {
//     controller = LoggerListController(logEntryReader: logEntryReader, stackSize: 50);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: LoggerView(
//           loggerListController: controller,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // final logEntry = LogEntry(logLevel: LogLevel.Debug, message: 'message');
//           // sqfLiteLogWriter.write(logEntry);
//           logger.debug('DEBUGGY');
//           logger.info('Important info');
//           // setState(() {
//           //   controller.toggleNotifier();
//           // });
//         },
//         tooltip: 'Create',
//         child: controller.liveMode ? Icon(Icons.pause) : Icon(Icons.play_arrow),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   Future<List<LogEntry>> logEntryReader(int currentItemsCount, int partialItemsCount) async {
//     final repo = SqfLiteLoggerManager.getLoggerRepository();
//     final result = await repo.readPaged(skip: currentItemsCount, take: partialItemsCount,  orderBy: 'timeStamp desc');
//     return result?.map((e) => LoggerMapper.toLogEntry(e)).toList() ?? [];
//   }
// }
