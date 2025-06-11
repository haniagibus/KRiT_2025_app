import 'dart:html' as html;
import 'package:flutter/material.dart';

// class FavoritesService extends ChangeNotifier{
//   static const _key = 'favoriteEvents';
//
//   static List<String> getFavoriteIds() {
//     final stored = html.window.localStorage[_key];
//     return stored?.split(',') ?? [];
//   }
//
//   static void saveFavoriteIds(List<String> ids) {
//     html.window.localStorage[_key] = ids.join(',');
//   }
//
//   static bool isFavorite(String eventId) {
//     return getFavoriteIds().contains(eventId);
//   }
//
//   static void toggleFavorite(String eventId) {
//     final ids = getFavoriteIds();
//     if (ids.contains(eventId)) {
//       ids.remove(eventId);
//     } else {
//       ids.add(eventId);
//     }
//     saveFavoriteIds(ids);
//   }
// }

class FavoritesService extends ChangeNotifier {
  static const _key = 'favoriteEvents';

  late List<String> _favoriteIds;

  FavoritesService() {
    final stored = html.window.localStorage[_key];
    _favoriteIds = stored?.split(',') ?? [];
  }

  bool isFavorite(String eventId) => _favoriteIds.contains(eventId);

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  void toggleFavorite(String eventId) {
    if (_favoriteIds.contains(eventId)) {
      _favoriteIds.remove(eventId);
    } else {
      _favoriteIds.add(eventId);
    }
    _save();
    notifyListeners();
  }

  void _save() {
    html.window.localStorage[_key] = _favoriteIds.join(',');
  }
}

