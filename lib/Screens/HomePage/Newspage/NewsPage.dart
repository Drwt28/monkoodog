import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Search.dart';
import 'package:monkoodog/Widgets/NewsItem.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';
import 'package:monkoodog/Animation/FadeAnimation.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  AnimationController fadeAnimationController;

  Animation<Transform> animation;

  List<bool> selected = [true, false];
  var scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              child: ListTile(
                onTap: () {
                  if (isNews ? news != null : events != null)
                    showSearch(
                        context: context,
                        delegate: Search(
                            type: isNews ? "news" : "events",
                            suggestions: isNews ? news : events));
                  else
                    scaffold.currentState.showSnackBar(SnackBar(
                      backgroundColor: Utiles.primaryBgColor,
                      behavior: SnackBarBehavior.floating,
                      content: Text("Data is loading......."),
                      margin:
                          EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                    ));
                },
                leading: Icon(Icons.search),
                title: Text("Search"),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26, width: 1)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildToggleButton(),
          SizedBox(
            height: 10,
          ),
          (isNews) ? buildNewsPage() : buildEvents()
        ],
      ),
    );
  }

  List news, events;

  buildNewsPage() {
    news = Provider.of<DataProvider>(context).news;

    return (news == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: news.length,
            itemBuilder: (context, index) => NewsItem(index, news, "news"),
          );
  }

  buildEvents() {
    events = Provider.of<DataProvider>(context).events;

    return (events == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) => NewsItem(index, events, "events"),
          );
  }

  bool isNews = true;

  buildToggleButton() {
    return Center(
      child: ToggleButtons(
          onPressed: (val) {
            for (int i = 0; i < selected.length; i++) {
              selected[i] = !selected[i];
            }
            isNews = selected[0];
            setState(() {});
          },
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width * .45, height: 40),
          fillColor: Utiles.primaryButton,
          borderColor: Utiles.primaryButton,
          selectedColor: Colors.white,
          borderRadius: BorderRadius.circular(4),
          children: [
            Text(
              "News",
            ),
            Text("Events"),
          ],
          isSelected: selected),
    );
  }
}
