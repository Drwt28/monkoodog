import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:monkoodog/Modals/news.dart';
import 'package:monkoodog/Screens/HomePage/Newspage/NewsDetail.dart';
import 'package:monkoodog/utils/UiHelper.dart';
import 'package:html/parser.dart';

class NewsItem extends StatelessWidget {
  final int index;
  final List news;
  final type;
  const NewsItem(this.index, this.news,this.type, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsCompleteDetail(news: news[index],type: type,)));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        spreadRadius: .5,
                        blurRadius: 8,
                        offset: Offset(1, 1))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Image.network(
                      news[index].url != null
                          ? news[index].url
                          : UIHelper.url_no_img,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _parse(news[index].title),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: UIHelper.fontSizeHeading,
                              fontWeight: FontWeight.w800),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _parse(news[index].content),
                      style: TextStyle(fontSize: UIHelper.fontSizeContent),
                      maxLines: 5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton.icon(
                        label: Text("Share"),
                        onPressed: () {
                          FlutterShareMe().shareToSystem(
                              msg: 'https://www.monkoodog.com/' +
                                  news[index]
                                      .title
                                      .replaceAll(' ', '-')
                                      .toString()
                                      .toLowerCase());
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _parse(String htmlString) {
    var doc = parse(htmlString);
    String parsed = parse(doc.body.text).documentElement.text;
    return parsed;
  }
}
