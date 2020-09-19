import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Widgets/NewsItem.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

class BlogsScreen extends StatefulWidget {
  @override
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return buildNewsPage();
  }
  List blogs;
  buildNewsPage()
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
