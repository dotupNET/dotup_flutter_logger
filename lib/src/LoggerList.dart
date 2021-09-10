import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';

import 'LoggerListController.dart';
import 'LoggerRow.dart';

class LoggerList extends StatefulWidget {
  late final LoggerListController loggerListController;

  LoggerList({
    Key? key,
    required this.loggerListController,
  }) : super(key: key);

  @override
  State<LoggerList> createState() => _LoggerListState();
}

class _LoggerListState extends State<LoggerList> {
  // late List<String> _currentItems;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: [
          if (isLoading == true) LinearProgressIndicator(),
          InfiniteScrollFuture(
            // scrollController: _scrollController,
            onReloadRequest: () async {
              setState(() {
                isLoading = true;
              });
              await widget.loggerListController.loadMore();
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            builder: (context, scrollController) {
              return ListView.separated(
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
                  return LoggerRow(logEntry: widget.loggerListController.entries[index]);
                },
                itemCount: widget.loggerListController.entries.length,
              );
            },
          ),
        ],
      ),
    );

    // return Flexible(
    //   flex: 1,
    //   child: ListView.separated(
    //     separatorBuilder: (context, index) {
    //       return Divider(
    //         color: Colors.grey.shade500,
    //         thickness: 1,
    //       );
    //     },
    //     // dense:true,
    //     padding: EdgeInsets.all(0),
    //     reverse: false,
    //     shrinkWrap: false,
    //     itemBuilder: (_, int index) {
    //       return LoggerRow(logEntry: widget.loggerLiveController.entries[index]);
    //     },
    //     itemCount: widget.loggerLiveController.entries.length,
    //   ),
    // );
    // return Flexible(
    //   flex: 1,
    //   child: ListView.separated(
    //     separatorBuilder: (context, index) {
    //       return Divider(
    //         color: Colors.grey.shade500,
    //         thickness: 1,
    //       );
    //     },
    //     // dense:true,
    //     padding: EdgeInsets.all(0),
    //     reverse: false,
    //     shrinkWrap: false,
    //     itemBuilder: (_, int index) {
    //       return LoggerRow(logEntry: loggerLiveController.entries[index]);
    //     },
    //     itemCount: loggerLiveController.entries.length,
    //   ),
    // );
  }
}
