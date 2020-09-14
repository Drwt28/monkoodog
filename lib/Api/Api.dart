import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monkoodog/Modals/event.dart';
import 'package:monkoodog/Modals/news.dart';
import 'package:monkoodog/Modals/post.dart';
import 'package:monkoodog/Modals/search_posts.dart';

class Api {
//  static const ENDPOINT = 'http://monkoodog.saunitech.com/api/Custom';
  static const ENDPOINT = 'http://api.monkoodog.com/api/Custom';
  static const OTP_KEY = "313133AMrKEHQpnlJ5e1dae13P1";
  static const ENDPOINT_OTP = "http://api.msg91.com/api";
  static const TEMPLATE_ID =
      "5ea0e1bc52a1b10a4893962f"; //5e255d36d6fc0514b5638e5f";
  static const TEMPLATE_ID1 = "5eb19e91d6fc05094002abda";
  String dublicate = "Duplicate Phone number.";
  var client = new http.Client();

  Map<String, String> headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
    'authorization': 'Basic ' + base64Encode(utf8.encode('Saurabh:Saurabh@123'))
  };

//TODO implement for all POSTS, Maybe done??
  Future<List<SearchPosts>> searchPostNews(String search) async {
    var posts = List<SearchPosts>();
    var response;

    try {
      response = await client.get(
          'https://www.monkoodog.com/wp-json/wp/v2/posts?search=$search',
          headers: headers);
    } catch (e) {
      print("error" + e.toString());
    }
    if (response.statusCode == 200) {
      // parse into List
      var parsed = json.decode(response.body) as List<dynamic>;

      // loop and convert each item to Post
      for (var post in parsed) {
        posts.add(SearchPosts.fromJson(post));
      }
      return posts;
    }
    return null;
  }

/*
 * API to get Post list
 */
  Future<List<Post>> getPostList(
      int pageSize, int pageNo, int cateId, String search, token) async {
    var posts = List<Post>();
    var response;
    try {
      response = await client.get(
        //'$ENDPOINT/PostsList?PageSize=$pageSize&PageNo=$pageNo&nCategorieID=$cateId&Search=$search',
          '$ENDPOINT/List?Type=posts&PageNo=$pageNo&PageSize=$pageSize&Search=$search',
          headers: headers);
    } catch (e) {
      print("error " + e.toString());
    }
    if (response.statusCode == 200) {
      // parse into List
      print("post =>> data received: Response = " +
          response.statusCode.toString());
      var parsed = json.decode(response.body) as List<dynamic>;

      // loop and convert each item to Post
      for (var post in parsed) {
        posts.add(Post.fromJson(post));
      }
      return posts;
    }
    return null;
  }

/*
 * API to get News list TODO not getting news
 */
  Future<List<News>> getNewsList(
      int pageSize, int pageNo, int cateId, String search, token) async {
    var newsList = List<News>();
    var response;

    try {
      response = await client.get(
          '$ENDPOINT/List?Type=posts&PageNo=$pageNo&PageSize=$pageSize&Search=$search',
          headers: headers);
    } catch (e) {
      print("error" + e.toString());
    }
    print(
        "News=>> Data received\nStatus Code" + response.statusCode.toString());
    if (response.statusCode == 200) {
      // parse into List
      var parsed = json.decode(response.body) as List<dynamic>;

      // loop and convert each item to Post
      for (var news in parsed) {
        newsList.add(News.fromJson(news));
      }
      return newsList;
    }
    return null;
  }

  /*
 * API to get Event list
 */
  Future<List<Event>> getEventList(
      int pageSize, int pageNo, int cateId, String search, token) async {
    var eventList = List<Event>();
    var response;

    try {
      response = await client.get(
          '$ENDPOINT/List?Type=events&PageNo=$pageNo&PageSize=$pageSize&Search=$search',
          headers: headers);
    } catch (e) {
      print("error" + e.toString());
    }
    print("Event=>> Data received");
    if (response.statusCode == 200) {
      // parse into List
      var parsed = json.decode(response.body) as List<dynamic>;

      // loop and convert each item to Post
      for (var event in parsed) {
        eventList.add(Event.fromJson(event));
      }
      return eventList;
    }
    return null;
  }
/*
 *   API to get Pet List
 */


}
