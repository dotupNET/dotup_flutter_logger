# dotup_flutter_logger

## Take a look at [dotup.de](https://dotup.de) or on [pub.dev](https://pub.dev/packages?q=dotup)


Flutter widgets for [dotup_dart_logger](https://github.com/dotupNET/dotup_dart_logger)


<img src="https://raw.githubusercontent.com/dotupNET/dotup_flutter_logger/master/screenshots/dotup_flutter_logger_1.png" width=300>

<img src="https://raw.githubusercontent.com/dotupNET/dotup_flutter_logger/master/screenshots/dotup_flutter_logger_2.png" width=300>

<video src="https://raw.githubusercontent.com/dotupNET/dotup_flutter_logger/master/screenshots/dotup_flutter_logger_3.mp4" autoplay width=300>

## Example with SqfLite

```dart
Future<void> example() async {

  var dir = await getApplicationDocumentsDirectory();
  final dbFolder = dir.path;

  if (!await Directory(dbFolder).exists()) {
    await Directory(dbFolder).create(recursive: true);
  }

  final databaseFile = '$dbFolder/logging.db';

  // Initialize log writer
  final sqfLiteLogWriter = SqfLiteLogWriter(LogLevel.All);
  await sqfLiteLogWriter.initialize(databaseFile);
  // Add to logger manager
  LoggerManager.addLogWriter(sqfLiteLogWriter);

  runApp(MyApp());


  // Use it everywhere
  final logger = Logger('Nice');
  logger.warn('Oh');
  logger.info('Ah');

  // Get all entries from database
  final repo = sqfLiteLogWriter.repository;
  final all = await repo.readAll();
  for (var item in all) {
    print(item.message);
  }

}
```