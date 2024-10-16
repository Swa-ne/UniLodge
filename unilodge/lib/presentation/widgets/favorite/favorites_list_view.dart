import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_favs_placeholder.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'favorites_card.dart';

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({super.key});

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  late RenterBloc _renterBloc;

  @override
  void initState() {
    super.initState();
    _renterBloc = BlocProvider.of<RenterBloc>(context);
    _fetchSavedDorms(); // Fetch saved dorms initially
  }

  void _fetchSavedDorms() {
    print('Fetching saved dorms...');
    _renterBloc.add(FetchSavedDorms());
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RenterBloc, RenterState>(
        builder: (context, state) {
          print('Current State: $state'); // Debugging log

          if (state is DormsLoading) {
            return const SizedBox(
              height: 800,
              child: ShimmerLoading(),
            );
          } else if (state is SavedDormsLoaded) {
            if (state.savedDorms.isEmpty) {
              return const Center(child: NoFavsPlaceholder());
            }
            return ListView.builder(
              itemCount: state.savedDorms.length,
              itemBuilder: (context, index) {
                final listing = state.savedDorms[index];
                return FavoriteCard(
                    listing: listing,
                    onBack: () {
                      _fetchSavedDorms();
                    });
              },
            );
          } else if (state is DormsError) {
            return ErrorMessage(errorMessage: state.message);
          }
          print('Current State: $state');
          return const Center(child: ShimmerLoading());
        },
      ),
    );
  }
}
