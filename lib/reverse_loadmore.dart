library reverse_loadmore;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReverseLoadmore extends StatefulWidget {
  /// Callback function on pull up to load more data
  final Future<void> Function()? onLoadmore;

  /// Whether it is the first page, if it is true, you can not load more
  final bool isFirstPage;

  /// Child widget
  final Widget child;

  /// Prompt text widget when there is no more data at the top
  final Widget? noMoreWidget;

  /// You can use your custom scrollController, or not
  final ScrollController? scrollController;

  const ReverseLoadmore({
    Key? key,
    required this.child,
    required this.isFirstPage,
    this.onLoadmore,
    this.noMoreWidget,
    this.scrollController,
  }) : super(key: key);
  @override
  _ReverseLoadmoreState createState() => _ReverseLoadmoreState();
}

class _ReverseLoadmoreState extends State<ReverseLoadmore> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ScrollController? _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(() async {
      if (_scrollController!.position.pixels <=
          _scrollController!.position.minScrollExtent) {
        if (_isLoading) {
          return;
        }

        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        if (!widget.isFirstPage && widget.onLoadmore != null) {
          await widget.onLoadmore!();
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWiget = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(),
                  )
                : widget.isFirstPage
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.noMoreWidget ??
                            Text(
                              'No more data',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                      )
                    : Container(),
          ],
        ),
        widget.child,
      ],
    );

    return mainWiget;
  }
}
