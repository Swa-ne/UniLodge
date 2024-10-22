import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/presentation/widgets/admin/admin_listing_card.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';

class AdminUserDormsScreen extends StatefulWidget {
  final UserProfileModel user;
  const AdminUserDormsScreen({super.key, required this.user});

  @override
  State<AdminUserDormsScreen> createState() => _AdminUserDormsScreenState();
}

class _AdminUserDormsScreenState extends State<AdminUserDormsScreen> {
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();

    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.add(FetchUserListings(widget.user.id as String));
  }

  @override
  Widget build(BuildContext context) {
    _adminBloc.add(FetchUserListings(widget.user.id as String));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pushReplacement('/admin-dashboard-users');
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: CustomText(
          text: "${widget.user.username} Listings",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      body: BlocBuilder<AdminBloc, AdminListingState>(
        builder: (context, state) {
          if (state is ListingLoading) {
            return const SizedBox(
              height: 600,
              child: ShimmerLoading(),
            );
          } else if (state is ListingUserLoaded) {
            final sortedListings = List.from(state.listings);

            if (sortedListings.isEmpty) {
              return const Center(child: NoListingPlaceholder());
            }

            return ListView.builder(
              itemCount: sortedListings.length,
              itemBuilder: (context, index) {
                final listing = sortedListings[index];
                return AdminListingCard(listing: listing);
              },
            );
          } else if (state is ListingUserError) {
            return ErrorMessage(errorMessage: state.message);
          } else {
            return const Center(child: Text('No listings found.'));
          }
        },
      ),
    );
  }
}
