import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/home/listing_cards.dart';
import 'package:unilodge/presentation/widgets/home/type_cards.dart';
import 'package:unilodge/presentation/widgets/home/search.dart';
import 'package:unilodge/data/dummy_data/dummy_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.lightBackground,
            pinned: true,
            floating: true,
            actions: [
              GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: 300,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.search),
                      ),
                      const Text("Search"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  context.push("/user-profile");
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(AppImages.emptyProfile),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    height: 135,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/type-listing/Dorm');
                          },
                          child: Cards(
                            text: "Dorm",
                            imageUrl: AppImages.dorm,
                            color: Color.fromARGB(137, 235, 214, 183),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/type-listing/Solo room');
                          },
                          child: Cards(
                            text: "Solo Room",
                            imageUrl: AppImages.soloRoom,
                            color: Color(0xffCCE1D4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/type-listing/Bedspacer');
                          },
                          child: Cards(
                            text: "Bedspacer",
                            imageUrl: AppImages.bedspacer,
                            color: Color.fromARGB(141, 235, 233, 183),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/type-listing/Apartment');
                          },
                          child: Cards(
                            text: "Apartment",
                            imageUrl: AppImages.apartment,
                            color: Color(0xffCDDDEA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Listings",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dummyListings.length,
                    itemBuilder: (context, index) {
                      final listing = dummyListings[index];
                      return Column(
                        children: [
                          ListingCards(
                            listing: listing, // Pass the whole listing object
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
