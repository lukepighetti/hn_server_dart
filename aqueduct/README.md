# Hacker News API

The goal of this API is to provide the exact same data structure as the official Hacker News API but to perform the notorious nested fetching while providing a memoized cache of items.

Dockerized specifically for use with [opeNode](https://openode.io), a wonderful, low cost, Docker container host.


## Articles

#### `https://hn-dart-api.openode.io/articles/:type/[:page]` [example](https://hn-dart-api.openode.io/articles/top/1)

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

#### `https://hn-dart-api.openode.io/comments/:id` [example](https://hn-dart-api.openode.io/comments/1)

**:id** is the id of the item to fetch along with its comments (kids). Any item id can be used, including a sub-comment to get a sub-list of kids.

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
