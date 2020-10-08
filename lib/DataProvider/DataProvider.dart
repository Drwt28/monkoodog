import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:monkoodog/Api/Api.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Modals/PetServiceModel.dart';
import 'package:monkoodog/Modals/alergies.dart';
import 'package:monkoodog/Modals/breed.dart';
import 'package:monkoodog/Modals/disease.dart';
import 'package:monkoodog/Modals/vaccination.dart';
import 'package:multiselectable_dropdown/multiselectable_dropdown.dart';

class DataProvider with ChangeNotifier {
  List breeds;
  List<Vaccination> vaccinations=[];
  List<MultipleSelectItem> diseases;
  List<MultipleSelectItem> allergies;
  LocationData userLocation;
  List news,events,posts;
  double radius = 10;
  Geoflutterfire geoflutterfire = Geoflutterfire();
  Stream<QuerySnapshot> pets;
  List<NewPet> mapPets=[];
  List<PetService> mapPetService=[];
  Api api = Api();

  getMapPets(double dis)
  async{
    await getUserLocation();
    var center = geoflutterfire.point(latitude: userLocation.latitude, longitude: userLocation.longitude);
    var ref = Firestore.instance.collection("pets");

    Stream<List<DocumentSnapshot>> stream = geoflutterfire.collection(collectionRef: ref)
        .within(center: center, radius: dis, field: 'position',strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) {
      // doSomething()
      mapPets = [];
      for(var doc in documentList)
      {
        NewPet p = NewPet.fromJson(doc.data);
        p.distance = center.distance(lat: p.latitude, lng: p.longitude).toString();
        mapPets.add(p);

      }
      mapPets.sort((a,b)=>(double.parse(a.distance)).compareTo(double.parse(b.distance)));
      notifyListeners();
    });
  }

  getMapPetService(double dis)
 async {
    await getUserLocation();
    var center = geoflutterfire.point(latitude: userLocation.latitude, longitude: userLocation.longitude);
    var ref = Firestore.instance.collection("services");

    Stream<List<DocumentSnapshot>> stream = geoflutterfire.collection(collectionRef: ref)
        .within(center: center, radius: dis, field: 'position',strictMode: true).take(100);

    if(mapPetService!=null)
      mapPetService.clear();
    stream.listen((List<DocumentSnapshot> documentList) {
      // doSomething()
      for(var doc in documentList)
      mapPetService.add(PetService.fromMap(doc.data));

      notifyListeners();
    });
  }

  getNews(int page_size,int page_no)
  async{
    print("getting news");
   news =  await api.getNewsList(page_size, page_no);
   notifyListeners();
   news = await getMedia(news);
   notifyListeners();

  }

  loadMoreNews()async{
    news.addAll(await api.getNewsList(news.length+2, 1)) ;
    notifyListeners();
    news = await getMedia(news);
    notifyListeners();
  }
  loadMorePosts()async{
    print(posts.length);
    posts.addAll(await api.getPostList(posts.length+2, 1)) ;
    notifyListeners();
    posts = await getMedia(posts);
    notifyListeners();
  }

  loadMoreEvents()async{
    events.addAll(await api.getEventList(events.length+2, 1)) ;
    notifyListeners();
    events = await getMedia(events);
    notifyListeners();
  }

  getEvents(int page_size,int page_no)
  async{
   events =  await api.getEventList(page_size, page_no);
   notifyListeners();
   events = await getMedia(events);
   notifyListeners();
  }
  Future<List> getMedia(List list)
 async {
    for(int i = 0; i <  list.length;i++)
    {
      if(list[i].url==null)
      list[i].url =await  api.getMedia(list[i].mediaLink);
    }
    return list;
  }

  getPosts(int page_size,int page_no)
  async{
   posts =  await api.getPostList(page_size, page_no);
   notifyListeners();
   posts = await getMedia(posts);
   notifyListeners();
  }


  getUserLocation()async
  {
    userLocation = await Location().getLocation();
    notifyListeners();
  }

  DataProvider(){
    getNews(1, 1);
    getEvents(1, 1);
    getPosts(1, 1);
    getUserLocation();
    getdata();
    getMapPets(100);
    getMapPetService(10);

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
