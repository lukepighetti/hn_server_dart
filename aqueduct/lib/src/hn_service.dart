import 'dart:math' as math;
import 'dart:convert';

import 'package:http/http.dart';
import 'package:hn_shared/hn_shared.dart';

import 'articles_controller.dart' show HNApi;
import 'cache.dart';

class HNService implements HNApi {
  final viewCache = Cache<ArticleView, List<int>>();
  final articleCache = Cache<int, Map>();
  final itemCache = Cache<int, Map>();

  @override
  Future<List<int>> articles(ArticleView view, int page) async {
    final ids = await _getArticleIds(view);

    return _paginate<int>(ids, page);
  }

  /// A helper function to get from Hacker News and decode JSON
  Future<dynamic> _get(String path) async {
    final response = await get('https://hacker-news.firebaseio.com/v0/$path.json');
    return jsonDecode(response.body);
  }

  /// Retreive the list of article ids based on the view
  /// maximum response is 500 items. Auto caching with ArticleView as keys.
  Future<List<int>> _getArticleIds(ArticleView view) async {
    final idsPath = _viewToPath(view);
    final fetchIds = _get(idsPath).then((r) => List<int>.from(r));
    final itemIds = await viewCache.fetch(view, fetchIds);

    return itemIds;
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
