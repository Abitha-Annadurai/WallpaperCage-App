import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("assets/icon/logo.jpg"),
                  ),
                ),SizedBox(height: 30,),
                  Text('Developed By Abitha Annadurai', style: TextStyle(fontSize: 34), overflow: TextOverflow.clip,),
                SizedBox(height: 10,),
                Text('100+ wallpaper for mobile screen, profile picture, etc,. If any mistake present in this application please let me know.',
                  style: TextStyle(fontSize: 20), overflow: TextOverflow.clip,),
                Text('For reporting any bugs or any issues please contact aabithamcavcet@gmail.com', style: TextStyle(fontSize: 20), overflow: TextOverflow.clip,),
              ]
          ),
        ),
      ),
    );
  }
}
