import 'package:flutter/material.dart';
import '../widgets/horizontalmenu_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../widgets/listitem_widget.dart';
import '../widgets/title_widget.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
          ListItemWidget(
            time: '10:00 - 11:00',
            title: 'randka 1',
            imagePath: 'assets/images/Thumbnail.png',
          ),
          ListItemWidget(
            time: '11:00 - 12:00',
            title: 'randka 2',
            imagePath: 'assets/images/Thumbnail.png',
          ),
          ListItemWidget(
            time: '10:00 - 11:00',
            title: 'randka 3',
            imagePath: 'assets/images/Thumbnail.png',
          ),
          Expanded(
            child: Container(),
          ),
          HorizontalMenuWidget(),
        ],
      ),
    );
  }

}
