import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final String text;
  final String? subtitle;
  final String? trailing;
  final IconData icon;
  final Function? onTap;
  final bool isLast;
  final Color colorText;
  final Color colorIcon;

  const ButtonWidget({
    super.key,
    this.title,
    required this.text,
    this.subtitle,
    this.trailing,
    required this.icon,
    this.onTap,
    this.isLast = false,
    this.colorText = Colors.black,
    this.colorIcon = const Color(0xFF616161),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      icon,
                      size: 20,
                      color: colorIcon,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        Text(
                          text.isEmpty ? 'Sin datos' : text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorText,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!.isEmpty ? 'Sin datos' : subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (trailing != null) ...[
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Center(
                        child: Text(trailing!.substring(0, 6)),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ]
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
