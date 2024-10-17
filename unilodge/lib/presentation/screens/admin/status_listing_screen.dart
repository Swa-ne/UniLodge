import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/repository/admin_repository/admin_listing_repository_impl.dart';
import 'package:unilodge/presentation/widgets/admin/listing_cards.dart';

class StatusListingScreen extends StatelessWidget {
  const StatusListingScreen({super.key, required this.listingStatus});

  final String listingStatus;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(AdminListingRepositoryImpl())
        ..add(FetchAllDormsByStatus(listingStatus)),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            text: listingStatus,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        body: BlocBuilder<AdminBloc, AdminListingState>(
          builder: (context, state) {
            if (state is ListingLoading) {
              return const Center(child: ShimmerLoading());
            } else if (state is ListingError) {
              return Center(
                child: CustomText(
                  text: state.message,
                  fontSize: 18,
                  color: Colors.red,
                ),
              );
            } else if (state is ListingLoaded) {
              final listings = state.listings;
              if (listings.isEmpty) {
                return const NoListingPlaceholder();
              }

              return ListView.builder(
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return Column(
                    children: [
                      AdminListingCards(
                        listing: listing,
                      ),
                      const Divider(
                        height: 30,
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
