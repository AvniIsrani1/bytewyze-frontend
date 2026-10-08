import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorView extends StatelessWidget {
  final MobileScannerException exception;
  final VoidCallback onEnterManually;

  const ScannerErrorView({
    super.key,
    required this.exception,
    required this.onEnterManually,
  });

  ({IconData icon, String title, String message}) get _details {
    switch (exception.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        return (
          icon: Icons.no_photography_outlined,
          title: 'Camera access needed',
          message: 'Local Fork needs the camera to scan barcodes. Enable camera access for Local Fork in your device settings, then come back.',
        );
      case MobileScannerErrorCode.unsupported:
        return (
          icon: Icons.phonelink_erase_outlined,
          title: 'Scanning not supported',
          message: 'This device cannot scan barcodes. You can still add items by entering their barcode by hand.',
        );
      default:
        return (
          icon: Icons.error_outline,
          title: 'Camera unavailable',
          message: 'The camera could not be started. Close any other app using it and try again.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final details = _details;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: OverallPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(details.icon, size: 48),
              const SizedBox(height: AppSpacing.m),
              Text(
                details.title,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                details.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.l),
              FilledButton.icon(
                onPressed: onEnterManually,
                icon: const Icon(Icons.keyboard),
                label: const Text('Enter barcode manually'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
