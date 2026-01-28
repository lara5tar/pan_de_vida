import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cargando...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CircularProgressIndicator(
            color: Colors.blue.shade900,
          ),
        ],
      ),
    );
  }
}
