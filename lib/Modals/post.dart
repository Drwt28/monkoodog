
class Post {
  int id;
  String title;
  String content;
  String url;
  String mediaLink;

  Post({this.id, this.title, this.url});
  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaLink = "https://www.monkoodog.com/wp-json/wp/v2/media/${json["featured_media"]}";
    title = json['title']['rendered'];

    content = json['content']['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title']['rendered'] = this.title;
    data['guid']['rendered'] = this.url;
    data['content']['rendered'] = this.content;
    return data;
  }
}

class Title {
  String rendered;
}

class Content {
  String rendered;
}
