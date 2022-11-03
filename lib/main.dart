// @dart=2.9
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpapercage/providers/fav_wallpaper_manager.dart';
import 'package:wallpapercage/rate.dart';
import 'package:wallpapercage/utils.dart';

import 'all_images.dart';
import 'constants.dart';
import 'fav.dart';
import 'home.dart';
import 'models/wallpaper.dart';

Future<void> main() async {
  await _initApp();
  runApp(const MyHomePage(
    title: 'WallpaperCage',
  ));
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

var docDir = await getApplicationDocumentsDirectory();
Hive.init(docDir.path);

var favBox = await Hive.openBox(FAV_BOX);
if (favBox.get(FAV_LIST_KEY) == null) {
favBox.put(FAV_LIST_KEY, List<dynamic>.empty(growable: true));
}

var settings = await Hive.openBox(SETTINGS);
if (settings.get(DARK_THEME_KEY) == null) {
settings.put(DARK_THEME_KEY, false);
}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  }

  @override
  void dispose () {
    subscription.cancel();
    super.dispose();
  }

  final result =  Connectivity().checkConnectivity();
  showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? 'Good Network :)' : 'Oops... Check Network :(';
    final color = hasInternet ? Colors.purpleAccent : Colors.redAccent;
    Utils.showTopSnackBar(context, message, color);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavWallpaperManager(),
         child: OverlaySupport(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: widget.title,
            theme: ThemeData(primarySwatch: Colors.purple),
            home: _buildScaffold(),
          ),
          )
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(
            fontFamily: 'Rye-Regular',
            fontSize: 20
          ),
        ),
        actions: [
          IconButton(
            icon:  const FaIcon(FontAwesomeIcons.pinterest),
            onPressed: () async {
              var url = Uri.parse("https://pin.it/1hWCpvg");
              if(await canLaunchUrl(url) != null){
                await launchUrl(url);
              }else{
                throw "Cannot Load";
              }
            },
          ),

    Builder(
    builder: (context) =>  IconButton(
            icon: Icon(Icons.stars),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Rate()));
              },
          ),),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: (){
              Share.share(" ");
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            var wallpapersList = List<Wallpaper>.empty(growable: true);
            var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

            snapshot.data?.docs?.forEach((documentSnapshot) {
              var wallpaper = Wallpaper.fromDocumentSnapshot(documentSnapshot);

              if (favWallpaperManager.isFavorite(wallpaper)) {
                wallpaper.isFavorite = true;
              }
              wallpapersList.add(wallpaper);
            });

            return PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return _getPagesAtIndex(index, wallpapersList);
              },
              onPageChanged: (int index) {
                setState(() {
                  currentSelected = index;
                });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Shifting
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(
          fontFamily: 'VujahdayScript-Regular'
      ),
      currentIndex: currentSelected,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'All Images',
          backgroundColor: Colors.indigo,),
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          backgroundColor: Colors.grey,),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          backgroundColor: Colors.lightGreen,),
      ],
      onTap: (int index) {
        setState(() {
          currentSelected = index;
          pageController.animateToPage(
            currentSelected,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        });
      },
    );
  }

  Widget _getPagesAtIndex(int index, List<Wallpaper> wallpaperList) {
    switch (index) {
      case 0:
        return AllImages(
          wallpapersList: wallpaperList,
        );
      case 1:
        return Home(
          wallpapersList: wallpaperList,
        );
      case 2:
        return Favorite(
          wallpapersList: wallpaperList,
        );
      default:
        return const CircularProgressIndicator();
    }
  }
}
