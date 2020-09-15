import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monkoodog/Modals/NewPet.dart';
import 'package:monkoodog/Modals/PetServiceModel.dart';
import 'package:monkoodog/Screens/HomePage/Pet/PetDetailScreen.dart';
import 'package:monkoodog/utils/utiles.dart';

import 'ServiceDetailPage.dart';


class AreaSearch extends StatefulWidget {
  String type = "Pet Service";
  bool isPet;


  AreaSearch(this.type, this.isPet);

  @override
  _AreaSearchState createState() => _AreaSearchState();
}

class _AreaSearchState extends State<AreaSearch> {
  BitmapDescriptor serviceIcon;

  List<PetService> petServiceList = [];
  Set<Circle> circles = Set();
  double range = 10;
  GoogleMapController _mapController;
  Map<String, Marker> _markers = {};
  List<Marker> markers = [];

  Marker centerMarker;
  var loading = false;
  bool isResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
                  height: 0,
                  width: 0,
                ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              myLocationButtonEnabled: false,
              circles: circles,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:  LatLng(lat1, lon1),
                zoom: 7,
              ),
              markers: Set.from([centerMarker]),
              onCameraMove: (camera) {
                lat1 = camera.target.latitude;
                lon1 = camera.target.longitude;

                centerMarker = Marker(
                    markerId: MarkerId("123123"),
                    draggable: false,
                    icon: serviceIcon,
                    infoWindow: InfoWindow(
                      title: "current search ",
                      snippet: "position"
                    ),
                    position: LatLng(lat1, lon1));

                setState(() {});
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: loading?80:!isResult ? 190 : 130,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading?Card(
                    child: Center(
                      child: CircularProgressIndicator(),
                    )
                ):!isResult
                    ? Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Slider(
                                value: range,
                                min: 1,
                                max: 2000,
                                label: "km",
                                onChanged: (val) {
                                  range = val;
                                  setState(() {});
                                },
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    "${range.round()} Km",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.w800),textAlign: TextAlign.center,
                                  ),
                                )),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  widget.isPet?SearchPets(lon1, lat1):SearchPetService(lon1, lat1);
                                },
                                child: Container(
                                color: Colors.blue,
                                  child: Center(child: Text("Search Here",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),)),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : (petList.length == 0)
                        ? Card(
                            child: Center(
                              child: Text("No ${widget.type} in this area"),
                            ),
                          )
                        : CarouselSlider(
                            items: widget.isPet? List.generate(
                                petList.length,
                                    (index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>   PetDetailScreen(
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
                                )):List.generate(
                                petServiceList.length,
                                (index) => Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ServiceDetailPage(
                                                          petService:
                                                              petServiceList[index],
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
                                                  tag: petServiceList[index]
                                                          .addressLine1 ??
                                                      '',
                                                  child: Image.asset(
                                                      'assets/images/dog_marker.png'),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  color: Utiles.primaryBgColor,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        petServiceList[index]
                                                                .company ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                      ),
                                                      Text(
                                                        petServiceList[index].city ??
                                                            '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                      ),
                                                      Text(
                                                          "${petList[index].distance} Km",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: Theme.of(
                                                                  context)
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
                                  _mapController.animateCamera(CameraUpdate
                                      .newCameraPosition(new CameraPosition(
                                          target: LatLng(
                                              petList[index.floor()].latitude,
                                              petList[index.floor()].longitude),
                                          zoom: 10)));
                                },
                                onScrolled: (index) {},
                                height: 120),
                          ),
              ),
            ),
          ),
          isResult?Positioned(
              top: 25,
              left: 25,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                heroTag: "petsed",
                onPressed: (){
                  petList.clear();
                  isResult = false;
                  setState(() {

                  });
                },
                child: Icon(Icons.close,color: Colors.white,),
              )):Positioned(
              top: 25,
              left: 25,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: "ejkkd",
                onPressed: (){
                Navigator.pop(context);
                },
                child: Icon(CupertinoIcons.back,color: Colors.black,),
              )),

          Positioned(
              left: 90,
              right: 90,
              top: 25,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 8),
              child: Center(child: Text("Area Search",style: TextStyle(color: Colors.black,fontSize: 18),)),
            ),
          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/pin.png')
        .then((onValue) {
      serviceIcon = onValue;
      centerMarker = Marker(
          markerId: MarkerId("123123"),
          draggable: false,
          icon: serviceIcon,
          infoWindow: InfoWindow(
              title: "current search ",
              snippet: "position"
          ),
          position: LatLng(lat1, lon1));
    });



    markers.add(Marker(
      onTap: () {
        showConfirmDialog(41, 82);
      },
      markerId: MarkerId("search"),
      draggable: true,
      position: LatLng(41, 82),
      infoWindow: InfoWindow(
        onTap: () {
          showConfirmDialog(41, 82);
        },
        title: "Tap to search",
        snippet: "area",
      ),
      onDragEnd: (val) {},
    ));
  }

  double lat1 = 26.1, lon1 = 72.7;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    centerMarker = Marker(
        markerId: MarkerId("123123"),
        draggable: false,
        icon: serviceIcon,
        position: LatLng(lat1, lon1));
    setState(() {

    });
  }

  showConfirmDialog(double lat, double long) {
    showDialog(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          content: FittedBox(
            child: Slider(
              value: range,
              min: 1,
              max: 2000,
              label: "$range km",
              onChanged: (val) {
                range = val;

                setState(() {});
              },
            ),
          ),
          title: Text("Are sure to search ${widget.type}"),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  SearchPetService(long, lat);
                },
                child: Text("Search")),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
          ],
        ));
  }


  List<NewPet>  petList = [];

  Geoflutterfire geo = Geoflutterfire();
  CollectionReference petsCollection = Firestore.instance.collection("pets");
  CollectionReference petServiceCollection =
      Firestore.instance.collection("services");

  SearchPetService(double long, double lat) async {

    setState(() {
      loading = true;
    });
    circles = Set.from([
      Circle(
        strokeWidth: 30,
        fillColor: Colors.green,
        visible: true,
        circleId: CircleId('latha'),
        center: LatLng(long, lat),
        radius: range,
      )
    ]);
    setState(() {});
    GeoFirePoint center = geo.point(latitude: 41.960632, longitude: 87.641603);
    var stream = geo
        .collection(collectionRef: petServiceCollection)
        .within(center: center, radius: range, field: 'position');

    petList.clear();
    stream.listen((List<DocumentSnapshot> documentList) {
      for (var doc in documentList) {
        print(documentList.length);
        markers.add(Marker(
            markerId: MarkerId(doc.documentID),
            icon: serviceIcon,
            draggable: false,
            infoWindow: InfoWindow(title: '', snippet: '')));
        petServiceList.add(PetService.fromMap(doc.data));
      }
      print(petList.length);
      isResult=true;
      loading =false;
      setState(() {});
    });
  }
  SearchPets(double long, double lat) async {

    setState(() {
      loading = true;
    });
    circles = Set.from([
      Circle(
        strokeWidth: 30,
        fillColor: Colors.green,
        visible: true,
        circleId: CircleId('latha'),
        center: LatLng(long, lat),
        radius: range,
      )
    ]);
    setState(() {});
    GeoFirePoint center = geo.point(latitude: 41.960632, longitude: 87.641603);
    var stream = geo
        .collection(collectionRef: petsCollection)
        .within(center: center, radius: range, field: 'position');

    petList.clear();
    stream.listen((List<DocumentSnapshot> documentList) {
      for (var doc in documentList) {
        print(documentList.length);
        markers.add(Marker(
            markerId: MarkerId(doc.documentID),
            icon: serviceIcon,
            draggable: false,
            infoWindow: InfoWindow(title: '', snippet: '')));
        petList.add(NewPet.fromJson(doc.data));
      }
      print(petList.length);
      isResult=true;
      loading =false;
      setState(() {});
    });
  }
}
