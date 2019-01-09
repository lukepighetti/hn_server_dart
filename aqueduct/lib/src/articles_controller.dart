import '../hn_aqueduct.dart';

class ArticlesController extends Controller {
  final HNApi api;

  ArticlesController(this.api);

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    final type = request.path.variables['type'];
    final view = _typeToView(type);

    if (view == null) {
      return Response.notFound(
        body: {"error": "view must be top, new, best, ask show, job"},
      );
    }

    String page = request.path.variables['page'];

    if (page == null || page.isEmpty) {
      page = "1";
    }

    final response = await api.articles(view, int.parse(page));
    return Response.ok(response);
  }

  ArticleView _typeToView(String type) {
    final Map<String, ArticleView> map = {
      "top": ArticleView.topStories,
      "new": ArticleView.newStories,
      "best": ArticleView.bestStories,
      "ask": ArticleView.askStories,
      "show": ArticleView.showStories,
      "job": ArticleView.jobStories,
    };

    return map[type];
  }
}

abstract class HNApi {
  Future<List<int>> articles(ArticleView view, int page);
  // Future<List<Map>> comments(ArticleView view, int page);
}
