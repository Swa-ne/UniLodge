import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unilodge/bloc/my_profile/my_profile_bloc.dart';
import 'package:unilodge/bloc/my_profile/my_profile_event.dart';
import 'package:unilodge/bloc/my_profile/my_profile_state.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/common/widgets/custom_loading.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/profile/editable_text_field.dart';
import 'package:unilodge/presentation/widgets/profile/read_only_field.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadProfile());

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "My Profile",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _usernameController.text = state.username;
              print('Full Name: ${state.fullName}');
              print('Username: ${state.username}');
              print('Email: ${state.personalEmail}');
              print('Birthday: ${state.birthday}');
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: ShimmerLoading());
              } else if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // GestureDetector(
                            //   onTap: _pickImage,
                            //   child: CircleAvatar(
                            //     radius: 50,
                            //     backgroundImage: _image != null
                            //         ? FileImage(_image!)
                            //         : state.profilePictureUrl.isNotEmpty
                            //             ? NetworkImage(state.profilePictureUrl)
                            //             : null,
                            //     child: _image == null &&
                            //             state.profilePictureUrl.isEmpty
                            //         ? const Icon(Icons.person, size: 50)
                            //         : null,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xff2E3E4A),
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFFFFFFFF),
                                  size: 50,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   right: 0,
                            //   bottom: 0,
                            //   child: IconButton(
                            //     icon: const Icon(
                            //       Icons.edit,
                            //       color: Colors.white,
                            //       size: 20,
                            //     ),
                            //     onPressed: _pickImage,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      EditableTextField(
                        label: 'Username',
                        controller: _usernameController,
                        value: state.username,
                      ),
                      const SizedBox(height: 30),
                      ReadOnlyField(label: 'Name', value: state.fullName),
                      const SizedBox(height: 20),
                      ReadOnlyField(label: 'Email', value: state.personalEmail),
                      const Divider(),
                      const SizedBox(height: 20),
                      ReadOnlyField(
                        label: 'Birthday',
                        value:
                            state.birthday.toLocal().toString().split(' ')[0],
                      ),
                      const Divider(),
                      const SizedBox(height: 24),
                      // Center(
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 50,
                      //         vertical: 10,
                      //       ),
                      //       backgroundColor: AppColors.lightBlueTextColor,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       final updatedProfilePictureUrl = _image != null
                      //           ? _image!.path
                      //           : state.profilePictureUrl;
                      //       bool isUsernameChanged =
                      //           _usernameController.text != state.username;
                      //       // print("profileeee: $updatedProfilePictureUrl");
                      //       context.read<ProfileBloc>().add(SaveProfile(
                      //             username: isUsernameChanged
                      //                 ? _usernameController.text
                      //                 : state.username,
                      //             fullName: state.fullName,
                      //             profilePictureUrl: updatedProfilePictureUrl,
                      //             personalEmail: state.personalEmail,
                      //             birthday: state.birthday,
                      //             firstName: state.firstName,
                      //             middleName: state.middleName,
                      //             lastName: state.lastName,
                      //           ));
                      //     },
                      //     child: const CustomText(
                      //       text: "Save",
                      //       color: Colors.white,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      CustomButton(
                          text: "Save",
                          onPressed: () {
                            final updatedProfilePictureUrl = _image != null
                                ? _image!.path
                                : state.profilePictureUrl;
                            bool isUsernameChanged =
                                _usernameController.text != state.username;
                            // print("profileeee: $updatedProfilePictureUrl");
                            context.read<ProfileBloc>().add(SaveProfile(
                                  username: isUsernameChanged
                                      ? _usernameController.text
                                      : state.username,
                                  fullName: state.fullName,
                                  profilePictureUrl: updatedProfilePictureUrl,
                                  personalEmail: state.personalEmail,
                                  birthday: state.birthday,
                                  firstName: state.firstName,
                                  middleName: state.middleName,
                                  lastName: state.lastName,
                                ));
                          })
                    ],
                  ),
                );
                // } else if (state is ProfileError) {
                //   return Center(
                //     child: CustomText(
                //       text: state.message,
                //       color: Colors.red,
                //       fontSize: 16,
                //     ),
                //   );
              } else {
                return const Center(child: CustomLoading());
              }
            },
          ),
        ),
      ),
    );
  }
}
