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
        color: const Color(0xCCFFFFFF),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            title!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          text.isEmpty ? 'Sin datos' : text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorText,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            subtitle!.isEmpty ? 'Sin datos' : subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
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
                if (trailingWidget != null) ...[
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: trailingWidget,
                    ),
                  ),
                  if (trailing == null) const SizedBox(width: 20),
                ],
                if (trailing != null) ...[
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: Text(trailing!.length > 6
                          ? trailing!.substring(0, 6)
                          : trailing!),
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
