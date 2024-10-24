import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/repository/renter_repository_impl.dart';
import 'package:unilodge/presentation/widgets/home/listing_cards.dart';

class TypeListingScreen extends StatelessWidget {
  const TypeListingScreen({super.key, required this.listingType});

  final String listingType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RenterBloc(renterRepository: RenterRepositoryImpl())
        ..add(FetchAllDormsByType(listingType)), // Initial fetch
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            text: listingType,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        body: BlocListener<RenterBloc, RenterState>(
          listener: (context, state) {
            // Listen for state changes that require re-fetching
            if (state is DormSaved || state is DormUnsaved) {
              // Re-fetch dorms after save/delete actions
              context.read<RenterBloc>().add(FetchAllDormsByType(listingType));
            }
          },
          child: BlocBuilder<RenterBloc, RenterState>(
            builder: (context, state) {
              if (state is DormsLoading) {
                return const Center(child: ShimmerLoading());
              } else if (state is DormsError) {
                return Center(
                  child: CustomText(
                    text: state.message,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                );
              } else if (state is DormsLoaded) {
                final listings = state.allDorms; 
                if (listings.isEmpty) {
                  return const NoListingPlaceholder();
                }

                return ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return Column(
                      children: [
                        ListingCards(
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
      ),
    );
  }
}
