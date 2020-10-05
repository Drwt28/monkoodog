import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToogleButtonColored extends StatefulWidget {

  List buttons;
  var onTap ;


  ToogleButtonColored({this.buttons,this.onTap});

  @override
  _ToogleButtonColoredState createState() => _ToogleButtonColoredState();
}

class _ToogleButtonColoredState extends State<ToogleButtonColored> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          InkWell(
            onTap: (){

              selected = 0;
              setState(() {

              });
              widget.onTap(selected);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 14),
                child: Text(widget.buttons[0],style: TextStyle(color: selected==0?Colors.white:Colors.black),),
                color: selected==0?Colors.green:Colors.black12,
              ),
            ),
          )
,
          SizedBox(width: 10,),
          InkWell(
            onTap: (){

              selected = 1;
              setState(() {

              });
              widget.onTap(selected);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(

                  padding: EdgeInsets.symmetric(horizontal: 25,vertical: 14),
                child: Text(widget.buttons[1],style: TextStyle(color: selected==1?Colors.white:Colors.black),),
                color: selected==1?Colors.green:Colors.black12,
              ),
            ),
          )

        ],
      ),
    );
  }
}
