import 'dart:math' as math;
import 'dart:convert';

import 'package:http/http.dart';

import '../hn_aqueduct.dart';
import 'cache.dart';

class HNApi {
  final viewCache = Cache<ArticleView, String>();
  final itemCache = Cache<int, String>();

  /// Return a list of articles. Cached.
  Future<List<Map>> articles(ArticleView view, int page) async {
    final ids = await _getArticleIds(view);
    final paginatedIds = _paginate<int>(ids, page);
    final items = await _getItems(paginatedIds, showKids: false);
    return items;
  }

  Future<Map> comments(int id) async {
    Future<Map> _fetchKids(Map map) async {
      final kids = map['kids'];

      if (kids != null) {
        final ids = List<int>.from(kids);
        final items = await _getItems(ids);
        final futures = items.map((m) => _fetchKids(m));
        map['kids'] = await Future.wait<Map>(futures);
      }

      return map;
    }

    final page =
        await _getItems([id]).then((r) => r.first).then((page) => _fetchKids(page));

    return page;
  }

  /// A helper function to get from Hacker News and decode JSON
  Future<String> _get(String path) =>
      get('https://hacker-news.firebaseio.com/v0/$path.json').then((r) => r.body);

  /// Retreive the list of article ids based on the view
  /// maximum response is 500 items. Auto caching with ArticleView as keys.
  Future<List<int>> _getArticleIds(ArticleView view) async {
    final fetchJson = _get(_viewToPath(view));
    final result = await viewCache.fetch(view, fetchJson);
    final ids = List<int>.from(jsonDecode(result));

    return ids;
  }

  /// Retreive a list of items from our memoized automatic cache
  Future<List<Map>> _getItems(List<int> ids, {bool showKids = true}) async {
    final getJson = (int id) => _get("item/$id");

    final futures = ids.map((id) => itemCache.fetch(id, getJson(id)));
    final results = await Future.wait<String>(futures);
    final maps = results.map((json) => Map.from(jsonDecode(json))).toList();

    if (!showKids) {
      maps.forEach((m) => m.remove("kids"));
    }

    /// break map association?
    return maps;
  }

  /// Handle pagination of a list. Should return an empty list
  /// if we're out of range. Manually tested.
  List<T> _paginate<T>(List<T> items, int page) {
    const pageSize = 30;

    if (page > (items.length / pageSize).ceil()) {
      return [];
    }

    return items.sublist(
      pageSize * (page - 1),
      math.min(pageSize * (page), items.length),
    );
  }

  /// Convert the ArticleView enum to the appropriate
  /// HackerNews endpoint path
  String _viewToPath(ArticleView view) {
    switch (view) {
      case ArticleView.askStories:
        return "askstories";
      case ArticleView.bestStories:
        return "beststories";
      case ArticleView.jobStories:
        return "jobstories";
      case ArticleView.newStories:
        return "newstories";
      case ArticleView.showStories:
        return "showstories";
      case ArticleView.topStories:
        return "topstories";
      default:
        return null;
    }
  }
}
