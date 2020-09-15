import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Screens/HomePage/Pet/PetDetailScreen.dart';
import 'package:monkoodog/Screens/Map/AreaSearch.dart';
import 'package:monkoodog/utils/utiles.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:multiselectable_dropdown/multiselectable_dropdown.dart';
// import 'package:restcountries/restcountries.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  double distance = 10;
  List<NewPet> petList = [];
  List _secondarybreedresult = [];
  List _primarybreedresult = [];
  List<MultipleSelectItem> breeds = [];
  List<MultipleSelectItem> country = [];
  List<MultipleSelectItem> state = [];
  List<MultipleSelectItem> city = [];

  getBreeds() async {
    var data =
        await Firestore.instance.collection("data").document('dataList').get();
    for(var a  in data.data['breeds'])
    {
      breeds.add(MultipleSelectItem.build(
          value: '${a}',
          display: '${a}',
          content: '${a}'));

    }
   setState(() {

   });
  }

  Future<List> getPets() async {
    var data = await Firestore.instance.collection('pets').getDocuments();

    getUserLocation();
    List<NewPet> pets = List.generate(data.documents.length,
        (index){
          var pet = NewPet.fromJson(data.documents[index].data);
          pet.distance = calculateDistance(pet.latitude, pet.longitude).ceil().toString();
          return pet;
    });

    pets.sort((a,b)=>(double.parse(a.distance)).compareTo(double.parse(b.distance)));
   petList = pets;
    totalPets = petList;

    setState(() {});
    return pets;
  }

  @override
  void initState() {
    getBreeds();
    getUserLocation();
  }

  bool isAreaSearch = false;

  Utiles _utiles = Utiles();

  List<NewPet> totalPets = List<NewPet>();

  GoogleMapController _mapController;

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final pets = await getPets();
   getMarkers();
  }

  getMarkers(){
    setState(() {
      _markers.clear();
      for (NewPet pet in petList) {
        final marker = Marker(

          draggable: true,
          markerId: MarkerId(pet.name),
          position: LatLng(pet.latitude, pet.longitude),
          infoWindow: InfoWindow(
            title: pet.primaryBreed,
            snippet: pet.name,
          ),
        );
        _markers[pet.name] = marker;
      }
    });
  }





  var scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffold,
        body: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) ),
              child: Container(
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(26, 75),
                    zoom: 2,
                  ),
                  markers: _markers.values.toSet(),
                ),
              ),
            ),
            Positioned(
              left: 50,
              bottom: 152,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "${petList.length} pets",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black, fontSize: 15),
                    )),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              child: SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (petList.length == 0)
                      ? buildRangeWidget()
                      : CarouselSlider(
                          items: List.generate(
                              petList.length,
                              (index) => Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        onTap: () {
                                          //onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PetDetailScreen(
                                                        pets: petList[index],
                                                        view: false,
                                                      )));

                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Hero(
                                                tag: petList[index].dob,
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      petList[index].media),
                                                  placeholder: AssetImage(
                                                      'assets/images/dog_marker.png'),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                color: Utiles.primaryBgColor,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      petList[index].breed,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    ),
                                                    Text(
                                                      Utiles.calculateAge(
                                                          DateTime.parse(
                                                              petList[index]
                                                                  .dob)),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                    ),
                                                    Text(
                                                        "${petList[index].distance} Km",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                          options: CarouselOptions(
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              initialPage: 0,
                              aspectRatio: 1,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, controller) {
                                _mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        new CameraPosition(
                                            target: LatLng(
                                                petList[index.floor()].latitude,
                                                petList[index.floor()]
                                                    .longitude),
                                            zoom: 10)));
                              },
                              onScrolled: (index) {},
                              height: 120),
                        ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(

                        heroTag: 'ser',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          showSearch(
                              context: context, delegate: PetSearch(totalPets,lat1??0.0,lon1??0.0));
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'serch',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          scaffold.currentState.openEndDrawer();
                        },
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        endDrawer: buildFilterDrawer(),
      ),
    );
  }

  Widget buildFilterDrawer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width * .85,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filters',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black87),
            ),
          ),
          buildExpansionTile("Primary Breed", [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MultipleDropDown(
                  placeholder: 'Select Primary Breed',
                  disabled: false,
                  values: _primarybreedresult,
                  elements: breeds,
                ),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Find pets in range',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Utiles.primaryBgColor, fontSize: 16),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  autofocus: false,
                  label: "$distance",
                  onChanged: (val) {
                    setState(() {
                      distance = val;
                      filterByRange(val);
                    });
                  },
                  value: distance,
                  activeColor: Colors.blue,
                  min: 10,
                  max: 2000,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "${distance.toInt()} km",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Area wise',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Utiles.primaryBgColor, fontSize: 16),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context)=>AreaSearch("Pets",true)
                ));

              },
              color: Utiles.primaryBgColor,
              child: Text(
                "Area Search",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
              onPressed: () {
                //


                if(_primarybreedresult.isNotEmpty||_secondarybreedresult.isNotEmpty)
               petList = totalPets.where((element) => ((_primarybreedresult.toString()??'g').

               toLowerCase().contains((element.primaryBreed??'hgajgjg').toLowerCase())||
                   (_secondarybreedresult.toString()??'hj').toLowerCase().contains((element.secondaryBreed??'lidaliaud').toLowerCase()))).toList();



                getMarkers();
                Navigator.pop(context);


                },
              color: Utiles.primaryBgColor,
              child: Text(
                "Apply Filter",
              ),
            ),
          )
        ],
      ),
    );
  }

  bool containsAny(List breed,result)
  {

  }


  // getCountryData()async{
  //     var api = RestCountries.setup("90f50cb51356ea8e324563ed224a64eb");
  //     List<Country> countries;
  //     List<Region> regions;
  //     List<City> cities;
  //     // get all countries
  //     countries = await api.getCountries();
  //     for(var c in countries)
  //       {
  //         country.add(MultipleSelectItem.build(value: c.code, display: c.name, content: c.name));
  //       }
  //     // or you could do this as long as you have called setup for initialization
  //
  //     // search country functionality
  //     // you could also put city and/or region to narrow down the search of the country
  //     // get all regions of a country. You need to pass the countryCode as it is required from the API
  //     regions = await api.getRegions(countryCode: "id");
  //
  //     // search region
  //     regions =
  //     await api.searchRegion(countryCode: "id", city: "", keyword: "Jawa");
  //
  //     // you could get all cities by just filling the countryCode and region name.
  //     // if you want to narrow it down to search of some city, put the keyword as parameter
  //     cities = await api.getCities(
  //         countryCode: "id", region: "Jawa Timur", keyword: "mal");
  //
  // }

  //area search

  Widget buildRangeWidget() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Center(
        child: ListTile(
          title: Text("No Pet found"),
//          subtitle: Column(
//            children: [
//              Slider(
//                autofocus: false,
//                label: "$distance",
//                onChanged: (val) {
//                  setState(() {
//                    distance = val;
//                    filterByRange(val);
//                  });
//                },
//                value: distance,
//                activeColor: Colors.blue,
//                min: 10,
//                max: 2000,
//              ),
//              Text(
//                "${distance.toInt()} km",
//                style: Theme.of(context)
//                    .textTheme
//                    .headline6
//                    .copyWith(color: Colors.blue, fontSize: 16),
//              )
//            ],
//          ),
          leading: Image.asset('assets/images/dog_marker.png',
              width: 30, height: 30),
        ),
      ),
    );
  }

  buildExpansionTile(String title, List<Widget> list) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 16),
      ),
      children: list,
    );
  }

  var lat1, lon1;

  getUserLocation() async {
    var loc = await Location.instance.getLocation();
    setState(() {
      lat1 = loc.latitude;
      lon1 = loc.longitude;
    });
  }

  filterByRange(double range) {
    petList = totalPets
        .where((element) =>
            double.parse(element.distance)  <= distance)
        .toList();
    getMarkers();
    setState(() {});
  }

  double calculateDistance(lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a))??0.0;
  }

}
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).

class PetSearch extends SearchDelegate<String> {


  double calculateDistance(lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat) * p) / 2 +
        c(lat * p) * c(lat2 * p) * (1 - c((lon2 - long) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List<NewPet> petList;
  var lat,long;

  PetSearch(this.petList,this.lat,this.long);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = petList
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return (suggestions.length > 0)
        ? ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Container(
                    height: 70,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PetDetailScreen(
                                            pets: suggestions[index],
                                            view: false,
                                          )));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder:
                                    AssetImage('assets/images/dog_marker.png'),
                                    image: NetworkImage(suggestions[index].media),

                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    suggestions[index].name,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "${calculateDistance(suggestions[index].latitude, suggestions[index].longitude).ceil()} km",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(fontSize: 16, color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ))
        : Container(
            child: Center(
              child: Text('No Pet found'),
            ),
          );
  }

  @override
  String get searchFieldLabel => "enter pet name";
}
