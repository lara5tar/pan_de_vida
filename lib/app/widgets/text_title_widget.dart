import 'package:flutter/material.dart';

class TextTitleWidget extends StatelessWidget {
  final String title;
  const TextTitleWidget(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
