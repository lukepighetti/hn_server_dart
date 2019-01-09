import 'hn_aqueduct.dart';

import 'src/articles_controller.dart';
import 'src/comments_controller.dart';

import 'src/hn_api.dart';

class HnAqueductChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
      (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"),
    );
  }

  @override
  Controller get entryPoint {
    final router = Router();

    final api = HNApi();
    final articles = ArticlesController(api.articles);
    final comments = CommentsController(api.comments);

    router
      ..route("/articles/:type/[:page]").link(() => articles)
      ..route("/comments/:id").link(() => comments)
      ..route("/v1/user/:id").link(() => UnsupportedController());

    return router;
  }
}

class UnsupportedController with Controller {
  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    final arguments = request.path.variables;

    return Response.ok(
      'This path is not yet supported. Your arguments were ${arguments}',
    );
  }
}
