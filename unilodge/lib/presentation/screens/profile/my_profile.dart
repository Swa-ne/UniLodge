import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/my_profile/my_profile_bloc.dart';
import 'package:unilodge/bloc/my_profile/my_profile_event.dart';
import 'package:unilodge/bloc/my_profile/my_profile_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/profile/editable_text_field.dart';
import 'package:unilodge/presentation/widgets/profile/read_only_field.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "My Profile",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.go("/settings");
            },
          ),
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              // if (state is ProfileSaved) {
              //   context.go("/settings");
              // }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  final TextEditingController usernameController =
                      TextEditingController(text: state.username);
                  final TextEditingController bioController =
                      TextEditingController(text: state.bio);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Center(
                          // todo: change to replaceable image
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50), //placeholder
                          ),
                        ),
                        const SizedBox(height: 30),
                        EditableTextField(
                          label: 'Username *',
                          controller: usernameController,
                        ),
                        const SizedBox(height: 20),
                        EditableTextField(
                          label: 'Bio',
                          controller: bioController,
                        ),
                        const SizedBox(height: 20),
                        ReadOnlyField(
                          label: 'Email',
                          value: state.email,
                        ),
                        const Divider(),
                        const SizedBox(height: 20),
                        ReadOnlyField(
                          label: 'Phone Number',
                          value: state.phoneNumber,
                        ),
                        const Divider(),
                        const SizedBox(height: 20),
                        ReadOnlyField(
                          label: 'Birthday',
                          value: state.birthday,
                        ),
                        const Divider(),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 10,
                              ),
                              backgroundColor: AppColors.lightBlueTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              context.read<ProfileBloc>().add(SaveProfile(
                                    username: usernameController.text,
                                    bio: bioController.text,
                                  ));
                            },
                            child: const CustomText(
                              text: "Save",
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(
                    child: CustomText(
                      text: state.message,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  );
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
