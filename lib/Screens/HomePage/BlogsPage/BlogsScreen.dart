import 'package:flutter/material.dart';
import 'package:monkoodog/utils/utiles.dart';

class BlogsScreen extends StatefulWidget {
  @override
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Blogs Page",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Utiles.primaryButton
        ),),
      ),
    );
  }
}
