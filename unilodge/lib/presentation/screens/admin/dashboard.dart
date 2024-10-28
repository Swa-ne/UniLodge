import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/admin/custom_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AdminBloc _adminBloc;
  int listingCount = 0;
  int userCount = 0;
  @override
  void initState() {
    super.initState();
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.add(FetchListings());
    _adminBloc.add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);
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
      child: BlocBuilder<AdminBloc, AdminListingState>(
        builder: (context, state) {
          if (state is ListingLoaded) {
            listingCount = state.listings.length;
          }
          if (state is UsersLoaded) {
            userCount = state.users.length;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.lightBackground,
              centerTitle: true,
              title: const CustomText(
                text: "Dashboard",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    context.push("/admin-dashboard-users");
                  },
                  child: CustomContainer(
                      icon: const Icon(
                        Icons.people,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      dataTitle: "Users",
                      data: "$userCount"),
                ),
                GestureDetector(
                  onTap: () {
                    context.push("/admin-dashboard-listings");
                  },
                  child: CustomContainer(
                      icon: const Icon(
                        Icons.home_work,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      dataTitle: "Listings",
                      data: listingCount.toString()),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 150,
                  child: CustomButton(
                    text: "Log Out",
                    onPressed: () {
                      _authBloc.add(LogoutEvent());
                      _showLoading(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
