import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/Api/Api.dart';
import 'package:monkoodog/Modals/news.dart';
import 'package:monkoodog/Screens/HomePage/Newspage/NewsDetail.dart';
import 'package:monkoodog/utils/utiles.dart';

class Search extends SearchDelegate{

  List<News> suggestions;
  String type;
  Search({this.type,this.suggestions});
  Api api = Api();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(icon: Icon(Icons.arrow_back),color: Utiles.primaryButton,onPressed: (){
      Navigator.pop(context);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {


    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return (snapshot.data==null)?Center(child: CircularProgressIndicator(),):ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index)=>Card(
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            child: ListTile(
              onTap: (){
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>NewsCompleteDetail(news: snapshot.data[index],type: type,)));
              },
              title: Text(snapshot.data[index].title),)));
      }
    );
  }

  getData()
 async {
    var list = await api.search(query.trim(), type);
    return list;
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    var list = suggestions.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index)=>Card(
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: ListTile(
          onTap: (){
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>NewsCompleteDetail(news: list[index],type: type,)));
          },
          title: Text(list[index].title),)));
  }



}