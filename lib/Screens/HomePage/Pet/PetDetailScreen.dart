import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/CustomWidgets.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Modals/vaccination.dart';
import 'package:monkoodog/Screens/HomePage/Pet/EditPetScreen.dart';
import 'package:monkoodog/utils/age.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

class PetDetailScreen extends StatefulWidget {

  final NewPet pets;
  bool view = true;
  final DocumentSnapshot snapshot;


  PetDetailScreen({this.pets, this.view, this.snapshot});

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {

  List<Vaccination> vaccination = List();
  Utiles util = Utiles();
  int year, month, date;
  DateTime dateTime = DateTime.now();
  var selectedTab = 0;
  var currentDate = "${DateTime
      .now()
      .day}";
  var currentMonth = "${DateTime
      .now()
      .month}";
  var currentYear = "${DateTime
      .now()
      .year}";
  AgeWeeks age;
  bool vac = true;


  List<bool> selected = [false,true];

  void getDob() {
    int _year = int.parse(widget.pets.dob.substring(0, 4));
    int _month = int.parse(widget.pets.dob.substring(5, 7));
    int _date = int.parse(widget.pets.dob.substring(8, 10));
    setState(() {
      year = _year;
      month = _month;
      date = _date;
    });
  }


  @override
  void initState() {
    super.initState();
    getDob();

    age = Age.weeks(
        fromDate: DateTime.parse(widget.pets.dob),
        toDate: DateTime.now(),
        includeToDate: false);
  }


  @override
  Widget build(BuildContext context) {
    vaccination = Provider.of<DataProvider>(context).vaccinations;
    return Scaffold(
      appBar: AppBar(
        actions: [
          (widget.view)?FlatButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>EditPetPage(petdate: widget.snapshot,reference: widget.snapshot.reference,)));
          }, child: Text("Edit")):SizedBox()
        ],
      ),
      body: ListView(
        children: [
          buildTopLayout(),
          SizedBox(height: 10,),
          buildToggleButton()
         , SizedBox(height: 10,),
          !widget.view?Container():ListAllVaccination(
            vaccination: vaccination,
            month: month,
            //Utiles.month(widget.pets.dob),
            date: date,
            year: year,
            age: age
                .toString()
                .substring(0, age.toString().indexOf(' ')),
            weeks: int.parse(age
                .toString()
                .substring(0, age.toString().indexOf(' '))),
            vac: selectedTab==0?false:true,
          )

                  ],
      ),

    );
  }

  Widget buildTopLayout()
  {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: 240,
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          //main b
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 110,),
                  buildHeadText("Allergies",widget.pets.allergies.length>0?widget.pets.allergies.toString().replaceAll("]", "").replaceAll("[", ""):"No Allergies"),
                  SizedBox(height: 4,),
                  buildHeadText("Diseases",widget.pets.diseases.length>0?widget.pets.diseases.toString().replaceAll("]", "").replaceAll("[", ""):"No Diseases"),
                  SizedBox(height: 4,),
                  buildHeadText("Loves",widget.pets.loves),
                ],
              ),
              height: 200,
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Utiles.primaryButton,width: 1)
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.pets.media)
                    ),
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Utiles.primaryButton,width: 1)
                  ),


                ),

                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.pets.name,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
                    SizedBox(height: 8,)
                    ,Text(Utiles.calculateAge(DateTime.parse(widget.pets.dob)),style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                    SizedBox(height: 2,),
                    Text(widget.pets.breed,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  buildHeadText(title,value)
  {
    return Row(
      children: [
        SizedBox(width: 50,),
        Flexible(
            flex: 1,
            child: Text("$title :",style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontSize: 15),textAlign: TextAlign.start,)),
        Flexible(
            flex: 1,
            child: Text("$value ",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black,fontSize: 15),textAlign: TextAlign.start)),
      ],
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
              if(selected[i])
                selectedTab =i;
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
            Text("Medication",),
            Text("Vaccination"),
          ], isSelected: selected),
    );

  }

}
