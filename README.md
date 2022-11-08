# reverse_loadmore

A Flutter component that supports pull-up refresh created from refresh_loadmore

## Images
![images](https://i.imgur.com/v9mtHmQ.png)
![images](https://i.imgur.com/OaUpAOO.png)

## Getting Started

Add this line to pubspec.yaml

``` 
dependencies:
     reverse_loadmore: ^1.0.0
```

## How To Use

Use the class `ReverseLoadmore`

Properties and functions:
``` dart
  /// Callback function on pull up to load more data 
  final Future<void> Function()? onLoadmore;

  /// Whether it is the last page, if it is true, you can not load more
  final bool isFirstPage;

  /// Child widget 
  final Widget child;

  /// Prompt text widget when there is no more data at the top 
  final Widget? noMoreWidget;

  /// You can use your custom scrollController, or not 
  final ScrollController? scrollController;

```

## Examples

```dart
import 'package:flutter/material.dart';
import 'package:reverse_loadmore/reverse_loadmore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// is the last page
  bool isFirstPage = false;

  List? list;
  int page = 1;

  @override
  void initState() {
    super.initState();
    loadFirstData();
  }

  Future<void> loadFirstData() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        list = [
          'dddd',
          'sdfasfa',
          'sdfgaf',
          'adsgafg',
          'dddd',
          'sdfasfa',
          'sdfgaf',
          'adsgafg',
          'dddd',
          'sdfasfa',
          'sdfgaf',
          'adsgafg'
              'adsgafg',
          'dddd',
          'sdfasfa',
          'sdfgaf',
          'adsgafg'
        ];
        isFirstPage = false;
        page = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: list != null
          ? ReverseLoadmore(
              onLoadmore: () async {
                await Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    list!.insertAll(0, ['123', '234', '457']);
                    page++;
                  });
                  print(page);
                  if (page >= 3) {
                    setState(() {
                      isFirstPage = true;
                    });
                  }
                });
              },
              noMoreWidget: Text(
                'you are all caught up!!',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              isFirstPage: isFirstPage,
              child: list!.isNotEmpty
                  ? Column(
                      children: list!
                          .map(
                            (e) => ListTile(
                              title: Text(e),
                              trailing: const Icon(Icons.accessibility_new),
                            ),
                          )
                          .toList(),
                    )
                  : const Center(
                      child: Text('empty'),
                    ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}




```

