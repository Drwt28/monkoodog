import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/utils/utiles.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {


  List<bool> selected = [true,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          SizedBox(height: 10,)
          ,Center(
            child: Container(
              width: MediaQuery.of(context).size.width*.9,

              child: ListTile(
                onTap: (){},
                leading: Icon(Icons.search),
                title: Text("Search"),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26,width: 1)
              ),
            ),
          ),
          SizedBox(height: 10,),
          buildToggleButton()
          , SizedBox(height: 10,),
        ],
      ),
    );
  }
  buildToggleButton()
  {
    return Center(
      child: ToggleButtons(
          onPressed: (val){
            for(int i = 0 ; i < selected.length;i++)
            {
              selected[i] = !selected[i];
            }
            setState(() {

            });
          },
          constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width*.45,height: 40),
          fillColor: Utiles.primaryButton,
          borderColor: Utiles.primaryButton,
          selectedColor: Colors.white,
          borderRadius: BorderRadius.circular(4),

          children:[
            Text("News",),
            Text("Events"),
          ], isSelected: selected),
    );

  }

}
