import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utiles {
  static Color primaryBgColor = Color.fromRGBO(3, 223, 223, 1);
  static Color primaryButton = Color.fromRGBO(232, 87, 131, 1);
  static Color primaryBgColorEnd = Color.fromRGBO(170, 250, 238, 1);
  static String urlAddPet =
      "pet_name=my pet&pet_gender=male&breed_type=6&dob=2019-12-07&number=923335709402&email=arsalankhan.igz@gmail.com&pure_breed_type=pure&mix_breed_type=mix&diseases=&allergies=&lovesto=lovesto&countryCode=92&location=32.7056383,71.500859";
  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    int months = month1 - month2;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    if (months < 0) {
      months = months * -1;
    }
    return age.toString() + " Years, " + months.toString() + " Months";
  }

  static String calculateWeeks(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    int months = month1 - month2;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    int week1 = age == 0 ? 0 : age * 52;
    int week2 = months == 0 ? 0 : months * 4 + 4;
    int weeks = week1 + week2;
    return weeks.toString() + " Weeks";
  }

  static int month(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    int months = month1 - month2;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return months;
  }

  static int year(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    int months = month1 - month2;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static void save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<String> read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

//  static Future<dynamic> read(String key) async {
//    final prefs = await SharedPreferences.getInstance();
//
//    return prefs.getString(key);
//  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<bool> isNetworkAvailable() async {
    bool flg = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) flg = true;
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return flg;
  }

  /*
 *  Check Network Connection
 */

  Future<bool> isNetworkProvider() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static alertBox(
    String errorName,
    BuildContext context,
  ) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Text(errorName),
              actions: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.grey[400],
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  static double cameraZoomRange(int range) {
    double cameraZoom;
    print(range.toString());
    switch (range) {
      case 0:
        cameraZoom = 8.0;
        break;
      case 1:
        cameraZoom = 20.0;
        break;
      case 10:
        cameraZoom = 11.6;
        break;
      case 21:
        cameraZoom = 11;
        break;

      case 31:
        cameraZoom = 10.5;
        break;
      case 41:
        cameraZoom = 10;
        break;
      case 51:
        cameraZoom = 9.5;
        break;
      case 60:
        cameraZoom = 9.4;
        break;
      case 70:
        cameraZoom = 9.2;
        break;
      case 80:
        cameraZoom = 8.8;
        break;
      case 90:
        cameraZoom = 8.5;
        break;
      case 100:
        cameraZoom = 8.0;
        break;
      default:
        cameraZoom = 1.0;
    }
    print('camerazoom value is =>$cameraZoom');
    return cameraZoom;
  }
}
