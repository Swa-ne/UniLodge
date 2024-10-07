import 'dart:io';
import 'package:flutter/material.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:go_router/go_router.dart';
class PostReview extends StatelessWidget {
  const PostReview({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {

    List<String> imagePaths = listing.imageUrl?.isNotEmpty == true
        ? listing.imageUrl!.split(',').map((e) => e.trim()).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Review"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Review your Listing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Swipeable images section
            const Text(
              'Uploaded Images:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (imagePaths.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100);
                        },
                      ),
                    );
                  },
                ),
              )
            else
              const Text('No images uploaded'),

            const SizedBox(height: 20),

            // Display property details
            _buildInfoRow('Property Name:', listing.property_name),
            _buildInfoRow('Property Type:', listing.selectedPropertyType),
            _buildInfoRow('Address:', listing.address),
            _buildInfoRow('Price:', listing.price),
            _buildInfoRow('Description:', listing.description),
            _buildInfoRow('Lease Terms:', listing.leaseTerms),

            const SizedBox(height: 20),

            // Display amenities
            const Text(
              'Amenities:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (listing.amenities != null && listing.amenities!.isNotEmpty)
              ...listing.amenities!.map((amenity) => Text('- $amenity')).toList()
            else
              const Text('No amenities selected'),

            const SizedBox(height: 10),

            // Display utilities
            const Text(
              'Utilities:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (listing.utilities != null && listing.utilities!.isNotEmpty)
              ...listing.utilities!.map((utility) => Text('- $utility')).toList()
            else
              const Text('No utilities selected'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.horizontal(),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 119, 119, 119).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.pop(); // Go back to the previous page
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.black, width: 1),
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Back"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  
                  context.push('/home');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff2E3E4A),
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to display key-value info rows
  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$title ${value ?? "N/A"}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
