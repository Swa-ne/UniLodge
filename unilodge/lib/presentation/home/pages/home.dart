import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/home/widgets/typeCards.dart';
import 'package:unilodge/presentation/home/widgets/listingCards.dart';
import 'package:unilodge/presentation/home/widgets/search.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        actions: [
          GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    icon: const Icon(Icons.search),
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
                  builder: (context) =>
                      UserProfile(), 
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                height: 135,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    Cards(
                      text: "Apartment",
                      imageUrl: AppImages.apartment,
                      color: Color(0xffCDDDEA),
                    ),
                    Cards(
                      text: "Dorm",
                      imageUrl: AppImages.dorm,
                      color: Color.fromARGB(137, 235, 214, 183),
                    ),
                    Cards(
                      text: "Solo Room",
                      imageUrl: AppImages.soloRoom,
                      color: Color(0xffCCE1D4),
                    ),
                    Cards(
                      text: "Bedspacer",
                      imageUrl: AppImages.bedspacer,
                      color: Color.fromARGB(141, 235, 233, 183),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --------- Listings Section ---------

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Listings",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  ListingCards(
                      imageUrl:
                          "https://asiasociety.org/sites/default/files/styles/1200w/public/D/dormroom.jpg",
                      property_name: "Solo room in Dagupan",
                      address: "#75 Amado Street, Dagupan City",
                      price: "₱5,000.00"),
                  const Divider(
                      height: 20, color: Color.fromARGB(255, 223, 223, 223)),
                  ListingCards(
                      imageUrl:
                          "https://media.istockphoto.com/id/492965743/photo/empty-university-college-dorm-room-with-bunkbed-desk-and-closet.jpg?s=170667a&w=0&k=20&c=iqe28qa_mLcpgWZtMOn-SHTHgxLHX8PacAgRH_KsYho=",
                      property_name: "Bedspacer in Dagupan",
                      address: "#123 Arellano Street, Dagupan City",
                      price: "₱5,000.00"),
                  const Divider(
                      height: 20, color: Color.fromARGB(255, 223, 223, 223)),
                  ListingCards(
                      imageUrl:
                          "https://www.shutterstock.com/image-photo/college-dorm-room-empty-freshman-600nw-2487430993.jpg",
                      property_name: "Bedspacer in Dagupan",
                      address: "#123 Arellano Street, Dagupan City",
                      price: "₱5,000.00"),
                  const Divider(
                      height: 20, color: Color.fromARGB(255, 223, 223, 223)),
                  ListingCards(
                      imageUrl:
                          "https://www.une.edu/sites/default/files/styles/block_image_large/public/2020-12/Avila-6259.jpg?itok=5HTs3fnj",
                      property_name: "Bedspacer in Dagupan",
                      address: "#123 Arellano Street, Dagupan City",
                      price: "₱5,000.00"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
