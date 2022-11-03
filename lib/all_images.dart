
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpapercage/wallpaper_gallery.dart';

import 'models/wallpaper.dart';

class AllImages extends StatefulWidget {
  final List<Wallpaper> wallpapersList;

  const AllImages({Key? key, required this.wallpapersList}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {

          return GridView.builder(
              itemCount: widget.wallpapersList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.all(2),
                  child: GridTile(
                    child: InkResponse(
                      onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                         return WallpaperGallery(
                           wallpaperList: widget.wallpapersList,
                           initialPage: index,
                         );},
                    ),);},
                          child: CachedNetworkImage(
                            imageUrl: widget.wallpapersList.elementAt(index).url,
                             fit: BoxFit.cover,
                          ),
                    ),
                  ),
                );},
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          );

  }
}
