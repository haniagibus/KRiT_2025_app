import 'dart:html' as html;

class FavoritesService {
  static const _key = 'favoriteEvents';

  static List<String> getFavoriteIds() {
    final stored = html.window.localStorage[_key];
    return stored?.split(',') ?? [];
  }

  static void saveFavoriteIds(List<String> ids) {
    html.window.localStorage[_key] = ids.join(',');
  }

  static bool isFavorite(String eventId) {
    return getFavoriteIds().contains(eventId);
  }

  static void toggleFavorite(String eventId) {
    final ids = getFavoriteIds();
    if (ids.contains(eventId)) {
      ids.remove(eventId);
    } else {
      ids.add(eventId);
    }
    saveFavoriteIds(ids);
  }
}
