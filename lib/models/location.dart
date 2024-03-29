class Location {
  String street;
  String postalCode;
  String city;
  String state;
  double latitude;
  double longitude;

  Location(
      {required this.street,
      required this.postalCode,
      required this.city,
      required this.state,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "postalCode": postalCode,
      "city": city,
      "state": state,
      "longitude": longitude,
      "latitude":latitude
    };
  }
}
