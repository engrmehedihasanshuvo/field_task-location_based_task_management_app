import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/connectivity_provider.dart';

typedef AsyncAction = Future<void> Function();

Future<void> requireOnline(BuildContext context, AsyncAction action) async {
  final online = context.read<ConnectivityProvider>().online;
  if (!online) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You are offline. Please connect to the internet.')),
    );
    return;
  }
  await action();
}
