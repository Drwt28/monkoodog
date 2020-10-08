class NewPet {
  String id;
  String userId;
  String name;
  String gender;
  String dob;
  String age;
  int breedType;
  String breed;
  String primaryBreed;
  String secondaryBreed;
  List allergies;
  List diseases;
  String loves;
  String media = "";
  String created;
  String updated;
  double location;
  double latitude;
  double longitude;
  dynamic position;

  String distance;

  static Map<String, dynamic> getData(NewPet NewPet) {
    Map<String,dynamic> json = new Map();
    json['id'] = NewPet.id;
    json['userId'] = NewPet.userId;
    json['pet_name'] = NewPet.name;
    json['gender'] = NewPet.gender;
    json['dob'] = NewPet.dob;
    json['age'] = NewPet.dob;
    json['breed_type'] = NewPet.breedType;
    json['breed'] = NewPet.breed;
    json['pure_breed_type'] = NewPet.primaryBreed;
    json['mix_breed_type'] = NewPet.secondaryBreed;
    json['allergies'] = NewPet.allergies;
    json['diseases'] = NewPet.diseases;
    json['loves'] = NewPet.loves;
    json['media'] = NewPet.media;
    json['created'] = NewPet.created;
    json['updated'] = NewPet.updated;
    json['location'] = NewPet.location;
    json['latitude'] = NewPet.latitude;
    json['longitude'] = NewPet.longitude;
    json['distance'] = NewPet.distance??'0';
    json['position'] = NewPet.position;
    return json;
  }

  NewPet(
      {this.id,
        this.age,
        this.allergies,
        this.breed,
        this.breedType,
        this.created,
        this.diseases,
        this.dob,
        this.gender,
        this.loves,
        this.media,
        this.name,
        this.position,
        this.primaryBreed,
        this.secondaryBreed,
        this.updated,
        this.userId,
        this.location,
        this.latitude,
        this.longitude,
        this.distance});

  NewPet.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    userId = json['user_id']??"";
    name = json['pet_name']??'';
    gender = json['gender']??'';
    dob = json['dob']??'';
    age = json['age']??'';
    breedType = json['breed_type']??"";
    breed = json['breed']??'';
    primaryBreed = json['pure_breed_type']??'';
    secondaryBreed = json['mix_breed_type'];
    allergies = json['allergies']??[];
    diseases = json['diseases']??[];
    loves = json['loves']??'';
    media = json['media']??'';
    created = json['created'];
    updated = json['updated'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance']??'0';
  }
}
