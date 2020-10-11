import 'package:flutter/material.dart';
import 'package:monkoodog/Screens/Map/PetServiceScreen.dart';
import 'package:monkoodog/utils/utiles.dart';

import 'PetFinder.dart';

class Finder extends StatefulWidget {
  @override
  _FinderState createState() => _FinderState();
}

class _FinderState extends State<Finder> {
 int currentIndex =0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FloatingActionButton(
                    backgroundColor: Utiles.primaryButton,
                    heroTag: 'sddfdfsdf',
                    mini: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  SingleButton(currentIndex==0, 'Pet Finder',0),
                  SingleButton(currentIndex==1, 'Pet Services',1),
                ],),
            ),

            Expanded(child: (currentIndex==0)?PetFinderScreen():PetServicePage())
          ],
        ),
      ),
    );
  }

  SingleButton(selected,title,int val)
  {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        child: SizedBox(
          height: 40,
          child: RaisedButton(
          color: selected?Utiles.primaryBgColor:Colors.white38,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
            onPressed: (){
              setState(() {
                currentIndex=val;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                title,
                style: TextStyle(color: selected?Colors.white:Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
