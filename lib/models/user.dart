
import 'package:mygoods_flutter/models/image.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.image,
    required this.preferenceId});

  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final Image image;
  final String address;
  final List<String> preferenceId;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}