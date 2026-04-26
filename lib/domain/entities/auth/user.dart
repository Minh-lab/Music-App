import 'package:spotify_me/data/models/user/user_model.dart';

class UserEntity {
  String? userId;
  String? fullName;
  String? email;
  String? avatar;
  UserEntity({this.userId, this.fullName, this.email, this.avatar});
}

extension ToUserModel on UserEntity {
  UserModel toUserModel() {
    return UserModel(id: userId!, name: fullName!, email: email!, avatar: avatar);
  }
}
