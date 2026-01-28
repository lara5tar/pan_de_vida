import 'package:flutter/material.dart';
import 'package:get/get.dart';

void confirmDialog({
  String content = '',
  String title = '',
  required void Function() confirmAction,
}) {
  Get.dialog(
    barrierColor: Colors.black87,
    barrierDismissible: false,
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.shade300,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
          ),
          onPressed: () => Get.back(),
          child: Text(
            'No',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.indigo.shade300,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
          ),
          onPressed: () async {
            Get.back();
            await Future.delayed(
              Duration(
                milliseconds: 800,
              ),
            );
            confirmAction();
          },
          child: Text(
            'Si',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
