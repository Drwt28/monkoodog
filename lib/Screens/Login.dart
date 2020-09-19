import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:monkoodog/CustomWidgets.dart';
import 'package:monkoodog/Modals/User.dart';
import 'package:monkoodog/Screens/HomePage/HomePage.dart';

import 'package:monkoodog/utils/utiles.dart';
import 'package:monkoodog/Screens/ConfirmOtpScreen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  String phoneNo;
  String mobileNo = "";
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  var loading = false;
  final _controller = TextEditingController();
  String countryCode = "91";

  var formKey = GlobalKey<FormState>();





  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: (loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Let's Get Started",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter Your mobile number",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Code",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26, fontWeight: FontWeight.normal),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: "Enter Mobile Number"),
                        validator: (val) => (val.isEmpty || val.length != 10)
                            ? "Enter Valid Mobile No"
                            : null,
                        onChanged: (val) {
                          mobileNo = val;
                          phoneNo = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton(
                          context: context,
                          text: "Verify Mobile Number",
                          color: Utiles.primaryBgColor,
                          onPressed: () async {
                            if (formKey.currentState.validate()) verifyPhone();
                            setState(() {
                              loading = true;
                            });
                          },
                          loading: loading),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Text(
                      "Or",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton(
                          context: context,
                          text: "Sign in with Google",
                          color: Utiles.primaryButton,
                          onPressed: () {
                            _handleSignIn();
                          },
                          loading: loading),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Issue?contact",
                              style: TextStyle(color: Colors.black87)),
                          TextSpan(
                              text: "woof@monkoodog.com",
                              style: TextStyle(color: Utiles.primaryBgColor))
                        ]),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    setState(() {
      loading = true;
    });
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      this.phoneNo = phoneNo;
      this.smsOTP = smsOTP;
      setState(() {
        loading = false;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => confirmOtp(
                      mobileNo: mobileNo,
                      phoneNo: phoneNo,
                      verificationId: verificationId,
                      smsOTP: smsOTP,
                    )));
      });
    };

    _auth = FirebaseAuth.instance;
    try {
      var num = "+" + countryCode + phoneNo;
      await _auth.verifyPhoneNumber(
          phoneNumber: num,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            _auth
                .signInWithCredential(phoneAuthCredential)
                .then((authResult) async {
              MyUser user = await getUser(authResult);
            });
          },
          verificationFailed: (exception) {
            print('${exception.message}');
            loading = false;
            setState(() {});
          });
    } catch (e) {
      loading = false;
      setState(() {});
      print(e.toString());
    }
  }

  Future<MyUser> getUser(AuthResult authResult) async {
    String uid = authResult.user.uid;

    var doc =
        await Firestore.instance.collection("users").document(uid).get();
    if (doc.exists) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return MyUser.fromJson(doc.data);
    } else {
      await createUser(await _auth.currentUser());

      return null;
    }
  }

  Future<MyUser> getGoogleUser(FirebaseUser user) async {
    String uid = user.uid;

    var doc =
        await Firestore.instance.collection("users").document(uid).get();
    if (doc.exists) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return MyUser.fromJson(doc.data);
    } else {
      await createUser(user);

      return null;
    }
  }

  checkUser(MyUser user) {
    if (user == null) {
      print("null");
    } else {}
  }

  createUser(FirebaseUser fUser) async {
    try {
      loading = true;
      setState(() {});
      MyUser user = new MyUser(
          userEmail: fUser.email, userPhone: fUser.phoneNumber, uid: fUser.uid);

      var doc = await Firestore.instance
          .collection("users")
          .document(user.uid)
          .get();

      await doc.reference.setData(user.toJson());

      loading = false;
      setState(() {});

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    _auth = FirebaseAuth.instance;

    loading = true;

    try {
      FirebaseUser user;
      // flag to check whether we're signed in already
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        // if so, return the current user
        user = await _auth.currentUser();
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // get the credentials to (access / id token)
        // to sign in via Firebase Authentication
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        user = (await _auth.signInWithCredential(credential)).user;
        getGoogleUser(user);
      }

      return user;
    } catch (e) {
      loading = false;
      setState(() {});
      showDialog(
          context: context,
          child: AlertDialog(
            title: Icon(
              Icons.error,
              color: Colors.red,
              size: 36,
            ),
            content: Text(e.toString()),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Retry"),
              )
            ],
          ));
      return null;
    }

    // hold the instance of the authenticated user
  }
}
