
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpapercage/providers/fav_wallpaper_manager.dart';
import 'package:wallpapercage/wallpaper_gallery.dart';

import 'models/wallpaper.dart';

class CategoryWallpapers extends StatefulWidget {
  final String category;

  const CategoryWallpapers({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryWallpapersState createState() => _CategoryWallpapersState();
}

class _CategoryWallpapersState extends State<CategoryWallpapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers',
          style: TextStyle(
            fontFamily: 'Acme-Regular'
          ),
        ),

      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if(snapshot.hasData){
            var wallpapers = _getWallpapersOfCurrentCategory(snapshot.data!.docs);

            return ListView.builder(
                itemCount: wallpapers.length,
                itemBuilder: (BuildContext context, int index) {
                  var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

                  return ListTile(
                    title: InkResponse(
                      onTap: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WallpaperGallery(
                                wallpaperList: wallpapers, initialPage: index),
                          ),
                        );
                      },

                        child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 200.0,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                wallpapers.elementAt(index).url),
                              ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                      color: Color(
                                          Theme.of(context).textTheme.caption!.color!.value ^ 0xffffff),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                                          wallpapers.elementAt(index).name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                                  fontFamily: 'LobsterTwo-Italic'
                                              ),
                                          ),

                                          IconButton(
                                            icon: Icon(
                                            wallpapers.elementAt(index).isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                              onPressed: () {
                                              if (wallpapers.elementAt(index).isFavorite) {
                                                favWallpaperManager.removeFromFav(
                                                  wallpapers.elementAt(index),
                                                );
                                              } else {
                                                favWallpaperManager.addToFav(
                                                    wallpapers.elementAt(index),
                                                );
                                              }
                                                 wallpapers.elementAt(index).isFavorite = !wallpapers.elementAt(index).isFavorite;
                                            },
                                          )
                                      ],
                                    ),
                                  ),
                              ),
                        ),
                    ),
                  );
                },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  List<Wallpaper> _getWallpapersOfCurrentCategory(
      List<DocumentSnapshot> documents) {
    var list = List<Wallpaper>.empty(growable: true);

    var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

    for (var document in documents) {
      var wallpaper = Wallpaper.fromDocumentSnapshot(document);

      if (wallpaper.category == widget.category) {
        if (favWallpaperManager.isFavorite(wallpaper)) {
          wallpaper.isFavorite = true;
        }

        list.add(wallpaper);
      }
    }

    return list;
  }
}
