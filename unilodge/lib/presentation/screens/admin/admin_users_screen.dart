import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/admin/user_card.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminListingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const CustomText(
              text: 'Review Users',
              color: AppColors.textColor,
              fontSize: 18,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (state is ListingLoading) ...[
                  const SizedBox(
                    height: 800,
                    child: ShimmerLoading(),
                  ),
                ] else if (state is UsersLoaded) ...[
                  if (state.users.isEmpty) ...[
                    const NoListingPlaceholder(),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final usersList = List.from(state.users);
                          final user = usersList[index];

                          return Column(
                            children: [
                              AdminUserCards(
                                user: user,
                              ),
                              const Divider(
                                height: 20,
                                color: Color.fromARGB(255, 223, 223, 223),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ]
                ] else if (state is UsersError) ...[
                  ErrorMessage(errorMessage: state.message),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
