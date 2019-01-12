enum ArticleView {
  topStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories,
}

abstract class HackerNewsInterface {
  Future<List<Map>> articles(ArticleView view, int page);
  Future<Map> comments(int id);
}
