import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/HomePage/Pet/PetDetailScreen.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

class MyPetScreen extends StatefulWidget {
  @override
  _MyPetScreenState createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("pets").where("id",isEqualTo: user.uid ).snapshots(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Pets",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
                  InkWell(child: Text("Add pet",style: Theme.of(context).textTheme.headline6.copyWith(color: Utiles.primaryBgColor),),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPetScreen()));
                  },),
                ],
              ),
            (snapshot.hasData)?(snapshot.data.documents.length==0)?NoPetwidget():Expanded(
              child: ListView(
                children: List.generate(snapshot.data.documents.length, (index) => buildSinglePetWidget(NewPet.fromJson(snapshot.data.documents[index].data),snapshot.data.documents[index]))
              ),
            ):Center(child: CircularProgressIndicator(),)
            ],
          ),
        );
      }
    );
  }


  buildSinglePetWidget(NewPet pet,snapshot)
  {
    return InkWell(

      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>PetDetailScreen(pets: pet,snapshot: snapshot,view: true,)));
      },
      child: Container(
        height: 140,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Utiles.primaryButton,width: 1),
          borderRadius: BorderRadius.circular(8)
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(pet.media),
                      placeholder : AssetImage("assets/images/dog.png",))),
            ),

            Flexible(
                flex: 4,
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pet.name,style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),),
                      InkWell(child: Text("Recent Vaccine",style: Theme.of(context).textTheme.subtitle1.copyWith(color: Utiles.primaryBgColor),),onTap: (){

                      },),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Text(pet.age,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
                  Text(pet.dob,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),


                ],
              ),
            ))
          ],
        ),

      ),
    );
  }

  NoPetwidget()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Image.asset('assets/images/dog.png',height: 100,width: 100,),
        SizedBox(height: 10,),
        Text("No Pets Added",style: Theme.of(context).textTheme.headline5.copyWith(color: Utiles.primaryButton),),
        SizedBox(height: 10,),
        Text("it Looks You Don't have Any Pets",style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black54),),
        SizedBox(height: 10,),
        FloatingActionButton(onPressed: (){},elevation: 0,backgroundColor: Utiles.primaryButton,
        child: Icon(Icons.add,color: Colors.white,size: 20,),
        )

      ],
    );
  }
}
