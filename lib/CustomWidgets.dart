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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: InkWell(
                onTap: onPressed,
                child: Center(
                    child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
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
              ? Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Age From Birth: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Type: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Medication Type: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Due on: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            vaccination[index].nameVaccination,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].age,
                            style: vaccination[index]
                                .age
                                .contains('every')
                                ? TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
//                                              fontStyle: FontStyle.italic,
//                                              decoration: TextDecoration.underline
                            )
                                : TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].type,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].medicationType,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
//                            RaisedButton(
//                              onPressed: () {},
//                              child: Text("Given", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
//                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
//                            )
                ],
              ),
            ),
          )
              : Container()
              : Container()
              : vaccination[index].medicationType.contains('medication')
              ? vaccination[index].age.contains('every') ||
              weeks <=
                  int.parse(vaccination[index].age.substring(
                      0, vaccination[index].age.indexOf(' ')))
              ? Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Age From Birth: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Type: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Medication Type: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(""),
                          Text(
                            "Due on: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            vaccination[index].nameVaccination,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].age,
                            style: vaccination[index]
                                .age
                                .contains('every')
                                ? TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
//                                              fontStyle: FontStyle.italic,
//                                              decoration: TextDecoration.underline
                            )
                                : TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].type,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
                          Text(
                            vaccination[index].medicationType,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(""),
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
//                            RaisedButton(
//                              onPressed: () {},
//                              child: Text("Given", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
//                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
//                            )
                ],
              ),
            ),
          )
              : Container()
              : Container(),
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.transparent,
            height: 0,
          ),
          itemCount: vaccination.length),
    );
  }
}



