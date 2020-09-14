class Vaccination {
  int id;
  String nameVaccination;
  String age;
  String type;
  String medicationType;

  Vaccination({this.id, this.nameVaccination, this. age, this.type, this.medicationType});

  Vaccination.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameVaccination = json['medication_name'];
    age = json['age_from_birth'];
    type = json['type'];
    medicationType = json['medication_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['medication_name'] = this.nameVaccination;
    data['age_from_birth'] = this.age;
    data['type'] = this.type;
    data['medication_type'] = this.medicationType;
    return data;
  }
}
