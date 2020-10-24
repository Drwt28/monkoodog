import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Modals/user.dart';
import 'package:monkoodog/Screens/HomePage/BlogsPage/BlogsScreen.dart';
import 'package:monkoodog/Screens/HomePage/Newspage/NewsPage.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/HomePage/Pet/MyPetScreen.dart';
import 'package:monkoodog/Screens/Login.dart';
import 'package:monkoodog/Screens/Map/Finder.dart';
import 'package:monkoodog/Screens/Map/PetFinder.dart';
import 'package:monkoodog/Screens/Slider.dart';
import 'package:monkoodog/Screens/User/ProfileUpdateScreen.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  var title = ["Home", "My Pet", "Blogs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Finder()));
        },
        child: Container(
          padding: EdgeInsets.all(3),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.pink[100]),
          child: Icon(
            CupertinoIcons.paw_solid,
            color: Utiles.primaryButton,
            size: 53,
          ),
        ),
      ),
      key: scaffoldKey,
      drawer: buildHomeDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(title[selectedIndex]),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
          icon: ClipPath(
              clipper: iconShape(),
              child: Icon(
                Icons.menu,
                size: 37,
              )),
        ),
        backgroundColor: Utiles.primaryBgColor,
      ),
      body: selectedIndex == 0
          ? NewsScreen()
          : selectedIndex == 1
              ? MyPetScreen()
              : BlogsScreen(),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget bottomNavBar() {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        height: MediaQuery.of(context).size.height * .1,
        child: Row(
          children: [
            SingleItem(0, icon: CupertinoIcons.home),
            SingleItem(1, icon: CupertinoIcons.paw_solid),
            SingleItem(2, icon: CupertinoIcons.news_solid),
          ],
        ),
      ),
    );
  }

  buildHomeDrawer() {
    User user = Provider.of<DataProvider>(context).user;
    return Container(
      child: Drawer(
          elevation: 0,
          child: AnimationLimiter(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: AnimationConfiguration.toStaggeredList(
                  duration: Duration(milliseconds: 400),
                  childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: -200,
                      child: FadeInAnimation(
                        child: widget,
                      )),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileUpdateScreen()));
                      },
                      child: DrawerHeader(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                child: CircleAvatar(
                                  radius: 39.5,
                                  backgroundImage: user.userUrl!=null?NetworkImage(user.userUrl):AssetImage(
                                    'assets/images/logo_trans.png',
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                backgroundColor: Colors.black,
                              ),
                              SizedBox(width: 8,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    user.displayName??"",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Utiles.primaryBgColor,
                                        fontWeight: FontWeight.normal),
                                  ),Text(
                                    '   Update Your Profile',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
//                  decoration: BoxDecoration(
//                    gradient: LinearGradient(colors: [
//                      Utiles.primaryBgColor,
//                      Utiles.primaryBgColor,
//                    ]),
//                    color: Colors.blue,
//                  ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.home,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        selectedIndex -= 0;
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.share,
                      ),
                      title: Text(
                        'Invite friends',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(
                            'Check out our app Moonkodog https://play.google.com/store/apps/details?id=com.moonkodog.app');
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.paw,
                      ),
                      title: Text(
                        'PetFinder',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Finder()));
                      },
                    ),

                    ListTile(
                      leading: Icon(
                        CupertinoIcons.rectangle_paperclip,
                        color: Utiles.primaryBgColor,
                      ),
                      title: Text("Report Issue",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      onTap: () async {
                        Navigator.pop(context);
                        var uri =
                            'mailto:woof@monkoodog.com?subject=Reporting%20Issue&body=';
                        if (await canLaunch(uri)) {
                          launch(uri);
                        } else {
                          print("Cant  Do   IT");
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.square_arrow_right,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: (context),
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.white,
                            title: Text("Logout"),
                            content: Text("Are you want to logout"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  try {
                                    await GoogleSignIn().signOut();
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SliderPage()));

//
                                },
                                child: Text("YES"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("NO"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
//            AboutListTile(
//              icon: Icon(Icons.phone_android),
//              child: Text("Licenses",
//                  style: TextStyle(
//                      fontSize: 16,
//                      color: Colors.black,
//                      fontWeight: FontWeight.normal)),
//              applicationVersion: '1.0.3',
//              applicationName: 'Monkoodog',
//              applicationLegalese: 'Blah Blah.',
//            ),
                  ]),
            ),
          )),
    );
  }

  int selectedIndex = 1;

  Widget SingleItem(index, {icon}) {
    return !(selectedIndex == index)
        ? Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                selectedIndex = index;
                setState(() {});
              },
              child: Container(
                color: Utiles.primaryBgColor,
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ))
        : Flexible(
            flex: 1,
            child: CustomPaint(
              painter: circleShape(),
              child: ClipPath(
                clipper: selectedClipper(),
                child: Container(
                  color: Utiles.primaryBgColor,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ));
  }
}

class selectedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    double radius = 20;
    var part = size.width * .4;
    Path path = Path()
      ..lineTo(size.width * .45, 0)
      ..moveTo(size.width * .45, -size.height * .87)
      ..arcToPoint(Offset(size.width * .55, -size.height * .87),
          largeArc: true,
          radius: Radius.elliptical(size.height * .35, size.height * .58),
          clockwise: false)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class circleShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var part = (size.width / 3);
    Paint paint = Paint();
    paint.color = Colors.white;

    canvas.drawCircle(Offset(size.width / 2, part), part, paint);
    paint.color = Utiles.primaryBgColor;
    canvas.drawCircle(Offset(size.width / 2, 6), 6, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class iconShape extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }
}
