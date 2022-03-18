import 'dart:convert';

UserDto userDtoFromMap(String str) => UserDto.fromMap(json.decode(str));

String userDtoToMap(UserDto data) => json.encode(data.toMap());

class UserDto {
  UserDto({
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.primaryPhone,
    required this.phones,
    required this.email,
    required this.address,
  });

  String password;
  String firstname;
  String lastname;
  String username;
  String primaryPhone;
  List<String> phones;
  String email;
  String address;

  factory UserDto.fromMap(Map<String, dynamic> json) => UserDto(
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        primaryPhone: json["primaryPhone"],
        phones: List<String>.from(json["phones"].map((x) => x)),
        email: json["email"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "primaryPhone": primaryPhone,
        "phones": List<dynamic>.from(phones.map((x) => x)),
        "email": email,
        "address": address,
      };
}
