import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/home/pages/typeListingScreen.dart';
import 'package:unilodge/presentation/home/widgets/listingCards.dart';
import 'package:unilodge/presentation/home/widgets/typeCards.dart';
import 'package:unilodge/presentation/home/widgets/search.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(),
                    ),
                  );
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    height: 135,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TypeListingScreen(appbarTitle: "Apartment"),
                              ),
                            );
                          },
                          child: Cards(
                            text: "Apartment",
                            imageUrl: AppImages.apartment,
                            color: Color(0xffCDDDEA),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TypeListingScreen(appbarTitle: "Dorm"),
                              ),
                            );
                          },
                          child: Cards(
                            text: "Dorm",
                            imageUrl: AppImages.dorm,
                            color: Color.fromARGB(137, 235, 214, 183),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TypeListingScreen(appbarTitle: "Solo Room"),
                              ),
                            );
                          },
                          child: Cards(
                            text: "Solo Room",
                            imageUrl: AppImages.soloRoom,
                            color: Color(0xffCCE1D4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TypeListingScreen(appbarTitle: "Bedspacer"),
                              ),
                            );
                          },
                          child: Cards(
                            text: "Bedspacer",
                            imageUrl: AppImages.bedspacer,
                            color: Color.fromARGB(141, 235, 233, 183),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
