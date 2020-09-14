
class SearchPosts {
  int id;
  String title;
  String content;
  String url;

  SearchPosts({this.id, this.title, this.content});

  SearchPosts.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    content = json['ContentDetails'];
    url=json['Thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['ContentDetails'] = this.content;
    data['Thumbnail']=this.url;
    return data;
  }
}

class Title {
  String rendered;
}

class Content {
  String rendered;
}
