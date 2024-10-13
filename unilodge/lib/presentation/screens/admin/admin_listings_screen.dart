import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
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
  late RenterBloc _renterBloc;

  @override
  void initState() {
    super.initState();
    _renterBloc = BlocProvider.of<RenterBloc>(context);
    _renterBloc.add(FetchAllDorms());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenterBloc, RenterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const CustomText(
              text: 'Listings',
              color: AppColors.textColor,
              fontSize: 18,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: CustomStatus(
                        dataTitle: "Approved",
                        data: "16",
                        icon: Icon(
                          Icons.check_circle,
                          color: AppColors.lightBackground,
                        ),
                        color: AppColors.greenActive,
                      ),
                    ),
                    Expanded(
                      child: CustomStatus(
                        dataTitle: "Declined",
                        data: "16",
                        icon: Icon(
                          Icons.cancel,
                          color: AppColors.lightBackground,
                        ),
                        color: AppColors.redInactive,
                      ),
                    ),
                    Expanded(
                      child: CustomStatus(
                        dataTitle: "Pending",
                        data: "3",
                        icon: Icon(
                          Icons.hourglass_bottom,
                          color: AppColors.lightBackground,
                        ),
                        color: const Color.fromARGB(255, 163, 179, 127),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                  ],
                ),
                const SizedBox(
                    height: 20), // Space between statuses and the list

                // Conditional state rendering
                if (state is DormsLoading) ...[
                  const SizedBox(
                    height: 800,
                    child: ShimmerLoading(),
                  ),
                ] else if (state is AllDormsLoaded) ...[
                  if (state.allDorms.isEmpty) ...[
                    const NoListingPlaceholder(),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.allDorms.length,
                        itemBuilder: (context, index) {
                          final sortedDorms = List.from(state.allDorms)
                            ..sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));

                          final listing = sortedDorms[index];

                          return Column(
                            children: [
                              ListingCards(
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
                ] else if (state is DormsError) ...[
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
