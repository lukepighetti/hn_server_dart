abstract class Article {
  int get id;
  String get url;
  String get title;
  String get domain;
  int get points;
  String get user;
  Duration get timeAgo;
  int get commentsCount;
  ArticleType get type;
}

abstract class ArticlePage implements Article {
  List<Comment> get comments;
}

abstract class Comment {
  int get id;
  Duration get timeAgo;
  String get content;

  List<Comment> get comments;
}

enum ArticleType {
  story,
  ask,
  job,
}

enum ArticleView {
  topStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories,
}
