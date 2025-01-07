import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';

class EventTile extends StatelessWidget {
  final Event event;
  EventTile(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(event.logoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  event.timeBegin + " - " + event.timeEnd,
                  style: const TextStyle(
                    color: Color.fromRGBO(29, 27, 32, 1),
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(73, 69, 79, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing: 0.25,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.grey[700],
            size: 24,
          ),
        ],
      ),
    );
  }
}
