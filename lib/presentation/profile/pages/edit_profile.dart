import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/data/models/user/user_update_request.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/domain/entities/song/song.dart';
import 'package:spotify_me/domain/usecases/profile/get_profile_usecase.dart';
import 'package:spotify_me/domain/usecases/profile/update_profile.dart';
import 'package:spotify_me/presentation/profile/bloc/profile/profile_cubit.dart';
import 'package:spotify_me/presentation/profile/bloc/profile/profile_state.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _avatarEdit(context),
                const SizedBox(height: 50),

                _textField(
                  context,
                  fullNameController,
                  'Full Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                _textField(
                  context,
                  emailController,
                  'Email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 60),
                BlocConsumer<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return _saveButton(context, () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await context.read<ProfileCubit>().updateProfile(
                          UserUpdateRequest(
                            name: fullNameController.text.toString(),
                            email: emailController.text.toString(),
                          ),
                        );
                      }
                    });
                  },
                  listener: (context, state) {
                    if (state is UpdateProfileFailure) {
                      var snackBar = SnackBar(
                        content: Text(state.errorMessage ?? 'Error unknown'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if (state is UpdateProfileSuccess) {
                      var snackBar = const SnackBar(
                        content: Text('Update profile successfully'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      context.read<ProfileCubit>().getProfile();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
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
    String label, {
    String? Function(String?)? validator,
  }) {
    bool isDark = context.isDarkMode;

    // Khai báo màu động
    Color textColor = isDark ? Colors.white : Colors.black;
    Color labelColor = isDark ? Colors.white54 : Colors.black54;
    Color enabledBorderColor = isDark ? Colors.white30 : Colors.black38;
    Color focusedBorderColor = isDark ? Colors.white : Colors.black;

    return TextFormField(
      controller: controller,
      validator: validator,
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
