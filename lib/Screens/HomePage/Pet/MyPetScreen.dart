import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Modals/vaccination.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/HomePage/Pet/PetDetailScreen.dart';
import 'package:monkoodog/utils/age.dart';
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
        stream: Firestore.instance
            .collection("pets")
            .where("id", isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? (snapshot.data.documents.length == 0)
                  ? NoPetwidget()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Pets",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: Colors.black),
                              ),
                              InkWell(
                                child: Text(
                                  "Add pet",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Utiles.primaryBgColor),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddPetScreen()));
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: AnimationLimiter(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  children: List.generate(
                                      snapshot.data.documents.length,
                                      (index) =>
                                          AnimationConfiguration.staggeredList(
                                            position: index,
                                            duration:
                                                Duration(milliseconds: 400),
                                            child: SlideAnimation(
                                              verticalOffset: 50,
                                              child: FadeInAnimation(
                                                child: buildSinglePetWidget(
                                                    NewPet.fromJson(snapshot
                                                        .data
                                                        .documents[index]
                                                        .data),
                                                    snapshot
                                                        .data.documents[index]),
                                              ),
                                            ),
                                          ))),
                            ),
                          )
                        ],
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget buildSinglePetWidget(NewPet pet, snapshot) {
    int year = int.parse(pet.dob.substring(0, 4));
    int month = int.parse(pet.dob.substring(5, 7));
    int date = int.parse(pet.dob.substring(8, 10));
    var age = Age.weeks(
        fromDate: DateTime.parse(pet.dob),
        toDate: DateTime.now(),
        includeToDate: false);
    var weeks =
        int.parse(age.toString().substring(0, age.toString().indexOf(' ')));
    List<Vaccination> vaccination =
        Provider.of<DataProvider>(context).vaccinations;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PetDetailScreen(
                      pets: pet,
                      snapshot: snapshot,
                      view: true,
                    )));
      },
      child: Container(
        height: 140,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.orange[200], spreadRadius: 1, blurRadius: 2)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        child: FadeInImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(pet.media),
                            placeholder: AssetImage(
                              "assets/images/dog.png",
                            )),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(1),
                              child:
                                  (pet.gender.toLowerCase().contains("female"))
                                      ? Icon(
                                          FontAwesomeIcons.venus,
                                          color: Colors.pink,
                                        )
                                      : Icon(
                                          FontAwesomeIcons.mars,
                                          color: Colors.orange,
                                        )))
                    ],
                  )),
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
                          Text(
                            pet.name,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Utiles.primaryButton),
                                  color: Colors.orange[200]),
                              child: Text(
                                "Recent Vaccine",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Utiles.primaryButton,
                                        fontSize: 14),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Utiles.calculateAge(DateTime.parse(pet.dob)),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        pet.primaryBreed,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  NoPetwidget() {
    return Center(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: -100,
                    child: ScaleAnimation(
                      child: widget,
                    )),
                children: [
                  Image.asset(
                    'assets/images/dog.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No Pets Added",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Utiles.primaryButton),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "it Looks You Don't have Any Pets",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPetScreen()));
                    },
                    elevation: 0,
                    backgroundColor: Utiles.primaryButton,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
