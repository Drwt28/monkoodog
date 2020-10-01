import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:monkoodog/Modals/NewPet.dart';

import 'package:monkoodog/utils/age.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

//import 'package:monkoodog/core/models/alergies.dart';
//import 'package:monkoodog/core/models/disease.dart';

import 'package:monkoodog/utils/utiles.dart';
import 'package:location/location.dart';
import 'package:html/parser.dart';

class EditPetPage extends StatefulWidget {

  final DocumentSnapshot petdate;
  final DocumentReference reference;

  EditPetPage({this.petdate, this.reference});

  @override
  _EditPetPageState createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  var petNameController = TextEditingController();
  var breedController = TextEditingController();
  var primaryController = TextEditingController();
  var secondaryController = TextEditingController();

  List breeds;
  var loading = false;
  String gender;
  String agePet;
  String weeks;
  var focusNode = FocusNode();
  int breedNum;
  String breedTypePure, breedTypeMix;
  Color color1 = Colors.black;
  bool imageExists = false;
  Color color2 = Colors.blue;

  var petData = Map<String, dynamic>();
  var petDataImg = Map<String, dynamic>();
  var globalKey = GlobalKey<FormState>();
  double spaceBtnColumn = 20;
  bool isImg = false;
  NewPet pet;

  int _radioValue1, _radioValue2;
  bool checkboxValue = true;
  File pfImage;
  DateTime dateTime;
  var imageUrl;

  Future changeImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    petData['media'] = imageUrl.toString();
    setState(() {
      pfImage = image;
      imageExists = true;
      showDialog(
          useSafeArea: true,
          barrierDismissible: false,
          context: context,
          useRootNavigator: false,
          child: AlertDialog(
            title: Image.asset(
              'assets/images/pet_vector.png',
              height: 90,
              width: 90,
            ),
            content: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
                Text(
                  "Image is Uploading Please wait....",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.black),
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ));
    });
    var storage = FirebaseStorage.instance.ref();

    var uploadTask = storage
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(pfImage);

    imageUrl = (await (await uploadTask.onComplete).ref.getDownloadURL());
    setState(() {});
    Navigator.pop(context);
  }

  String loc = '';
  bool showLocWarn = false;
  double lat, long;

  String _parse(String htmlString) {
    var doc = parse(htmlString);
    String parsed = parse(doc.body.text).documentElement.text;
    return parsed;
  }

  @override
  void dispose() {
    super.dispose();
    petNameController.dispose();
    breedController.dispose();
    primaryController.dispose();
    secondaryController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBreeds();
    getPet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_key,
      resizeToAvoidBottomPadding: false,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Utiles.primaryBgColor,
        title: Text(
          "Edit Pet",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.transparent,
              onPressed: () {},
            ),
          ],
        ),
        color: Utiles.primaryBgColor,
      ),
      body: Builder(
        builder: (context) => loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      showLocWarn
                          ? Center(
                              child: Text(
                                "Location Is Neceessary to add pet!!!",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          changeImage();
                        },
                        child: Stack(children: <Widget>[
                          CircleAvatar(
                            radius: 80.0,
                            backgroundImage: pfImage != null
                                ? FileImage(pfImage)
                                : NetworkImage(
                                    pet.media,
                                  ),
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            bottom: 15,
                            right: 15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                color: Colors.grey[600],
                                child: Icon(CupertinoIcons.pencil,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Form(
                          key: globalKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child:TextFormField(
                                    validator: (val)=>val.isEmpty?"Enter Pet Name":null,
                                    controller: petNameController,
                                    focusNode: focusNode,
                                    decoration:
                                    InputDecoration(hintText: "Enter Name"),
                                  ),
                                ),
                                buildRadioWidget("Gender", "Male", "Female",
                                    _radioValue1, _handleRadioValueChange1),
                                buildRadioWidget("Breed Type", "Pure", "Mix",
                                    _radioValue2, _handleRadioValueChange2),
                                Visibility(
                                  visible: isPureSelected ? true : false,
                                  child: Card(
                                    child: ListTile(
                                      trailing: Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                      title: Text(selectedPrimaryBreed == null
                                          ? "Choose Primary Breed"
                                          : selectedPrimaryBreed),
                                      onTap: () {
                                        buildSearchBottomSheet(true);
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isMixed ? true : false,
                                  child: Card(
                                    child: ListTile(
                                      trailing: Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                      title: Text(selectedPrimaryBreed == null
                                          ? "Choose Primary Breed"
                                          : selectedPrimaryBreed),
                                      onTap: () {
                                        buildSearchBottomSheet(true);
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isMixed ? false : true,
                                  child: Card(
                                    child: ListTile(
                                      trailing: Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                      title: Text(selectedSecondaryBreed == null
                                          ? "Choose Secondary Breed"
                                          : selectedSecondaryBreed),
                                      onTap: () {
                                        buildSearchBottomSheet(false);
                                      },
                                    ),
                                  ),
                                ),
                                Card(
                                  child: FlatButton(
                                      onPressed: () {
                                        var date = DateTime.now();
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime(
                                                    date.year - 9,
                                                    date.month - 3,
                                                    date.day - 5),
                                                firstDate: DateTime(
                                                    date.year - 9,
                                                    date.month - 3,
                                                    date.day - 5),
                                                lastDate: date)
                                            .then((value) => {
                                                  setState(() {
                                                    dateTime = date;
                                                    AgeWeeks age = Age.weeks(
                                                        fromDate: dateTime,
                                                        toDate: DateTime.now(),
                                                        includeToDate: false);
                                                    print("$age");

                                                    weeks = age.toString();
                                                    print('\n$weeks');
                                                    agePet =
                                                        Utiles.calculateAge(
                                                            dateTime);
                                                    print(
                                                        'agePet is $agePet,and dateTime is=$dateTime ');
                                                  })
                                                });
                                        // DatePicker.showDatePicker(context,
                                        //     showTitleActions: true,
                                        //     minTime: DateTime(2011, 3, 5),
                                        //     maxTime: DateTime.now(),
                                        //     onChanged: (date) {},
                                        //     onConfirm: (date) {
                                        //       setState(() {
                                        //         dateTime = date;
                                        //         AgeWeeks age = Age.weeks(
                                        //             fromDate: dateTime,
                                        //             toDate: DateTime.now(),
                                        //             includeToDate: false);
                                        //         print("$age");
                                        //
                                        //         weeks = age.toString();
                                        //         print('\n$weeks');
                                        //         agePet =
                                        //             Utiles.calculateAge(dateTime);
                                        //         print(
                                        //             'agePet is $agePet,and dateTime is=$dateTime ');
                                        //       });
                                        //     },
                                        //     currentTime: DateTime.now(),
                                        //     locale: LocaleType.en);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            NewPet.fromJson(widget.petdate.data)
                                                .dob,
                                            style:
                                                new TextStyle(fontSize: 16.0),
                                          ),
                                          dateTime == null
                                              ? Row(
                                                  children: [
                                                    Icon(Icons.calendar_today),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(Icons.star,
                                                        color: Colors.red,
                                                        size: 12),
                                                  ],
                                                )
                                              : Text(
                                                  dateTime
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: new TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                          color: Utiles.primaryButton,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            "Update",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (loc != '' && loc.contains(',')) {
                              setState(() {
                                showLocWarn = false;
                              });

                              if (_radioValue1 == null ||
                                  _radioValue2 == null) {
                                String msg;
                                if (_radioValue1 == null)
                                  msg = "Please select Gender";
                                if (_radioValue2 == null)
                                  msg = "Please select Breed type";
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("$msg"),
                                ));
                              }
                              if (globalKey.currentState.validate() &&
                                  _radioValue1 != null &&
                                  _radioValue2 != null) {
                                print(
                                    "=>>>>>>>>>>>>>>>>>>>>>>>>>>             Ok to go       >>>>>>>>>>>>>");

                                //adding Image to firebase storage

                                setState(() {
                                  loading = true;
                                });
                                if (pfImage != null) {
                                  petData['media'] = imageUrl;
                                }

                                petData['pet_name'] = petNameController.text;
                                petData['breed_type'] = isPureSelected ? 1 : 2;
                                petData['breed'] = selectedPrimaryBreed;
                                petData['pet_gender'] =
                                    gender != null ? gender : "";
                                petData['age'] = pet.age;
                                petData['dob'] = pet.dob;

                                petData['pure_breed_type'] =
                                    selectedPrimaryBreed;
                                petData['latitude'] = lat;
                                petData['longitude'] = long;
                                petData['mix_breed_type'] =
                                    selectedSecondaryBreed;
                                // petData['age'] = agePet != null ? agePet : "";

                                //Update
                                var user =
                                    await FirebaseAuth.instance.currentUser();
                                petData["userId"] = user.uid;

                                setState(() {
                                  loading = false;
                                });

//                            String endpoint = 'pet_name=' +
//                                petData['pet_name'] +
//                                '&pet_gender=' +
//                                petData['pet_gender'] +
//                                '&dob=' +
//                                petData['dob'] +
//                                '&breed_type=' +
//                                petData['breed_type'].toString() +
//                                '&breed=' +
//                                petData['breed'] +
//                                '&number=' +
//                                petData['number'] +
//                                '&lat=' +
//                                petData['latitude'].toString() +
//                                '&lon=' +
//                                petData['longitude'].toString() +
//                                '&email=' +
//                                petData['email'] +
//                                '&primary_breed=' +
//                                petData['pure_breed_type'] +
//                                '&secondary_breed=' +
//                                petData['mix_breed_type'];

                                await widget.reference.updateData(petData);
                                Navigator.pop(context);
                                //  }

                              }
                            } else {
                              Location().getLocation().then((onValue) {
                                long = onValue.longitude;
                                lat = onValue.latitude;
                                loc = onValue.latitude.toString() +
                                    "," +
                                    onValue.longitude.toString();
                                print(loc);
                                setState(() {
                                  loc = onValue.latitude.toString() +
                                      "," +
                                      onValue.longitude.toString();
                                });
                                if (!loc.contains(',') || loc.isEmpty) {
                                  print("\n\n\nNo location\n\n\n");
                                }
                              });
                              setState(() {
                                showLocWarn = true;
                              });
                            }
                          }),
                      SizedBox(
                        height: 90,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      if (value == 0) {
        _radioValue1 = 0;
        gender = 'male';
      } else if (value == 1) {
        _radioValue1 = 1;
        gender = 'female';
      }
    });
  }

  bool isPureSelected = false;
  bool isMixed = false;

  void _handleRadioValueChange2(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      if (value == 0) {
        _radioValue2 = 0;
        isPureSelected = true;
        isMixed = false;
        breedTypePure = "pure";
        breedTypeMix = "";
      } else if (value == 1) {
        _radioValue2 = 1;
        isPureSelected = false;
        isMixed = true;
        breedTypePure = "";
        breedTypeMix = "mix";
      }
    });
  }

  buildRadioWidget(String head, op1, op2, int group_value, handleChange) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          head,
          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildRadioButton(op1, 0, group_value, handleChange),
            buildRadioButton(op2, 1, group_value, handleChange),
          ],
        ),
      ),
    );
  }

  Widget buildRadioButton(String head, value, groupvalue, handleChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(head),
        Radio(
          value: value,
          activeColor: Utiles.primaryButton,
          groupValue: groupvalue,
          onChanged: (val) => handleChange(val),
        )
      ],
    );
  }

  Widget buildDropDown() {
    return DropdownButton<String>(
      items: [],
      onChanged: (val) {},
      hint: Text("Select Primary Breed"),
      itemHeight: 30,
    );
  }

  String selectedPrimaryBreed = null, selectedSecondaryBreed = null;

  Widget buildListModels(List stringList, bool isPrimary) {
    return Container(
      height: MediaQuery.of(context).size.height * .35,
      child: ListView.builder(
        itemExtent: 40,
        physics: BouncingScrollPhysics(),
        itemCount: stringList.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            if (isPrimary)
              selectedPrimaryBreed = stringList[index];
            else
              selectedSecondaryBreed = stringList[index];

            Navigator.pop(context);
          },
          title: Text(
            stringList[index],
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }

  var bottomSheetController;

  var scaffold_key = GlobalKey<ScaffoldState>();
  Widget suggestionList = SizedBox();

  buildSearchBottomSheet(isPrimary) {
    suggestionList = buildListModels(breeds, isPrimary);
    if (focusNode.hasFocus) focusNode.unfocus();
    bottomSheetController = scaffold_key.currentState.showBottomSheet(
        (context) => Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Choose Breed",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (val) {
                        if (isPrimary)
                          selectedPrimaryBreed = val;
                        else
                          selectedSecondaryBreed = val;
                      },
                      onChanged: (val) {
                        print(breeds.toString());
                        suggestionList = buildListModels(
                            breeds
                                .where((element) =>
                                    element.contains(val.toLowerCase()))
                                .toList(),
                            isPrimary);
                        print(suggestionList.toString());
                        bottomSheetController.setState(() {});

                        if (isPrimary)
                          selectedPrimaryBreed = val;
                        else
                          selectedSecondaryBreed = val;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Type Brred here",
                      ),
                    ),
                  ),
                  suggestionList
                ],
              ),
            ),
        backgroundColor: Colors.white,
        clipBehavior: Clip.hardEdge);
  }

  getBreeds() async {
    setState(() {
      loading = true;
    });

    print("loading");
    var snap =
        await Firestore.instance.collection("data").document("dataList").get();

    breeds = snap.data['breeds'];
    List temp = List();
    for (var b in breeds) {
      temp.add(b.toString().toLowerCase().trim());
    }
    breeds = temp;

    print(breeds);
    setState(() {
      loading = false;
    });
  }

  void getPet() {
    pet = NewPet.fromJson(widget.petdate.data);

    _radioValue1 = (pet.gender == "Female") ? 2 : 1;
    _radioValue2 = (pet.breedType) - 1;

    gender = pet.gender;
    if (_radioValue2 == 1) {
      isMixed = true;
    } else {
      isPureSelected = true;
    }
    selectedPrimaryBreed = pet.primaryBreed;
    selectedSecondaryBreed = pet.secondaryBreed;
    petNameController.text = pet.name;
    breedNum = pet.breedType;
    setState(() {});
  }
}
