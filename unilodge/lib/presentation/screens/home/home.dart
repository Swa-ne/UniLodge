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
                ..._buildRegionFilterOptions(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildRegionFilterOptions() {
    List<String> regions = [
      'All Regions',
      'REGION I',
      'REGION II',
      'REGION III',
      'REGION IV',
      'REGION V',
    ];

    return regions.map((region) {
      return ListTile(
        title: Text(region),
        onTap: () {
          _filterRegion(region);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: BlocBuilder<RenterBloc, RenterState>(
        builder: (context, state) {
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
                      child: Center(
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
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildTypeCards(),
                      const SizedBox(height: 10),
                      _buildListingsHeader(),
                      const SizedBox(height: 10),
                      _buildListingsContent(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeCards() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.165,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () => context.push('/type-listing/Dorm'),
              child: const Cards(
                text: "Dorm",
                imageUrl: AppImages.dorm,
                color: Color.fromARGB(137, 235, 214, 183),
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/type-listing/Solo room'),
              child: const Cards(
                text: "Solo Room",
                imageUrl: AppImages.soloRoom,
                color: Color(0xffCCE1D4),
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/type-listing/Bed Spacer'),
              child: const Cards(
                text: "Bedspacer",
                imageUrl: AppImages.bedspacer,
                color: Color.fromARGB(141, 235, 233, 183),
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/type-listing/Apartment'),
              child: const Cards(
                text: "Apartment",
                imageUrl: AppImages.apartment,
                color: Color(0xffCDDDEA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Listings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortAndFilterBottomSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildListingsContent(RenterState state) {
    if (state is DormsLoading) {
      return const SizedBox(
        height: 800,
        child: ShimmerLoading(),
      );
    } else if (state is AllDormsLoaded) {
      if (state.allDorms.isEmpty) {
        return const NoListingPlaceholder();
      } else {
        return _buildSortedListings(state.allDorms);
      }
    } else if (state is DormsError) {
      return ErrorMessage(errorMessage: state.message);
    } else {
      return Container();
    }
  }

  Widget _buildSortedListings(List allDorms) {
    List sortedDorms = List.from(allDorms);

    // filter by region
    if (selectedRegion != 'All Regions') {
      sortedDorms =
          sortedDorms.where((dorm) => dorm.region == selectedRegion).toList();
    }

    // sort by price if selected
    if (_sortCriteria == 'price') {
      sortedDorms.sort((a, b) => a.price.compareTo(b.price));
    } else {
      // default sort by date
      sortedDorms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    // check if there are no listings after filtering
    if (sortedDorms.isEmpty) {
      return const Center(
        heightFactor: 1.8,
        child: NoListingPlaceholder(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedDorms.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            return ListingCards(listing: sortedDorms[index ~/ 2]);
          } else {
            return const Divider(
                height: 30, color: Color.fromARGB(255, 223, 223, 223));
          }
        },
      ),
    );
  }
}
