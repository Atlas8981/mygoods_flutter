import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      {required this.userId,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.image,
      required this.preferenceId});

  String userId;
  String username;
  String firstName;
  String lastName;
  String? email;
  String phoneNumber;
  myImage.Image? image;
  String address;
  List<String>? preferenceId;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{userId: $userId, username: $username, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, image: $image, address: $address, preferenceId: $preferenceId}';
  }
}
