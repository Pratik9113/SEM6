import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyForecastWidget({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Icon(
                  icon,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  temp,
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
