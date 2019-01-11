# Hacker News API

The goal of this API is to provide the exact same data structure as the official Hacker News API but to perform the notorious nested fetching while providing a memoized cache of items.

Dockerized specifically for use with [opeNode](https://openode.io), a wonderful, low cost, Docker container host.


## Articles

#### `http://hn-dart-api.openode.io/articles/:type/[:page]` [example](http://hn-dart-api.openode.io/articles/top/1)

**:type** is `top`, `new`, `best`, `ask`, `show`, `job`

**:page** is the page with a maximum of 17

Response

```
type Response = {
  "by": string,
  "descendants": int,
  "id": int,
  "score": int,
  "time": secondsSinceEpoch,
  "title": string,
  "type": string,
  "url": url,
}[]
```

## Comments

#### `http://hn-dart-api.openode.io/comments/:id` [example](http://hn-dart-api.openode.io/comments/1)

**:id** is the id of the item you wish you view the comments (kids) for. You can even put a comment id in to get the comments for that id.

Response

```
type Response = {
  "by": string,
  "descendants": int,
  "id": int,
  "score": int,
  "time": secondsSinceEpoch,
  "title": string,
  "type": string,
  "url": url,
  "kids": Comment[],
}[]

type Comment = {
  "by": string,
  "id": int,
  "parent": int,
  "text": string,
  "time": secondsSinceEpoch,
  "type": "comment"
  "kids": Comment[],
}
```
