import 'package:dotup_flutter_logger/src/LoggerLiveController.dart';
import 'package:flutter/material.dart';

import 'LoggerRow.dart';

class LoggerList extends StatelessWidget {
  late final LoggerLiveController loggerLiveController;

  LoggerList({
    Key? key,
    required this.loggerLiveController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey.shade500,
            thickness: 1,
          );
        },
        // dense:true,
        padding: EdgeInsets.all(0),
        reverse: false,
        shrinkWrap: false,
        itemBuilder: (_, int index) {
          return LoggerRow(logEntry: loggerLiveController.entries[index]);
        },
        itemCount: loggerLiveController.entries.length,
      ),
    );
  }
}
