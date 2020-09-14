import 'package:flutter/material.dart';

import 'package:monkoodog/utils/utiles.dart';

/// Contains useful functions to reduce boilerplate code
class UIHelper {
  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceLarge = 60.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double HorizontalSpaceLarge = 60.0;

//HomeView constants
  static const double widgetHeading = 160;
  static const double heightHeading = 180;
  static const double widgetBlog = 150;
  static const double heightBlog = 100;
  static const double headingElevation = 10;
  static const double headingSizeLarge = 24;
  static const double headingSizeMedium = 20;
  static const String fontType = 'WorkSansBold';
  static const String fontTypeNormal = 'WorkSansMedium';
  static const Color offBlack = Colors.black54;

// Heading List constants
  static const double fontsizeSmall = 14;
  static const double fontsizeMedium = 18;
  static const double fontsizeLarge = 20;
  static const double fontSizeContent = 15.0;
  static const double fontSizeHeading = 17.0;
  static const double elevation = 10.0;
  static const Color black1 = Colors.black87;
  static Color grey = Colors.grey[300];
  static const String userLoginKey = 'userprofile';

  static Color color1 = Colors.black;
  static Color color2 = Colors.blue;
  static const contentLenth = 150;
  static const String petImgsPrefix =
      "https://www.monkoodog.com/wp-content/uploads/";
  static const String NO_INTERNET_EXCEP = 'No Internet connection 😑';
  static const String FORMATE_EXCEP = 'Could not find the post 😱';
  static const String BAD_RES_EXCEP = 'Bad response format 👎';

  static const List<String> blogsIntro = [
    'A paramedic who flew to New Zealands White Island to rescue tourists after Mondays volcanic eruption has said the scene was like something out of "the Chernobyl mini-series"',
    'Dozens of tourists were on the island at the time. Six have been confirmed dead. Eight others are feared to have died and about 30 have serious burns.',
    'To those who have lost or are missing family and friends, we share in your unfathomable grief and in your sorrow.',
    'There was a helicopter on the island that had obviously been there at the time and its rotor blades were off it.'
  ];
  static const List<String> imagesArray = [
    'scene3.png',
    'scene4.png',
    'scene5.png',
    'scene6.png'
  ];
  static const String url_no_img =
      "https://www.tiffanyjonesre.com/assets/images/image-not-available.jpg";

  static void snackBarDynamic(
      GlobalKey<ScaffoldState> _loginScafKey, String data) {
    _loginScafKey.currentState.showSnackBar(SnackBar(
      content: Text(
        data,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Utiles.primaryBgColor,
    ));
  }

  /// Returns a vertical space with height set to [_VerticalSpaceSmall]
  static Widget verticalSpaceSmall() {
    return verticalSpace(_VerticalSpaceSmall);
  }

  /// Returns a vertical space with height set to [_VerticalSpaceMedium]
  static Widget verticalSpaceMedium() {
    return verticalSpace(_VerticalSpaceMedium);
  }

  /// Returns a vertical space with height set to [_VerticalSpaceLarge]
  static Widget verticalSpaceLarge() {
    return verticalSpace(_VerticalSpaceLarge);
  }

  /// Returns a vertical space equal to the [height] supplied
  static Widget verticalSpace(double height) {
    return Container(height: height);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceSmall]
  static Widget horizontalSpaceSmall() {
    return horizontalSpace(_HorizontalSpaceSmall);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceMedium]
  static Widget horizontalSpaceMedium() {
    return horizontalSpace(_HorizontalSpaceMedium);
  }

  /// Returns a vertical space with height set to [HorizontalSpaceLarge]
  static Widget horizontalSpaceLarge() {
    return horizontalSpace(HorizontalSpaceLarge);
  }

  /// Returns a vertical space equal to the [width] supplied
  static Widget horizontalSpace(double width) {
    return Container(width: width);
  }
}
