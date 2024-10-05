import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/listing/widgets/customcard.dart';
import 'package:unilodge/presentation/listing/bloc/listing_bloc.dart';
import 'package:unilodge/presentation/listing/bloc/listing_event.dart';
import 'package:unilodge/presentation/listing/bloc/listing_state.dart';

class PostAccommodation extends StatelessWidget {
  const PostAccommodation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListingBloc(),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 70),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What type of property do you want to list?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: _PropertySelection(),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: _BottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCard(context, 'Bed Spacer',
            'Room shared with one or more occupants, ideal for cost-saving.'),
        _buildCard(context, 'Private Room',
            'Private Room, basic space for sleeping and studying.'),
        _buildCard(context, 'Entire Place',
            'Larger space with separate bedrooms, kitchen, and living area.'),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String cardName, String description) {
    return BlocBuilder<ListingBloc, ListingState>(
      builder: (context, state) {
        bool isSelected =
            state is CardSelectedState && state.selectedCard == cardName;

        return CustomCard(
          leading: Icon(Icons.bed, size: 90),
          cardName: cardName,
          description: description,
          leadingWidth: 50,
          leadingHeight: 80,
          isSelected: isSelected,
          onTap: () {
            context.read<ListingBloc>().add(SelectCardEvent(cardName));
            print('Selected: $cardName');
          },
        );
      },
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingBloc, ListingState>(
      builder: (context, state) {
        String selectedType = '';
        if (state is CardSelectedState) {
          selectedType = state.selectedCard;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.horizontal(),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
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
                        context.push('/post-location');
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
