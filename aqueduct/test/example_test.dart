import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /articles/top returns 200", () async {
    expectResponse(await harness.agent.get("/articles/top"), 200);
  });

  test("GET /articles/top/1 returns 200", () async {
    expectResponse(await harness.agent.get("/articles/top/1"), 200);
  });

  test("GET /comments/top/1 returns 404", () async {
    expectResponse(await harness.agent.get("/comments/top/1"), 404);
  });
}
