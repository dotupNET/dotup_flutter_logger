import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';

import 'LoggerListController.dart';
import 'LoggerListTile.dart';

class LoggerList extends StatefulWidget {
  final LoggerListController loggerListController;
  final ValueSetter<LogEntry> onTap;

  const LoggerList({
    Key? key,
    required this.loggerListController,
    required this.onTap,
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
    return ChangeNotifierConsumer<LoggerListController>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            if (isLoading == true) const LinearProgressIndicator(),
            InfiniteScrollFuture(
              key: ValueKey(controller.entries.length),
              // scrollController: _scrollController,
              onReloadRequest: () async {
                setState(() {
                  isLoading = true;
                });
                await controller.loadMore();
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              builder: (context, scrollController) {
                final entries = controller.entries;
                return RefreshIndicator(
                  onRefresh: () async => await controller.loadMore(reset: true),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey.shade500,
                        height: 1,
                        thickness: 1,
                      );
                    },
                    // dense:true,
                    padding: const EdgeInsets.all(0),
                    reverse: false,
                    shrinkWrap: false,
                    itemBuilder: (_, int index) {
                      return LoggerListTile(
                        logEntry: entries[index],
                        onTap: widget.onTap,
                      );
                    },
                    itemCount: entries.length,
                  ),
                );
              },
            ),
          ],
        );
      },
      provider: widget.loggerListController,
    );
  }
}
