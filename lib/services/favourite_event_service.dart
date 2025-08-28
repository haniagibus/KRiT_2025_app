import 'dart:html' as html;
import 'package:flutter/material.dart';

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

