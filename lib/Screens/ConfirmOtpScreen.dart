import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkoodog/Modals/User.dart';

import 'package:monkoodog/utils/utiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:monkoodog/Screens/HomePage/HomePage.dart';

import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../CustomWidgets.dart';

class confirmOtp extends StatefulWidget {

  String phoneNo;
  String mobileNo="";
  String smsOTP;
  String verificationId;



  confirmOtp({this.phoneNo, this.mobileNo, this.smsOTP, this.verificationId});

  @override
  _confirmOtpState createState() => _confirmOtpState();
}

class _confirmOtpState extends State<confirmOtp> {
  var loading = false;
  String phoneNo;
  String mobileNo="";
  String smsOTP;
  String verificationId;
  String countryCode = "91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 50,),
          Text("Enter the Code Sent", style: Theme
              .of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.black, fontWeight: FontWeight.w700),),
          SizedBox(height: 10,),
          Text("Enter the 6-digit code", style: Theme
              .of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.black54, fontWeight: FontWeight.normal),),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PinCodeTextField(
              onTextChanged: (val){
                smsOTP = val;
              },
              onDone: (val){
                smsOTP = val;
                signIn();
              },
            autofocus: true,
              maxLength: 6,
              pinBoxHeight: 60,
              pinBoxRadius: 10,
              pinBoxWidth: 50,
              wrapAlignment: WrapAlignment.center,
              defaultBorderColor: Utiles.primaryButton,
              pinBoxColor: Colors.white,

            ),
          ),
          SizedBox(height: 20,),

          Text("Didn't get the code ? Tap here to", style: Theme
              .of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black54, fontWeight: FontWeight.normal),)
          ,
          SizedBox(height: 8,),
          Text("Resend Code", style: Theme
              .of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),)

          ,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildButton(text: "Continue",
                context: context,
                color: Utiles.primaryBgColor,
                onPressed: () async {

              loading=true;
              setState(() {

              });
              signIn();
                  // Navigator.push(context, CupertinoPageRoute(
                  //     builder: (context)=>HomePage()
                  // ));
                  // setState(() {
                  //   loading = true;
                  // });
                  //
                  // await Future.delayed(Duration(seconds: 3));
                  // setState(() {
                  //   loading =F false;
                  // });
                },
                loading: loading),
          ),
          SizedBox(height: 15,),
    ]
    )
    )
    ,
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final result = (await _auth.signInWithCredential(credential));

      MyUser user = await getUser(result);

    } catch (e) {

      handleError(e);
    }
  }

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    smsOTP = widget.smsOTP;
    phoneNo = widget.phoneNo;
    mobileNo = widget.mobileNo;

  }

  Future<MyUser> getUser( authResult)
  async{
    String uid = authResult.user.uid;

    var doc  =  await Firestore.instance.collection("users").document(uid).get();
    if(doc.exists)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      return MyUser.fromJson(doc.data);

    }else{


    await createUser(await _auth.currentUser());


      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {

        });
        showDialog(context: context,builder: (context)=>AlertDialog(
          title: Icon(Icons.error,color: Colors.red,size: 36,),
          content: Text("You entered a incorrect otp"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            },child: Text("Retry"),)
          ],
        ));
        break;
      default:
        showDialog(context: context,builder: (context)=>AlertDialog(
          title: Icon(Icons.error,color: Colors.red,size: 36,),
          content: Text("Your otp expired"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
              verifyPhone();
            },child: Text("Resend OTP"),)
          ],
        ));
        setState(() {

        });

        break;
    }
  }

  createUser(FirebaseUser fUser)async {
    try{
      loading = true;
      setState(() {

      });
      MyUser user = new MyUser(userEmail: fUser.email,userPhone: fUser.phoneNumber,uid: fUser.uid);

      var doc =  await Firestore.instance.collection("users").document(user.uid).get();

      await doc.reference.setData(user.toJson());

      loading = false;
      setState(() {

      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

    }catch(e)
    {
      loading= false;
      setState(() {

      });
    }


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
        loading =false;
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>confirmOtp(
          mobileNo: mobileNo,
          phoneNo: phoneNo,
          verificationId: verificationId,
          smsOTP: smsOTP,
        )));
      });
    };

    _auth =  FirebaseAuth.instance;
    try {
      var num = "+"+countryCode+phoneNo;
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
                .then((authResult)async {
              MyUser user = await getUser(authResult);

              loading = false;
              print(user);
              checkUser(user);

            });
          },
          verificationFailed: (exception) {
            print('${exception.message}');
            loading= false;
            setState(() {

            });
          });
    } catch (e) {

      loading = false;
      setState(() {

      });
      print(e.toString());
    }
  }

  checkUser(MyUser user){
    if(user==null)
    {
      print("null");
    }
    else{

    }
  }


}
