import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/listing/custom_card.dart';
import 'package:unilodge/data/models/listing.dart';

class PostAccommodation extends StatelessWidget {
  final Listing listing;

  const PostAccommodation({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What type of property do you want to list?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: _PropertySelection(listing: listing),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: _BottomNavigation(listing: listing),
          ),
        ],
      ),
    );
  }
}

class _PropertySelection extends StatelessWidget {
  final Listing listing;

  const _PropertySelection({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCard(
            context,
            'Dorm',
            'Shared room with multiple occupants; ideal for students and budget-friendly living.',
            AppImages.dormListing),
        _buildCard(
            context,
            'Solo Room',
            'Private room offering a quiet space for sleeping and studying.',
            AppImages.soloroomListing),
        _buildCard(
            context,
            'Bed Spacer',
            'Shared room with designated sleeping areas; a cost-effective living option.',
            AppImages.bedspacerListing),
        _buildCard(
            context,
            'Apartment',
            'Self-contained unit with separate bedrooms, kitchen, and living area.',
            AppImages.apartmentListing),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String cardName, String description,
      String iconImage) {
    return BlocBuilder<ListingBloc, ListingState>(
      builder: (context, state) {
        bool isSelected =
            state is CardSelectedState && state.selectedCard == cardName;

        return CustomCard(
          leading: Image.asset(iconImage, height: 300,),
          cardName: cardName,
          description: description,
          leadingWidth: 50,
          leadingHeight: 80,
          isSelected: isSelected,
          onTap: () {
            context.read<ListingBloc>().add(SelectCardEvent(cardName));
          },
        );
      },
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final Listing listing;

  const _BottomNavigation({required this.listing});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingBloc, ListingState>(
      builder: (context, state) {
        String selectedType = '';
        Listing updatedListing = listing;

        if (state is CardSelectedState) {
          selectedType = state.selectedCard;
          updatedListing = listing.copyWith(selectedPropertyType: selectedType);
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.horizontal(),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 119, 119, 119).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.black, width: 1),
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Back"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: selectedType.isNotEmpty
                    ? () {
                        context.push('/post-location', extra: updatedListing);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff2E3E4A),
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        );
      },
    );
  }
}
