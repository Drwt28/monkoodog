import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_properties.dart';

import 'package:monkoodog/Modals/news.dart';
import 'package:monkoodog/utils/UiHelper.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

class NewsCompleteDetail extends StatefulWidget {
  final  news;
  final type;
  NewsCompleteDetail({this.news,this.type});
  @override
  _NewsCompleteDetailState createState() => _NewsCompleteDetailState();
}

class _NewsCompleteDetailState extends State<NewsCompleteDetail> {
  Color black = Colors.black;
  double fontsizeLarge = 20;

  String _parse(String htmlString) {
    var doc = parse(htmlString);
    String parsed = parse(doc.body.text).documentElement.text;
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Utiles.primaryBgColor,
//        backgroundColor: Colors.transparent,
        title: Text(
          widget.type,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: UIHelper.offBlack.withOpacity(.2),
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ],
          ),
        ),
        actions: [
          FlatButton.icon(
            icon: Icon(
              Icons.share,
              color: Colors.white,
              size: 19,
            ),
            label: Text(
              "Share",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: UIHelper.offBlack.withOpacity(.2),
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  )
                ],
              ),
            ),
            onPressed: () {
              // FlutterShareMe().shareToSystem(
              //     msg: 'https://www.monkoodog.com/' +
              //         widget.news.title
              //             .replaceAll(' ', '-')
              //             .toString()
              //             .toLowerCase());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.transparent,
              onPressed: () {},
            ),
          ],
        ),
        color: Utiles.primaryBgColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.network(
                        widget.news.url != null
                            ? widget.news.url
                            : "https://www.tiffanyjonesre.com/assets/images/image-not-available.jpg",
                        height: MediaQuery.of(context).size.width / 2,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _parse(widget.news.title),
                        style: TextStyle(
                            fontSize: fontsizeLarge,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ),
                    Html(
                      data: widget.news.content,
                      renderNewlines: true,
                      linkStyle: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic),
                      onImageTap: (image) {
                        print(image);
                      },
                      showImages: true,
                      imageProperties: ImageProperties(
                        fit: BoxFit.cover,
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                      ),
                      onLinkTap: (link) async {
                        var uri = link;
                        if (await canLaunch(uri)) {
                          launch(uri);
                        } else {
                          print("Cant  Do   IT");
                        }
                      },
                      useRichText: true,
                      defaultTextStyle: TextStyle(fontSize: 18),
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    ),
                  ],
                ),
                /*  Container(padding: EdgeInsets.all(8),
                        child: Icon(Icons.favorite,color: Colors.white,),alignment: Alignment.topRight,)*/
              ],
            )
          ],
        ),
      ),
    );
  }
}
