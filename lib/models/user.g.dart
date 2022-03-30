// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      image: json['image'] == null
          ? null
          : myImage.Image.fromJson(json['image'] as Map<String, dynamic>),
      preferenceId: (json['preferenceId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'image': instance.image,
      'address': instance.address,
      'preferenceId': instance.preferenceId,
      'devices': instance.devices,
    };
