import 'dart:convert';

TokenResponse tokenResponseFromMap(String str) =>
    TokenResponse.fromMap(json.decode(str));

String tokenResponseToMap(TokenResponse data) => json.encode(data.toMap());

class TokenResponse {
  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  String accessToken;
  String refreshToken;

  factory TokenResponse.fromMap(Map<String, dynamic> json) => TokenResponse(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
