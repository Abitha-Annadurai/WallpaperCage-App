
import 'package:cloud_firestore/cloud_firestore.dart';

class Wallpaper {
  final String url;
  final String category;
  final String name;
  final String id;
  bool isFavorite;

  Wallpaper({
    required this.url,
    required this.category,
    required this.name,
    required this.id,
    this.isFavorite=false
  });

  factory Wallpaper.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Wallpaper(
      url: snapshot.get('url'),
      category: snapshot.get('tag'),
      name: snapshot.get('name'),
      id: snapshot.id,
    );
  }

}