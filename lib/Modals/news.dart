
class News {
  int id;
  String title;
  String content;
  String url;

  News({this.id, this.title, this.url});

  News.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    url = json['Thumbnail'].toString() == null
        ? "https://www.tiffanyjonesre.com/assets/images/image-not-available.jpg"
        : json['Thumbnail'];
    content = json['ContentDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Thumbnail'] = this.url;
    data['ContentDetails'] = this.content;
    return data;
  }
}

class Title {
  String rendered;
}

class Content {
  String rendered;
}
