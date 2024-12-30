import 'package:flutter/material.dart';
import '../widgets/horizontalmenu_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../widgets/listitem_widget.dart';
import '../widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TitleWidget(title: 'KRiT 2025'),
      ),
      body: Column(
        children: [
          SearchbarWidget(),
          SizedBox(height: 16),
          Expanded(
            child: Container(),
          ),
          HorizontalMenuWidget(),
        ],
      ),
    );
  }

}
