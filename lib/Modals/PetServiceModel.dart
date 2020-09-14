class PetService{
  String zip;
  String company;
  String distance;
  String country;
  String city;
  double latitude;
  double longitude;
  String services;
  String subCategory;
  String category;
  String addressLine1;
  String addressLine2;
  String certification;


  PetService({this.zip, this.country, this.city, this.latitude, this.longitude,
    this.services, this.subCategory, this.category, this.addressLine1,
    this.addressLine2,this.certification,this.company});

  static PetService fromMap(Map data) {
    return PetService(
      company: data['company name'],
      certification: data['certification'].toString(),
      addressLine1: data['address line 1'].toString(),
      addressLine2: data['address line 2'].toString(),
      zip: data['zip'].toString(),
      category: data['category'].toString(),
      subCategory: data['sub category'].toString(),
      services: data['services'].toString(),
      city: data['city'].toString(),
      country: data['country'].toString(),
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }



  static Map tomap(PetService petService)
  {
    return {
      'company name' :  petService.company,
      'certification': petService.certification,
      'address line 1': petService.addressLine1,
      'address line 2': petService.addressLine2,
      'zip':petService.zip,
      'category':petService.category,
      'sub category' : petService.subCategory,
      'services' : petService.services,
      'city': petService.city,
      'country': petService.country,
      'latitude': petService.latitude,
      'longitude': petService.longitude,
    };

  }


}
// {zip: 110078.0, country: India, city: New Delhi, latitude: 28.61208,
// services: Pet Supplies,
//     company name: Dog For sale, title: null, type: null, certification: null,
// address line 1: Sector 13, Dwarka, address line 2: null, last name:
// null, first name: null, latitude and longitude: 28.612080, 77.035284,
// phone: null, middle name: null, country code: null, state: Delhi, category: Shop,
// email: null, sub category: Breeder kennel, longitude: 77.03528}