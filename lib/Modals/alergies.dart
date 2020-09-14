class Allergy {
  int id;
  String allergyName;

  Allergy({this.id, this.allergyName});

  Allergy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    allergyName = json['allergie_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allergie_name'] = this.id;
    data['name'] = this.allergyName;
    return data;
  }
}

