import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:wallpapercage/page/rate_dialog_page.dart';
import 'package:wallpapercage/widget/rate_app_init_widget.dart';
import 'package:wallpapercage/widget/tabbar_widget.dart';

class Rate extends StatelessWidget {
  static final String title = 'ABOUT US';

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: title,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: RateAppInitWidget(
      builder: (rateMyApp) => HomePage(rateMyApp: rateMyApp),
    ),
  );
}

class HomePage extends StatefulWidget {
  final RateMyApp rateMyApp;

  const HomePage({
    Key? key, required this.rateMyApp,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
    title: Rate.title,
    tabs: [
      Tab(icon: Icon(Icons.info_outline_rounded),
        //child: Text("Attention", style: TextStyle(fontSize: 18)),
      )],
    children: [
      RateDialogPage(rateMyApp: widget.rateMyApp),
    ],
  );
}
