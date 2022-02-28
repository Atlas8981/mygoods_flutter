// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] as String,
    username: json['username'] as String,
    firstName: json['firstname'] as String,
    lastName: json['lastname'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    address: json['address'],
    image: myImage.MyImage.fromJson(json['image'] as Map<String, dynamic>),
    preferenceId: (json['preferenceid'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'image': instance.image!.toJson(),
      'preferenceid': instance.preferenceId,
    };
