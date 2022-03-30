// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) =>
    Device(
      platform: json['platform'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'token': instance.token,
      'createdAt': instance.createdAt.toIso8601String(),
    };
