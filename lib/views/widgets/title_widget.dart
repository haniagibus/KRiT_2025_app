import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFEF7FF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color.fromRGBO(29, 27, 32, 1),
                fontFamily: 'Roboto',
                fontSize: 22,
                letterSpacing: 0,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
