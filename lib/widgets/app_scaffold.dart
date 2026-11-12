// Shared scaffold that wraps every screen with a consistent AppBar and
// SafeArea so content never clips under status/navigation bars.

import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBack;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        // Show the back arrow only when there is something to pop.
        automaticallyImplyLeading: showBack,
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(child: body),
    );
  }
}
