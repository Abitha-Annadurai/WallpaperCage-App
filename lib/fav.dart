
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpapercage/providers/fav_wallpaper_manager.dart';
import 'package:wallpapercage/wallpaper_gallery.dart';

import 'models/wallpaper.dart';

class Favorite extends StatefulWidget {
  final List<Wallpaper> wallpapersList;

  const Favorite({Key? key, required this.wallpapersList}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    var wallpapers = widget.wallpapersList.where((wallpaper) => wallpaper.isFavorite).toList();

    return ListView.builder(
        itemCount: wallpapers.length,
        itemBuilder: (BuildContext context, int index) {
      var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

      return ListTile(
        title: InkResponse(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
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
                  borderRadius: BorderRadius.circular(20.0),
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
                        color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text(
                                    wallpapers.elementAt(index).name,
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'LobsterTwo-Italic'
                                        ),
                                   ),

                                IconButton(
                                   icon: Icon(
                                     wallpapers.elementAt(index).isFavorite ? Icons.favorite : Icons.favorite_border,
                                     color: Colors.green,
                                   ),

                                  onPressed: () {
                                     if (wallpapers.elementAt(index).isFavorite) {
                                       favWallpaperManager.removeFromFav(wallpapers.elementAt(index),
                                       );
                                     } else {
                                       favWallpaperManager.addToFav(wallpapers.elementAt(index),
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
  }
}
