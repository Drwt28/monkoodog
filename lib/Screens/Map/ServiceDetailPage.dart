import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monkoodog/Modals/PetServiceModel.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailPage extends StatefulWidget {
  PetService petService;

  ServiceDetailPage({this.petService});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  PetService petService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    petService = widget.petService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(petService.company),
      ),
      body: Column(
        children: [
          buildSingleText("Company", petService.company),
          buildSingleText("City", petService.city),
          buildSingleText("Services", petService.services),
          buildSingleText("Category", petService.category),
          buildSingleText("Sub Category", petService.subCategory),
          buildSingleText("Address", petService.addressLine1),
          buildSingleText("Zip", petService.zip),


          Container(
            margin: EdgeInsets.all(8),
            child: ListTile(
              onTap: ()async{
                String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.petService.latitude},${widget.petService.longitude}';
                if (await canLaunch(googleUrl)) {
                await launch(googleUrl);
                } else {
                throw 'Could not open the map.';
                }
              },
              title: Text("Navigate ",style: Theme.of(context).textTheme.headline6.copyWith(color: Utiles.primaryBgColor),),
              trailing: Icon(FontAwesomeIcons.locationArrow,color: Utiles.primaryButton,),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Utiles.primaryBgColor)
            ),
          )
        ],
      ),
    );
  }

  buildSingleText(title, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$title :",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
              textAlign: TextAlign.justify,
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
