import 'package:flutter/material.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/home/widgets/textRow.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;

  const ListingDetailScreen({Key? key, required this.listing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
      },
      child: Icon(Icons.message, color: Color(0xfffdfdfd),),
      backgroundColor: Color(0xff2E3E4A),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel,
                          color: Color.fromARGB(169, 60, 60, 67))),
                  Spacer(),
                  Icon(
                    Icons.favorite,
                    color: Color(0xffF04F43),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(listing.imageUrl,
                    width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                child: Text(listing.property_name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff434343))),
              ),
              TextRow(text1: "Address:", text2: listing.address),
              TextRow(text1: "Amenities:", text2: listing.amenities[0]),
              TextRow(text1: "Owner Information:", text2: listing.ownerInfo),
              TextRow(text1: "Description", text2: listing.description),
              SizedBox(height: 30),
              const Divider(
                  height: 20, color: Color.fromARGB(255, 223, 223, 223)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Reviews (14)", style: TextStyle(color: Color(0xff434343), fontSize: 15),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "dropdown reviews or direct to another screen",
                  style: TextStyle(color: Color(0xff434343), fontSize: 15),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Nearby",
                  style: TextStyle(color: Color(0xff434343), fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "maybe we can show nearby or recommended listings here",
                  style: TextStyle(color: Color(0xff434343), fontSize: 15),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
