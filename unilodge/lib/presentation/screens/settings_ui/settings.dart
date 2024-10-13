import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';
import 'package:unilodge/presentation/widgets/settings_widg/logout_confirm_bottom_sheet.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final TokenControllerImpl _tokenController = TokenControllerImpl();

    return FutureBuilder<String?>(
      future: _tokenController.getAccessToken(),
      builder: (context, snapshot) {
        final accessToken = snapshot.data;

        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.go("/account-selection-login");
            } else if (state is LogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
                onPressed: () {
                  context.push('/user-profile');
                },
              ),
              title: const CustomText(
                text: 'Settings',
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: AppColors.textColor),
                    title: const CustomText(
                      text: 'My Profile',
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      context.push('/my-profile');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock, color: AppColors.textColor),
                    title: const CustomText(
                      text: 'Change Password',
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      if (accessToken != null) {
                        context.push('/change-password/$accessToken');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token is unavailable')),
                        );
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.textColor),
                    title: const CustomText(
                      text: 'Logout',
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LogoutConfirmBottomSheet(
          onLogout: () {
            _authBloc.add(LogoutEvent());
            _showLoading(context); 
          },
        );
      },
    );
  }

  void _showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset('assets/animation/home_loading.json'),
          ),
        );
      },
    );
  }
}
