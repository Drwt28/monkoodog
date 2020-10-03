/*
*  Issue    Name non-constant identifiers using lowerCamelCase.dart(non_constant_identifier_names)

   Issue    why used   User.initial()??? why not initialized it as a final?
*/

class User {
  //change String  from double
  double id;
  String uid;
  String userPhone;
  String userPass;
  String userNiceName;
  String userEmail = "";
  String userUrl;
  String userRegistered;
  String userActivationKey;
  int userStatus;
  String displayName;
  String errorDis;
  bool isSuccessful = true;
  String statusCode;
  String message;
  String latitude;
  String longitude;
  User(
      {this.id,
        this.uid,
      this.userPhone,
      this.userPass,
      this.displayName,
      this.userActivationKey,
      this.userEmail,
      this.userNiceName,
      this.userRegistered,
      this.userStatus,
      this.statusCode,
      this.message,
      this.userUrl});

  User.initial()
      : id = 0.0,
        uid = "",
        userPhone = '',
        userPass = '',
        userNiceName = '',
        userEmail = '',
        userUrl = '',
        statusCode = '',
        userRegistered = '',
        userActivationKey = '',
        userStatus = 0,
        displayName = '';

  User. fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        uid = json["uid"],
        userPhone = json['user_login'],
        userPass = json['user_pass'],
        userNiceName = json['user_nicename'],
        userEmail = json['user_email'],
        userUrl = json['user_url'],
        userRegistered = json['user_registered'],
        userActivationKey = json['user_activation_key'],
        userStatus = json['user_status'],
        displayName = json['display_name'],
        statusCode = json['statuscode'],
        message = json['message'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  User.errorFromServer(Map<String, dynamic> json) {
    statusCode = json['statuscode'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['user_login'] = this.userPhone;
    data['user_pass'] = this.userPass;
    data['user_nicename'] = this.userNiceName;
    data['user_email'] = this.userEmail;
    data['user_url'] = this.userEmail;
    data['user_registered'] = this.userRegistered;
    data['user_activation_key'] = this.userActivationKey;
    data['user_status'] = this.userStatus;
    data['display_name'] = this.displayName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
