import 'package:hn_aqueduct/channel.dart';
import 'package:hn_aqueduct/classes.dart';

import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:hn_aqueduct/hn_aqueduct.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for hn_aqueduct.
///
/// A harness for testing an aqueduct application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<HnAqueductChannel> {
  @override
  Future onSetUp() async {
    channel.api = HackerNewsTest();
  }

  @override
  Future onTearDown() async {}
}

class HackerNewsTest implements HackerNewsInterface {
  //
  @override
  Future<List<Map>> articles(ArticleView view, int page) {
    // TODO: implement articles
    return null;
  }

  @override
  Future<Map> comments(int id) {
    // TODO: implement comments
    return null;
  }
}
