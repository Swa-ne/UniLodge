import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Arellano Street, Dagupan City',
    'Bonuan Binloc, Dagupan City',
    'Bonuan Tondaligan, Dagupan City',
    'Carael, Dagupan City',
    'Pogo Grande, Dagupan City',
    'Pantal, Dagupan City',
    'Calasiao',
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1), // Subtle background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];

    for (var place in searchTerms) {
      if (place.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(place);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (var place in searchTerms) {
      if (place.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(place);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(title: Text(result, style: TextStyle(color: AppColors.textColor,))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 10, color: Color.fromARGB(255, 240, 239, 239)),
          ),
        ]);
      },
      itemCount: matchQuery.length,
    );
  }
}
