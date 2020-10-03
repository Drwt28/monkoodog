import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/utils/utiles.dart';

import 'Modals/vaccination.dart';

Widget buildButton({text, onPressed, loading, color, context}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    child: loading
        ? LinearProgressIndicator()
        : Center(
            child: Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: InkWell(
                onTap: onPressed,
                child: Center(
                    child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white,fontWeight: FontWeight.normal),
                )),
              ),
            ),
          ),
  );
}

Widget buildDropDown({title, list, onChanged, val}) {
  List<DropdownMenuItem> items = List.generate(
      list.length,
      (index) => DropdownMenuItem(
            child: Text(list[index]),
            value: list[index],
          ));
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton(
        underline: SizedBox(),
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        itemHeight: 60,
        // value: val,
        hint: Text(title),
      ),
    ),
  );
}
class ListAllVaccination extends StatelessWidget {
  final List<Vaccination> vaccination;
  final int year, month, date, weeks;
  final String age;
  final vac;
  ListAllVaccination(
      {@required this.vaccination,
        this.date,
        this.month,
        this.year,
        this.age,
        this.weeks,
        this.vac});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
          addAutomaticKeepAlives: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => vac == true
              ? vaccination[index].medicationType.contains('vaccination')
              ? vaccination[index].age.contains('every') ||
              weeks <=
                  int.parse(vaccination[index].age.substring(
                      0, vaccination[index].age.indexOf(' ')))
              ? Container(

            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(vaccination[index].nameVaccination,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
                      SizedBox(height: 8,)
                      ,Text(vaccination[index].age,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                      SizedBox(height: 2,),
                      Text(vaccination[index].type,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          vaccination[index]
                              .age
                              .contains('every')
                              ? month > DateTime.now().month
                              ? "${DateTime.now().year}/$month/$date"
                              : "${DateTime.now().year + 1}/$month/$date"
                              : weeks <=
                              int.parse(vaccination[
                              index]
                                  .age
                                  .substring(
                                  0,
                                  vaccination[
                                  index]
                                      .age
                                      .indexOf(
                                      ' ')))
                              ? "$year/${month + (int.parse(vaccination[index].age.substring(0, vaccination[index].age.indexOf(' '))) / 4).round()}/$date"
                              : " ",
                          style: month == DateTime.now().month
                              ? TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)
                              : TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 8,)
                      ,Text(vaccination[index].medicationType,style: Theme.of(context).textTheme.headline5.copyWith(color: Utiles.primaryButton,fontSize: 15),),

                    ],
                  )

                ],
              ),
            ),
            height: 110,
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Utiles.primaryBgColor,width: 1)
            ),
          )   : Container()
              : Container()
              : vaccination[index].medicationType.contains('medication')
              ? vaccination[index].age.contains('every') ||
              weeks <=
                  int.parse(vaccination[index].age.substring(
                      0, vaccination[index].age.indexOf(' ')))
              ? Container(

            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(vaccination[index].nameVaccination,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
                      SizedBox(height: 8,)
                      ,Text(vaccination[index].age,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                      SizedBox(height: 2,),
                      Text(vaccination[index].type,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
                    ],
                  ),

                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          vaccination[index]
                              .age
                              .contains('every')
                              ? month > DateTime.now().month
                              ? "${DateTime.now().year}/$month/$date"
                              : "${DateTime.now().year + 1}/$month/$date"
                              : weeks <=
                              int.parse(vaccination[
                              index]
                                  .age
                                  .substring(
                                  0,
                                  vaccination[
                                  index]
                                      .age
                                      .indexOf(
                                      ' ')))
                              ? "$year/${month + (int.parse(vaccination[index].age.substring(0, vaccination[index].age.indexOf(' '))) / 4).round()}/$date"
                              : " ",
                          style: month == DateTime.now().month
                              ? TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)
                              : TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 8,)
                      ,Text(vaccination[index].medicationType,style: Theme.of(context).textTheme.headline5.copyWith(color: Utiles.primaryButton,fontSize: 15),),

                    ],
                  )

                ],
              ),
            ),
            height: 110,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Utiles.primaryBgColor,width: 1)
            ),
          )              : Container()
              : Container(),
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.transparent,
            height: 0,
          ),
          itemCount: vaccination.length),
    );
  }

  buildSingleLayout(context)
  {
    // return Container(
    //
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //
    //         children: [
    //           Text(vaccination[index].nameVaccination,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
    //           SizedBox(height: 8,)
    //           ,Text(vaccination[index].age,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
    //           SizedBox(height: 2,),
    //           Text(vaccination[index].type,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black54,fontSize: 15),),
    //         ],
    //       ),
    //
    //       Column(
    //
    //         children: [
    //           Text(
    //               vaccination[index]
    //                   .age
    //                   .contains('every')
    //                   ? month > DateTime.now().month
    //                   ? "${DateTime.now().year}/$month/$date"
    //                   : "${DateTime.now().year + 1}/$month/$date"
    //                   : weeks <=
    //                   int.parse(vaccination[
    //                   index]
    //                       .age
    //                       .substring(
    //                       0,
    //                       vaccination[
    //                       index]
    //                           .age
    //                           .indexOf(
    //                           ' ')))
    //                   ? "$year/${month + (int.parse(vaccination[index].age.substring(0, vaccination[index].age.indexOf(' '))) / 4).round()}/$date"
    //                   : " ",
    //               style: month == DateTime.now().month
    //                   ? TextStyle(
    //                   fontSize: 18,
    //                   color: Colors.red,
    //                   fontWeight: FontWeight.bold)
    //                   : TextStyle(
    //                 fontSize: 18,
    //                 color: Colors.blue,
    //                 fontWeight: FontWeight.bold,
    //               )),
    //           SizedBox(height: 8,)
    //           ,Text(vaccination[index].medicationType,style: Theme.of(context).textTheme.headline5.copyWith(color: Utiles.primaryButton,fontSize: 15),),
    //
    //         ],
    //       )
    //
    //     ],
    //   ),
    //   height: 110,
    //   margin: EdgeInsets.all(10),
    //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(8),
    //       border: Border.all(color: Utiles.primaryBgColor,width: 1)
    //   ),
    // );
  }
}



