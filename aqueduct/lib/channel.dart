import 'package:aqueduct/aqueduct.dart';

import 'controllers/articles.dart';
import 'controllers/comments.dart';
import 'services/hacker_news_api.dart';

import 'classes.dart';

class HnAqueductChannel extends ApplicationChannel {
  HackerNewsInterface api = HackerNewsApi();

  @override
  Future prepare() async {
    logger.onRecord.listen(
      (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"),
    );
  }

  @override
  Controller get entryPoint {
    final router = Router();

    final articles = ArticlesController(api.articles);
    final comments = CommentsController(api.comments);

    router
      ..route("/articles/:type/[:page]").link(() => articles)
      ..route("/comments/:id").link(() => comments);

    return router;
  }
}
