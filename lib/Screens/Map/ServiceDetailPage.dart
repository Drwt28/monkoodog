import 'package:flutter/material.dart';
import 'package:monkoodog/Modals/PetServiceModel.dart';


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
          buildSingleText("Company",petService.company),
          buildSingleText("City",petService.city),
          buildSingleText("Services",petService.services),
          buildSingleText("Category",petService.category),
          buildSingleText("Sub Category",petService.subCategory),
          buildSingleText("Address",petService.addressLine1),
          buildSingleText("Zip",petService.zip),


        ],
      ),

    );
  }

  buildSingleText(title,value)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$title :",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),textAlign: TextAlign.justify,),
        ), Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$value' ,style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 15,
              color: Colors.blue,),textAlign: TextAlign.justify,maxLines: 3,softWrap: true,),
        ),],
      ),
    );

  }
}
