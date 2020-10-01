import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Search.dart';
import 'package:monkoodog/Widgets/NewsItem.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

class BlogsScreen extends StatefulWidget {
  @override
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  var scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width*.9,

            child: ListTile(
              onTap: (){
                if(blogs!=null)
                showSearch(context: context, delegate: Search(type: "blogs",suggestions: blogs));
                else
                  scaffold.currentState.showSnackBar(SnackBar(
                    backgroundColor: Utiles.primaryBgColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text("Data is loading......."),margin: EdgeInsets.symmetric(vertical: 100,horizontal: 20),));

                },
              leading: Icon(Icons.search),
              title: Text("Search"),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26,width: 1)
            ),
          ),
          Expanded(child: buildNewsPage()),
        ],
      ),
    );
  }
  List blogs;
  Widget buildNewsPage()
  {
    blogs = Provider.of<DataProvider>(context).posts;
    return (blogs==null)?Center(child: CircularProgressIndicator(),):LazyLoadScrollView(

      onEndOfPage: (){
       Provider.of<DataProvider>(context,listen: false).loadMorePosts();
     },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: blogs.length,
        itemBuilder: (context, index) => NewsItem(index, blogs,"blogs"),
      ),
    );

  }

}
