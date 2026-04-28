import 'package:spotify_me/domain/entities/auth/user.dart';

class UserUpdateRequest {
  final String name;
  final String email;
  final String? avatar;
  UserUpdateRequest({required this.name, required this.email, this.avatar});

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequest(
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'avatar': avatar};
  }
}

extension ToEntityClass on UserUpdateRequest {
  UserEntity toEntity() {
    return UserEntity(email: email, fullName: name, avatar: avatar);
  }
}
