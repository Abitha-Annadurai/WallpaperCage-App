
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:wallpapercage/providers/fav_wallpaper_manager.dart';
import 'models/wallpaper.dart';

class WallpaperGallery extends StatefulWidget {
  final List<Wallpaper> wallpaperList;
  final int initialPage;

  const WallpaperGallery({Key? key, required this.wallpaperList, required this.initialPage}) : super(key: key);
  @override
  _WallpaperGalleryState createState() => _WallpaperGalleryState();
}
class _WallpaperGalleryState extends State<WallpaperGallery> {
  late PageController _pageController;
  late int _currentIndex;
  get index => _currentIndex;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey scr = GlobalKey();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _pageController = PageController(initialPage: widget.initialPage);
    _currentIndex = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        key: _scaffoldKey,
        builder: (BuildContext context) {
          var favWallpaperManager = Provider.of<FavWallpaperManager>(context);
          return Stack(children: [
            RepaintBoundary(
              key: scr,
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                itemCount: widget.wallpaperList.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      widget.wallpaperList.elementAt(index).url,
                    ),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 100.0,
                  color: Color(IconTheme.of(context).color!.value ^ 0xffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* IconButton(
                          icon: const Icon(
                              Icons.file_download),
                          onPressed: () async {
                            await _downloadWallpaper(context);
                            },
                        ),*/

                      IconButton(
                        icon: const Icon(
                            Icons.file_download),
                        onPressed: () async {
                          saveScreen();
                        },
                      ),

                      IconButton(
                          icon: Icon(
                            widget.wallpaperList.elementAt(_currentIndex).isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (widget.wallpaperList.elementAt(_currentIndex).isFavorite) {
                              favWallpaperManager.removeFromFav(
                                widget.wallpaperList.elementAt(_currentIndex),
                              );
                            } else {
                              favWallpaperManager.addToFav(
                                widget.wallpaperList.elementAt(_currentIndex),
                              );
                            }
                            widget.wallpaperList.elementAt(_currentIndex).isFavorite = !widget.wallpaperList.elementAt(_currentIndex).isFavorite;
                          }),
                    ],
                  ),
                ),
              ),
            )
          ]
          );
        },
      ),
    );
  }

  void saveScreen() async {
    Future.delayed(const Duration(milliseconds: 100), () async {
      RenderRepaintBoundary? bound =  scr.currentContext!.findRenderObject() as RenderRepaintBoundary? ;
      double dpr = ui.window.devicePixelRatio;
      final ui.Image image = await bound!.toImage(pixelRatio: dpr);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if(byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final resultSave = await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytes),
            quality: 90,
            name: 'Wallpapercage-${DateTime.now()}');
        print(resultSave);
        _showInSnackBar(message: "Saved to gallery");
      }
      /* final result = await ImageGallerySaver.saveImage(
        byteData!.buffer.asUint8List());
    print('$byteData *saved* $result');
    _showInSnackBar(message: "Saved to gallery");*/
    });
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> status = await [Permission.storage]
        .request();
    final info = status[Permission.storage].toString();
    print('$info');
  }

  void _showInSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
          style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.w100, fontFamily: 'Acme-Regular'),
        ),
        backgroundColor: Colors.grey,
        duration: const Duration(seconds: 5),),
    );
  }
}

/* Future _downloadWallpaper(BuildContext imageData) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        var imageId = await ImageDownloader.downloadImage(
          widget.wallpaperList.elementAt(_currentIndex).url,
          destination: AndroidDestinationType.directoryPictures,
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Download Completed...',),
              backgroundColor: Colors.grey,
              duration: const Duration(seconds: 10),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () async {
                  var path = await ImageDownloader.findPath(imageId!);
                  await ImageDownloader.open(path!);
                },
              ),
            ),
        );
      } on PlatformException catch (error) {
        print(error);
      }
    } else {
      _showOpenSettingsAlert(context);
    }
  }

  void _showOpenSettingsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Need access to storage.'),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text('Open settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            )
          ],
        );
      },
    );
  }*/

