import '../hn_aqueduct.dart';

class CommentsController extends Controller {
  final Future<Map> Function(int id) comments;

  CommentsController(this.comments);

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    final id = request.path.variables['id'];

    if (id == null || id.isEmpty) {
      return Response.notFound(
        body: {"error": "please provide an id"},
      );
    }

    final response = await comments(int.parse(id));
    return Response.ok(response);
  }
}
