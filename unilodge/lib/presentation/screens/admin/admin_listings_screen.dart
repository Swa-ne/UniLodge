import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/admin/custom_status.dart';
import 'package:unilodge/presentation/widgets/admin/listing_cards.dart';

class AdminListingsScreen extends StatefulWidget {
  const AdminListingsScreen({super.key});

  @override
  State<AdminListingsScreen> createState() => _AdminListingsScreenState();
}

class _AdminListingsScreenState extends State<AdminListingsScreen> {
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.add(FetchListings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminListingState>(
      builder: (context, state) {
        int pendingCount = 0;
        int approvedCount = 0;
        int declinedCount = 0;

        if (state is ListingLoaded) {
          pendingCount = state.listings
              .where((listing) => listing.status == 'Pending')
              .length;
          approvedCount = state.listings
              .where((listing) => listing.status == 'Approved')
              .length;
          declinedCount = state.listings
              .where((listing) => listing.status == 'Declined')
              .length;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const CustomText(
              text: "Review Listings",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 7),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push('/status-listing/Approved');
                        },
                        child: CustomStatus(
                          dataTitle: "Approved",
                          data: approvedCount.toString(),
                          icon: const Icon(
                            Icons.check_circle,
                            color: AppColors.lightBackground,
                          ),
                          color: AppColors.greenActive,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push('/status-listing/Declined');
                        },
                        child: CustomStatus(
                          dataTitle: "Declined",
                          data: declinedCount.toString(),
                          icon: const Icon(
                            Icons.cancel,
                            color: AppColors.lightBackground,
                          ),
                          color: AppColors.redInactive,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push('/status-listing/Pending');
                        },
                        child: CustomStatus(
                          dataTitle: "Pending",
                          data: pendingCount.toString(),
                          icon: const Icon(
                            Icons.hourglass_bottom,
                            color: AppColors.lightBackground,
                          ),
                          color: AppColors.pending,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                  ],
                ),
                const SizedBox(height: 20),
                if (state is ListingLoading) ...[
                  const SizedBox(
                    height: 800,
                    child: ShimmerLoading(),
                  ),
                ] else if (state is ListingLoaded) ...[
                  if (state.listings.isEmpty) ...[
                    const NoListingPlaceholder(),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.listings.length,
                        itemBuilder: (context, index) {
                          final sortedDorms = List.from(state.listings)
                            ..sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));

                          final listing = sortedDorms[index];

                          return Column(
                            children: [
                              AdminListingCards(
                                listing: listing,
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
                ] else if (state is ListingError) ...[
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
