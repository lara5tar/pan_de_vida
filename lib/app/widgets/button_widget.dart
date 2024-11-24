import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final String text;
  final String? subtitle;
  final String? trailing;
  final Widget? trailingWidget;
  final List<OptionWidget>? options;
  final IconData icon;
  final Function? onTap;
  final Color colorText;
  final Color colorIcon;
  final bool isLast;

  const ButtonWidget({
    super.key,
    this.title,
    required this.text,
    this.subtitle,
    this.trailing,
    this.trailingWidget,
    this.options,
    required this.icon,
    this.onTap,
    this.colorText = Colors.black,
    this.colorIcon = const Color(0xFF616161),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
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
                        if (title == null && subtitle == null)
                          const SizedBox(height: 10),
                        const SizedBox(height: 10),
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
                        // if (options != null)
                        //   Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //       for (var option in options!)
                        //         Expanded(
                        //           child: IconButton(
                        //             onPressed: () {},
                        //             icon: Icon(
                        //               option.icon,
                        //               size: 20,
                        //               color: Colors.grey[600],
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        const SizedBox(height: 10),
                        if (title == null && subtitle == null)
                          const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (trailing != null) ...[
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: Text(trailing!.substring(0, 6)),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                  if (trailingWidget != null) ...[
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: trailingWidget,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 60),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: isLast ? Colors.transparent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  OptionWidget({
    required this.text,
    required this.icon,
    required this.onTap,
  });
}
