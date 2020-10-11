
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkoodog/Modals/User.dart';
import 'package:provider/provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  @override
  Widget build( context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),


      ),


      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snap) =>
        (snap.data == null) ? Center(child: CircularProgressIndicator(),)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            (User
                .fromJson(snap.data.data)
                .userPhone == null) ? Text(
              'Logged by Google', textAlign: TextAlign.center, style: Theme
                .of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),) : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Card(
                child: ListTile(
                  title: Text(User
                      .fromJson(snap.data.data)
                      .userPhone??"", style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),),
                  leading: Icon(Icons.call),
//                  trailing: IconButton(
//                    icon: Icon(Icons.edit),
//                    onPressed: (){
//
//                    },
//                  ),

                ),
              ),
            )

            ,Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Card(
                child: ListTile(
                  title: Text(User
                      .fromJson(snap.data.data)
                      .userEmail, style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),),
                  leading: Icon(Icons.mail),
//                  trailing: IconButton(
//                    icon: Icon(Icons.edit),
//                    onPressed: (){
//
//                    },
//                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
