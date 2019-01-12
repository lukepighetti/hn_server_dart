import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /articles/top/1 a list of objects with ids", () async {
    expectResponse(
      await harness.agent.get("/articles/top/1"),
      200,
      body: everyElement(contains("id")),
    );
  });

  test("GET /comments/1 returns an object with kids", () async {
    expectResponse(
      await harness.agent.get("/comments/1"),
      200,
      body: predicate<Map>((m) => List<Map>.from(m['kids']).isNotEmpty),
    );
  });

  test("GET /articles/top returns 200", () async {
    expectResponse(await harness.agent.get("/articles/top"), 200);
  });

  test("GET /articles/top/999 returns 200", () async {
    expectResponse(await harness.agent.get("/articles/top/999"), 200);
  });

  test("GET /comments/top/1 returns 404", () async {
    expectResponse(await harness.agent.get("/comments/top/1"), 404);
  });
}
