import 'package:http/http.dart';
import 'dart:convert';
import 'cache.dart';
import 'package:hn_shared/hn_shared.dart';

import 'articles_controller.dart' show HNApi;

class HNService implements HNApi {
  final viewCache = Cache<ArticleView, List<int>>();
  final articleCache = Cache<int, Map>();
  final itemCache = Cache<int, Map>();

  @override
  Future<List<int>> articles(ArticleView view, int page) async {
    final idsPath = _viewToPath(view);
    final fetchIds = _get(idsPath).then((r) => List<int>.from(r));
    final itemIds = await fetchIds;
    // final itemIds = await viewCache.fetch(view, fetchIds);

    print(itemIds);
    // final paginatedIds = itemIds.sublist(30 * (page - 1), 30 * page);

    return itemIds;
  }

  Future<dynamic> _get(String path) async {
    final response = await get('https://hacker-news.firebaseio.com/v0/$path.json');
    return jsonDecode(response.body);
  }

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
