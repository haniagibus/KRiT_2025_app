import 'package:flutter/material.dart';
import '../widgets/horizontalmenu_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../widgets/event_tile.dart';
import '../widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchbarWidget(),
          SizedBox(height: 16),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }

}
