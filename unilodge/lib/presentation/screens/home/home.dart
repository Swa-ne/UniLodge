import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/error_message.dart';
import 'package:unilodge/common/widgets/no_listing_placeholder.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';
import 'package:unilodge/data/sources/chat/socket_controller.dart';
import 'package:unilodge/presentation/widgets/home/custom_drawer.dart';
import 'package:unilodge/presentation/widgets/home/listing_cards.dart';
import 'package:unilodge/presentation/widgets/home/type_cards.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ChatBloc _chatBloc;
  late RenterBloc _renterBloc;
  late SocketControllerImpl _socketController;
  String _sortCriteria = 'date';
  String selectedRegion = 'All Regions';

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _renterBloc = BlocProvider.of<RenterBloc>(context);
    _socketController = SocketControllerImpl();
    _socketController.passBloc(_chatBloc);

    _renterBloc.add(FetchAllDorms());
  }

  Future<void> _refreshDorms() async {
    _renterBloc.add(FetchAllDorms());
  }

  void _sortListings(String criteria) {
    setState(() {
      _sortCriteria = criteria; // update the sort criteria
    });
  }

  void _filterRegion(String region) {
    setState(() {
      selectedRegion = region; // update the selected region
    });
  }

  void _showSortAndFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sort & Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Sort by:'),
                ListTile(
                  title: const Text("Date"),
                  onTap: () {
                    _sortListings('date');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Price"),
                  onTap: () {
                    _sortListings('price');
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const Text('Filter by Region:'),
                ListTile(
                  title: const Text("All Regions"),
                  onTap: () {
                    _filterRegion('All Regions');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Region I"),
                  onTap: () {
                    _filterRegion('REGION I');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Region II"),
                  onTap: () {
                    _filterRegion('REGION II');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Region III"),
                  onTap: () {
                    _filterRegion('REGION III');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Region IV"),
                  onTap: () {
                    _filterRegion('REGION IV');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Region V"),
                  onTap: () {
                    _filterRegion('REGION V');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: BlocBuilder<RenterBloc, RenterState>(builder: (context, state) {
        return LiquidPullToRefresh(
          onRefresh: _refreshDorms,
          color: AppColors.primary,
          height: 80,
          animSpeedFactor: 2,
          showChildOpacityTransition: false,
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                backgroundColor: AppColors.lightBackground,
                pinned: true,
                floating: true,
                expandedHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'UniLodge',
                              style: TextStyle(
                                fontFamily: AppTheme.logoFont,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.logoTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.165,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push('/type-listing/Dorm');
                              },
                              child: const Cards(
                                text: "Dorm",
                                imageUrl: AppImages.dorm,
                                color: Color.fromARGB(137, 235, 214, 183),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push('/type-listing/Solo room');
                              },
                              child: const Cards(
                                text: "Solo Room",
                                imageUrl: AppImages.soloRoom,
                                color: Color(0xffCCE1D4),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push('/type-listing/Bed Spacer');
                              },
                              child: const Cards(
                                text: "Bedspacer",
                                imageUrl: AppImages.bedspacer,
                                color: Color.fromARGB(141, 235, 233, 183),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push('/type-listing/Apartment');
                              },
                              child: const Cards(
                                text: "Apartment",
                                imageUrl: AppImages.apartment,
                                color: Color(0xffCDDDEA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Listings",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.sort),
                                onPressed: _showSortAndFilterBottomSheet,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                              // filter and sort listings
                              List sortedDorms = List.from(state.allDorms);

                              // filter by region
                              if (selectedRegion != 'All Regions') {
                                sortedDorms = sortedDorms
                                    .where(
                                        (dorm) => dorm.region == selectedRegion)
                                    .toList();
                              }

                              // sort by price if selected
                              if (_sortCriteria == 'price') {
                                sortedDorms
                                    .sort((a, b) => a.price.compareTo(b.price));
                              } else {
                                // default sort by date
                                sortedDorms.sort((a, b) =>
                                    b.createdAt.compareTo(a.createdAt));
                              }

                              // check if there are no listings in the selected region
                              if (sortedDorms.isEmpty) {
                                return const NoListingPlaceholder();
                              }

                              return ListingCards(listing: sortedDorms[index]);
                            },
                          ),
                        ),
                      ],
                    ] else if (state is DormsError) ...[
                      ErrorMessage(errorMessage: state.message),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
