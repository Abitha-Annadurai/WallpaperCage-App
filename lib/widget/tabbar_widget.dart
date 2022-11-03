import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;

  const TabBarWidget({
    Key? key,
    required this.title,
    required this.tabs,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: TextStyle(fontSize: 27)),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellowAccent, Colors.red,  Colors.green, Colors.indigo,],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.white,
              indicatorWeight: 1,
              tabs: tabs,
            ),
            elevation: 20,
            titleSpacing: 15,
          ),
          body: TabBarView(children: children),
        ),
      );
}
