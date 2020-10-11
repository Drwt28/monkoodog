import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:monkoodog/Screens/Slider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1600)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SliderPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: AnimationConfiguration.toStaggeredList(
              duration: Duration(milliseconds: 1500),
              childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: -100,
                  child: FadeInAnimation(
                    child: widget,
                  )),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                    ),
                    decoration: getGradientDecoration(),
                  ),
                ),
                Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
              ]),
        ),
      ),
    );
  }

  BoxDecoration getGradientDecoration() {
    BoxDecoration decoration = BoxDecoration(
      image: DecorationImage(
          alignment: Alignment.center,
          fit: BoxFit.contain,
//        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: Image.asset("assets/images/logo.png", height: 200, width: 200)
              .image),
    );

    return decoration;
  }
}
