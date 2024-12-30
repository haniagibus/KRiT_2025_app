import 'package:flutter/material.dart';

class SearchbarWidget extends StatefulWidget {
  const SearchbarWidget({super.key});

  @override
  _SearchbarWidgetState createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFECE6F0),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Hinted search text',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: const Icon(Icons.search),
              ),
              style: const TextStyle(
                color: Color.fromRGBO(73, 69, 79, 1),
                fontFamily: 'Roboto',
                fontSize: 16,
                letterSpacing: 0.5,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
