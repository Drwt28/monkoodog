import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Screens/HomePage/BlogsPage/BlogsScreen.dart';
import 'package:monkoodog/Screens/HomePage/Newspage/NewsPage.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/HomePage/Pet/MyPetScreen.dart';
import 'package:monkoodog/Screens/Login.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context,listen: false).getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: buildHomeDrawer(),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          scaffoldKey.currentState.openDrawer();
        }
        ,icon: Icon(Icons.menu),),
        backgroundColor: Utiles.primaryBgColor,
      ),
      body: selectedIndex==0?NewsScreen():selectedIndex==1?MyPetScreen():BlogsScreen(),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget bottomNavBar() {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
        ),
        height: 90,
        child: Row(
          children: [
            SingleItem(0,icon: CupertinoIcons.home),
            SingleItem(1,icon: CupertinoIcons.paw_solid),
            SingleItem(2,icon: CupertinoIcons.news_solid),
          ],
        ),
      ),
    );
  }


  buildHomeDrawer()
  {
    return Container(
      child: Drawer(
          elevation: 0,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              GestureDetector(
                // onTap: () {
                //   Navigator.pop(context);
                //
                //   Navigator.push(context, MaterialPageRoute(
                //       builder: (context)=>ProfileUpdateScreen()
                //   ));
                // },
                child: DrawerHeader(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: CircleAvatar(
                            radius: 39.5,
                            backgroundImage: AssetImage(
                              'assets/images/logo_trans.png',
                            ),
                            backgroundColor: Colors.white,
                          ),
                          backgroundColor: Colors.black,
                        ),
                        Text(
                          '   Update Your Profile',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
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
                leading: Icon(Icons.home,
                  color: Utiles.primaryBgColor,),
                title: Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.send,
                  color: Utiles.primaryBgColor,
                ),
                title: Text(
                  'Invite friends',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                // onTap: () {
                //   Navigator.pop(context);
                //   Share.share(
                //       'Check out our app Moonkodog https://play.google.com/store/apps/details?id=com.moonkodog.app');
                // },
              ),
              ListTile(
                leading: Icon(Icons.pets,
                  color: Utiles.primaryBgColor,),
                title: Text(
                  'PetFinder',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                // onTap: () {
                //   Navigator.pop(context);
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Finder()));
                // },
              ),
              ListTile(
                leading: Icon(Icons.bug_report,
                  color: Utiles.primaryBgColor,),
                title: Text("Report Issue",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                // onTap: () async {
                //   Navigator.pop(context);
                //   var uri =
                //       'mailto:woof@monkoodog.com?subject=Reporting%20Issue&body=';
                //   if (await canLaunch(uri)) {
                //     launch(uri);
                //   } else {
                //     print("Cant  Do   IT");
                //   }
                // },
              ),
              ListTile(
                leading: Icon(Icons.person,
                  color: Utiles.primaryBgColor,),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
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
                      content:
                      Text("Are you sure you wanna logout of MonkooDog?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            try{
                              await GoogleSignIn().signOut();
                            }catch(e){
                              print(e.toString());
                            }
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

//
                          },
                          child: Text("YES"),
                          color: Colors.red,
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
//                      fontWeight: FontWeight.bold)),
//              applicationVersion: '1.0.3',
//              applicationName: 'Monkoodog',
//              applicationLegalese: 'Blah Blah.',
//            ),
            ],
          )),
    );
  }

  int selectedIndex=0;
  Widget SingleItem(index,{icon})
  {
    return !(selectedIndex==index)?
    Flexible(
        flex: 1,
        child:InkWell(
      onTap: (){
        selectedIndex=index;
        setState(() {

        });
      },
      child: Container(
        color: Utiles.primaryBgColor,
        child: Center(
          child: Icon(icon,size: 30,),
        ),
      ),
    ) ):Flexible(
        flex: 1,
        child: CustomPaint(
      painter: circleShape(),
      child: ClipPath(
        clipper: selectedClipper(),
        child: Container(
          color: Utiles.primaryBgColor,
          child: Center(
            child: Icon(icon,color: Colors.white,size: 35,),
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
    Path path = Path();
    var part = (size.width / 3);
    path.lineTo(part, 0);
    path.lineTo(size.width/2, 20);
    path.lineTo(2 * part, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class circleShape extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.color = Utiles.primaryBgColor;
    canvas.drawCircle(Offset(size.width/2,6), 6, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return true;
  }

}
