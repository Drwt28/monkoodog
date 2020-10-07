import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:monkoodog/Screens/HomePage/HomePage.dart';
import 'package:monkoodog/Screens/Login.dart';
import 'package:monkoodog/utils/utiles.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  var isLooged = false;

  checcklogin() async {
    //emulator checking
    // await FirebaseAuth.instance.signInAnonymously();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      setState(() {
        isLooged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checcklogin();
  }

  @override
  Widget build(BuildContext context) {
    return (isLooged)
        ? HomePage()
        : Scaffold(
            body: LiquidSwipe(
              enableLoop: false,
              initialPage: 0,
              pages: [
                buildSinglePage(
                    'Welcome to\nMonkoodog',
                    'Best app for your dog',
                    'assets/images/scree1.png',
                    Utiles.primaryBgColor,
                    isLast: false),
                buildSinglePage(
                    'Set your Location',
                    'Set your location so we can tell you the nearest animal shop to but pet',
                    'assets/images/screen2.png',
                    Utiles.primaryButton,
                    isLast: false),
                buildSinglePage(
                    'Pet Vaccines Dates',
                    'Get your dog health \ninsights, next due date for\nvaccines and lot more.',
                    'assets/images/screen3.png',
                    Utiles.primaryBgColor,
                    isLast: true),
              ],
            ),
          );
  }

  Widget buildSinglePage(title, subtitle, image, color, {isLast}) {
    return Stack(
      children: [
        Container(
          color: color,
        ),
        Padding(
          padding: EdgeInsets.only(top: 70, left: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        image,
                        fit: BoxFit.fitWidth,
                      )))
            ],
          ),
        ),
        (!isLast)?Container():Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              height: 60,
              color: Utiles.primaryBgColor,
              child: Center(
                child: Text(
                  "Get Started",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
