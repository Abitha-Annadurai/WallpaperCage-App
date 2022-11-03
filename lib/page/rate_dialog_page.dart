import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpapercage/privacy.dart';
import 'package:wallpapercage/widget/button_widget.dart';

class RateDialogPage extends StatefulWidget {
  final RateMyApp rateMyApp;

  const RateDialogPage({Key? key, required this.rateMyApp,}) : super(key: key);

  @override
  _RateDialogPageState createState() => _RateDialogPageState();
}

class _RateDialogPageState extends State<RateDialogPage> {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black26,
    padding: EdgeInsets.all(45),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60,),
              ButtonWidget(
                text: 'About App',
                onClicked: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy())),
              ),
              SizedBox(height: 21,),
              ButtonWidget(
                text: 'Rate on Play Store',
                onClicked: () => widget.rateMyApp.showRateDialog(context),
              ),
            ]
          ),
        ),
      );
}
