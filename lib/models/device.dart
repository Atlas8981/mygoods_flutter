import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  const Device({
    required this.platform,
    required this.token,
    required this.createdAt,
  });

  final String platform;
  final String token;
  final DateTime createdAt;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
