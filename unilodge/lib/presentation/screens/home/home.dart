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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ChatBloc _chatBloc;
  late RenterBloc _renterBloc;
  late SocketControllerImpl _socketController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: BlocBuilder<RenterBloc, RenterState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _refreshDorms,
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  backgroundColor: AppColors.lightBackground,
                  pinned: true,
                  floating: true,
                  expandedHeight:
                      70, 
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     showSearch(
                              //       context: context,
                              //       delegate: CustomSearchDelegate(),
                              //     );
                              //   },
                              //   child: Container(
                              //     margin: const EdgeInsets.only(bottom: 8.0),
                              //     width: double.infinity,
                              //     padding: const EdgeInsets.all(8.0),
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey.withOpacity(0.1),
                              //       borderRadius: BorderRadius.circular(25),
                              //     ),
                              //     child: const Row(
                              //       children: [
                              //         Padding(
                              //           padding: EdgeInsets.only(right: 8.0),
                              //           child: Icon(Icons.search),
                              //         ),
                              //         Text("Search"),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: 8.0),
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
                      // const SizedBox(height: 10),
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Listings",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.allDorms.length,
                              itemBuilder: (context, index) {
                                final sortedDorms = List.from(state.allDorms)
                                  ..sort((a, b) =>
                                      b.createdAt.compareTo(a.createdAt));

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
              ],
            ),
          );
        },
      ),
    );
  }
}
