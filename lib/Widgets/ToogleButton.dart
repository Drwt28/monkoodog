import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToogleButtonColored extends StatefulWidget {

  List buttons;
  var onTap ;
  int selected =0;


  ToogleButtonColored({this.buttons,this.onTap,this.selected});

  @override
  _ToogleButtonColoredState createState() => _ToogleButtonColoredState();
}

class _ToogleButtonColoredState extends State<ToogleButtonColored> {
  int selected = 0;


  @override
  void initState() {
    super.initState();



    Future.delayed(Duration(milliseconds: 20)).then((value){

      selected = widget.selected??0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                constraints: BoxConstraints.expand(height: 45,width: 120),

                child: Center(child: Text(widget.buttons[0],style: TextStyle(color: selected==0?Colors.white:Colors.black),)),
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

                constraints: BoxConstraints.expand(height: 45,width: 120),
                child: Center(child: Text(widget.buttons[1],style: TextStyle(color: selected==1?Colors.white:Colors.black),)),
                color: selected==1?Colors.green:Colors.black12,
              ),
            ),
          )

        ],
      ),
    );
  }
}
