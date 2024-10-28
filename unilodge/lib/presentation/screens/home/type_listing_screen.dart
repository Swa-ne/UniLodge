import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/home/listing_cards.dart';

class TypeListingScreen extends StatefulWidget {
  const TypeListingScreen({super.key, required this.listingType});

  final String listingType;

  @override
  State<TypeListingScreen> createState() => _TypeListingScreenState();
}

class _TypeListingScreenState extends State<TypeListingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RenterBloc>().add(FetchAllDorms()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: widget.listingType,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), 
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
            } else if (state is AllDormsLoaded) {
              final listings = state.allDorms.where((dorm) => dorm.selectedPropertyType == widget.listingType).toList();

              if (listings.isEmpty) {
                return const NoListingPlaceholder();
              }

              return ListView.builder(
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return Column(
                    children: [
                      ListingCards(listing: listing),
                      const Divider(height: 30, color: Color.fromARGB(255, 223, 223, 223)),
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
