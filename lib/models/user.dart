// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String? name = "";
  final String country = "";
  final Location location;
  final int phone;

  User(
    this.id,
    this.email,
    this.location,
    this.phone,
  );

  User copyWith({
    String? id,
    String? email,
    Location? location,
    int? phone,
  }) {
    return User(
      id ?? this.id,
      email ?? this.email,
      location ?? this.location,
      phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'location': location.toMap(),
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'] as String,
      map['email'] as String,
      Location.fromMap(map['location'] as Map<String,dynamic>),
      map['phone'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, location: $location, phone: $phone)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.location == location &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      location.hashCode ^
      phone.hashCode;
  }
}

class Location {
  final double longitude;
  final double latitude;

  Location(
    this.longitude,
    this.latitude,
  );

  Location copyWith({
    double? longitude,
    double? latitude,
  }) {
    return Location(
      longitude ?? this.longitude,
      latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      map['longitude'] as double,
      map['latitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(longitude: $longitude, latitude: $latitude)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;
  
    return 
      other.longitude == longitude &&
      other.latitude == latitude;
  }

  @override
  int get hashCode => longitude.hashCode ^ latitude.hashCode;
} 
