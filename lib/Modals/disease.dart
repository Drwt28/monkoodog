class Disease{
  int id;
  String diseasesName;

  Disease(this.id,this.diseasesName);
  
  Disease.jsonFrom(Map<String,dynamic> json){
    id = json['id'];
    diseasesName = json['diseases_name'];
  } 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseases_name'] = this.diseasesName;
    data['id'] = this.id;
    return data;
  }

}