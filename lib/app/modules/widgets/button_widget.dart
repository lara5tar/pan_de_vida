import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function? onTap;
  final bool isLast;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      icon,
                      size: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(title),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 60),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
