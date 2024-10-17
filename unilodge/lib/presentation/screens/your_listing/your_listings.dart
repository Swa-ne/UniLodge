import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';
import 'package:unilodge/presentation/widgets/your_listing/listing_card.dart';

class Listings extends StatefulWidget {
  const Listings({super.key});

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  late ListingBloc _listingBloc;

  @override
  void initState() {
    super.initState();

    _listingBloc = BlocProvider.of<ListingBloc>(context);
    _listingBloc.add(FetchListings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: "Your Listings",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/post-accommodation');
        },
        backgroundColor: const Color(0xff2E3E4A),
        child: const Icon(
          Icons.add,
          color: Color(0xfffdfdfd),
        ),
      ),
      body: BlocBuilder<ListingBloc, ListingState>(
        builder: (context, state) {
          if (state is FetchingLoading) {
            return const SizedBox(
              height: 600,
              child: ShimmerLoading(),
            );
          } else if (state is ListingLoaded) {
            final sortedListings = List.from(state.listing)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (sortedListings.isEmpty) {
              return const Center(
                child: NoListingPlaceholder()
              );
            }

            return ListView.builder(
              itemCount: sortedListings.length,
              itemBuilder: (context, index) {
                final listing = sortedListings[index];
                return ListingCard(listing: listing);
              },
            );
            
          } else if (state is ListingError) {
            return ErrorMessage(errorMessage: state.message);
          } else {
            return const Center(child: Text('No listings found.'));
          }
        },
      ),
    );
  }
}
