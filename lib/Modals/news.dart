
class News {
  int id;
  String title;
  String content;
  String url;
  String mediaLink;

  News({this.id, this.title, this.url});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['content'] = this.content;
    return data;
  }
}

class Title {
  String rendered;
}

class Content {
  String rendered;
}
