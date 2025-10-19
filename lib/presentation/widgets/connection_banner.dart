import 'package:flutter/material.dart';

class ConnectionBanner extends StatelessWidget {
  final bool online;
  const ConnectionBanner({super.key, required this.online});

  @override
  Widget build(BuildContext context) {
    if (online) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.red.withOpacity(0.12),
      child: const Text(
        'Internet connection not available',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
