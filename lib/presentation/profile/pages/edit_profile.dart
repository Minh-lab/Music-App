import 'package:flutter/material.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/domain/usecases/profile/get_profile_usecase.dart';
import 'package:spotify_me/service_locator.dart';
// import 'package:spotify_me/core/configs/theme/app_colors.dart'; // Mở comment nếu cần dùng AppColors cho nút Save

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // Luôn nhớ dispose controller để tránh tràn bộ nhớ
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: context.isDarkMode ? const Color(0xFFDBDBDB) : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Thêm cuộn để tránh lỗi tràn bàn phím khi gõ
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            children: [
              _avatarEdit(context),
              const SizedBox(height: 50),

              // Sử dụng lại hàm _textField cho nhiều ô nhập liệu khác nhau
              _textField(context, fullNameController, 'Full Name'),
              const SizedBox(height: 50),
              _textField(context, emailController, 'Email'),
              const SizedBox(height: 20),

              const SizedBox(height: 60),
              _saveButton(context, () async {
                var result = await sl<GetProfileUsecase>().call();
                result.fold(
                  (l) {
                    print(l.toString());
                  },
                  (r) {
                    if(r is UserEntity){
                      print(r.email);
                      print(r.fullName);
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarEdit(BuildContext context) {
    bool isDark = context.isDarkMode;

    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFD9D9D9),
              ),
              child: ClipOval(
                child: Icon(
                  Icons.person_outline_outlined,
                  size: 60,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Nếu bạn có AppColors.primary (màu xanh Spotify), hãy thay vào đây
                  color: Colors.blue,
                  border: Border.all(
                    color: isDark
                        ? Colors.black
                        : Colors
                              .white, // Tạo viền cắt để icon nổi bật khỏi nền avatar
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors
                      .white, // Icon bên trong nút thêm ảnh luôn là màu trắng cho dễ nhìn
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    bool isDark = context.isDarkMode;

    // Khai báo màu động
    Color textColor = isDark ? Colors.white : Colors.black;
    Color labelColor = isDark ? Colors.white54 : Colors.black54;
    Color enabledBorderColor = isDark ? Colors.white30 : Colors.black38;
    Color focusedBorderColor = isDark ? Colors.white : Colors.black;

    return TextField(
      controller: controller,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label, // Dùng biến label truyền vào
        labelStyle: TextStyle(color: labelColor, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context, VoidCallback onPressed) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // Nên dùng AppColors.primary ở đây nếu bạn đã định nghĩa nó
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
