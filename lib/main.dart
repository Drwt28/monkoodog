import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Screens/ConfirmOtpScreen.dart';
import 'package:monkoodog/Screens/HomePage/HomePage.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/Login.dart';
import 'package:monkoodog/Screens/Slider.dart';
import 'package:monkoodog/Screens/SplashScreen.dart';
import 'package:monkoodog/Widgets/ToogleButton.dart';
import 'package:monkoodog/utils/utiles.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider.value(value: DataProvider()),
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: WillPopScope(

        onWillPop: ()async{

        var val = false;
         await  showDialog(
            context: (context),
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              title: Text("Logout"),
              content:
              Text("Are you sure to exit"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    val = true;

                  },
                  child: Text("Yes"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                )
              ],
            ),
          );

         return val;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Monkoodog',
          theme: ThemeData(

            dialogTheme: DialogTheme(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),

            appBarTheme: AppBarTheme(
              color: Utiles.primaryBgColor
            ),

            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SliderPage(),
        ),
      ),
    );
  }
}


