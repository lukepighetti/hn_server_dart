import '../hn_aqueduct.dart';

class ArticlesController extends Controller {
  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    final type = request.path.variables['type'];

    final endpoints = {
      "top": "topStories",
      "new": "newStories",
      "show": "showStories",
      "ask": "showStories",
      "job": "jobStories",
      "best": "bestStories"
    };

    final endpoint = endpoints[type];

    if (endpoint == null) {
      return Response.notFound(body: "type $type is not supported");
    }

    return Response.ok("you requested type ${endpoint}");
  }
}
