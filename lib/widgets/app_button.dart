// Reusable button with a built-in loading state.
// When [isLoading] is true the button is disabled and shows a spinner,
// preventing double-taps during network requests.

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  /// The label displayed on the button.
  final String label;

  /// Called when the button is tapped and not loading.
  final VoidCallback? onPressed;

  /// When true the button is disabled and shows a CircularProgressIndicator.
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Disable the button while a request is in-flight.
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(label),
    );
  }
}
