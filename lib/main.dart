import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/DataProvider/DataProvider.dart';
import 'package:monkoodog/Screens/HomePage/HomePage.dart';
import 'package:monkoodog/Screens/HomePage/Pet/AddPetScreen.dart';
import 'package:monkoodog/Screens/Login.dart';
import 'package:monkoodog/Screens/Slider.dart';
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
      child: MaterialApp(
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
    );
  }
}


