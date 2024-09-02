import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';

class ListingCards extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String address;
  final String price;

  const ListingCards(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.address,
      required this.price});

  @override
  State<ListingCards> createState() => _ListingCardsState();
}

class _ListingCardsState extends State<ListingCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    AppImages.dorm1,
                    width: 345,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Color(0xff454545),
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.star,
                        color: Color(0xffFFB800),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "#123 Arellano Street, Dagupan City",
                    style: TextStyle(color: Color(0xff454545)),
                  ),
                  Row(
                    children: [
                      Text(widget.price,
                          style: TextStyle(color: Color(0xff454545))),
                      Spacer(),
                      Icon(
                        Icons.favorite,
                        color: Color(0xffF04F43),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
