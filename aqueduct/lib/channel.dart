import 'hn_aqueduct.dart';
import 'src/articles_controller.dart';

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

    router
      ..route("/articles/:type").link(() => ArticlesController())
      ..route("/comments/:id").link(() => UnsupportedController())
      ..route("/user/:id").link(() => UnsupportedController());

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
