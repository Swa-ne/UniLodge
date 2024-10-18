import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/my_profile/my_profile_bloc.dart';
import 'package:unilodge/bloc/my_profile/my_profile_event.dart';
import 'package:unilodge/bloc/my_profile/my_profile_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadProfile());

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 350,
              height: 80,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xff2E3E4A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFFFFFFF),
                        size: 36,
                      ),
                    ),
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: ShimmerLoading(),
                        );
                      } else if (state is ProfileLoaded) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomText(
                            text: state.username,
                            fontSize: 18,
                          ),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomText(text: "Error loading profile"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.help,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Help Center'),
                  onTap: () {
                    context.push("/help-center");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Bookings'),
                  onTap: () {
                    context.push("/bookings");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: AppColors.textColor,
                  ),
                  title: const Text('History'),
                  onTap: () {
                    context.push("/history");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    context.push("/settings");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
