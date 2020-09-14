import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Modals/alergies.dart';
import 'package:monkoodog/Modals/breed.dart';
import 'package:monkoodog/Modals/disease.dart';
import 'package:monkoodog/Modals/vaccination.dart';
import 'package:multiselectable_dropdown/multiselectable_dropdown.dart';

class DataProvider with ChangeNotifier {
  List breeds;
  List<Vaccination> vaccinations;
  List<MultipleSelectItem> diseases;
  List<MultipleSelectItem> allergies;
  LocationData userLocation;
  Stream<QuerySnapshot> pets;

  getUserLocation()async
  {
    userLocation = await Location().getLocation();

    notifyListeners();
  }

  DataProvider(){
    getUserLocation();
    getdata();
  }


 Stream<QuerySnapshot> getPets()
  {
    // Firestore.instance.collection("pets").where(field)

  }

  Future<List<Breed>> getdata() async {
    var snap = await Firestore.instance
        .collection("data")
        .document("dataList")
        .get();

    var breed = snap.data['breeds'];
    List temp = List();
    for (var b in breed) {
      temp.add(b.toString().toLowerCase().trim());
    }
    breeds = temp;
    print(breeds.toString());
    notifyListeners();
    List alr = snap.data['allergies'];
    List dis = snap.data['diseases'];
    allergies = List();
    diseases = List();


    for (var a in alr) {
      allergies.add(MultipleSelectItem.build(
          value: '${a}', display: '${a}', content: '${a}'));
    }


    for (var a in dis) {
      diseases.add(MultipleSelectItem.build(
          value: '${a}', display: '${a}', content: '${a}'));
    }


    List data  = snap.data['vaccinations']??[];

    vaccinations.clear();
    for(var doc in data)
    {
      vaccinations.add(Vaccination.fromJson(doc));
    }

    notifyListeners();
  }
}
