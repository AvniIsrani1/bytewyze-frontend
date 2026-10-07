import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:local_fork/core/models/scanned_item.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/features/barcode_scanning/barcode_controller.dart';
import 'package:local_fork/features/barcode_scanning/manual_barcode_dialog.dart';
import 'package:local_fork/features/barcode_scanning/rename_item_dialog.dart';
import 'package:local_fork/features/barcode_scanning/scan_cart_sheet.dart';
import 'package:local_fork/features/barcode_scanning/scanner_error_view.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({super.key});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  late final BarcodeController barcodeController;

  @override
  void initState() {
    super.initState();
    barcodeController = BarcodeController();
    barcodeController.addListener(_refresh);
  }

  // rebuild widget without changing state
  void _refresh() {
    if (!mounted) {
      return;
    }
    setState(() {});
    _showErrorIfAny();
  }

  // remove listener and dispose of controllers when page is removed
  @override
  void dispose() {
    barcodeController.removeListener(_refresh);
    barcodeController.dispose();
    super.dispose();
  }

  void _showErrorIfAny() {
    final message = barcodeController.barcodeState.errorMessage;
    if (message == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
      barcodeController.clearError();
    });
  }

  Future<void> _enterManually() async {
    final barcode = await ManualBarcodeDialog.show(context);
    if (barcode == null || !mounted) {
      return;
    }
    barcodeController.addManual(barcode);
  }

  Future<void> _rename(String barcode) async {
    final items = barcodeController.barcodeState.items;
    final item = items.where((i) => i.barcode == barcode).firstOrNull;
    if (item == null) {
      return;
    }

    final name = await RenameItemDialog.show(
      context,
      barcode: barcode,
      initialName: item.customName,
    );
    if (name == null || !mounted) {
      return;
    }
    barcodeController.rename(barcode, name);
  }

  void _done() {
    Navigator.of(context)
        .pop<List<ScannedItem>>(barcodeController.barcodeState.items);
  }

  // area the scanner reads from (centered above cart with margin)
  Rect _scanWindow(BoxConstraints constraints) {
    final width = math.min(constraints.maxWidth * 0.8, 320.0);
    return Rect.fromCenter(
      center: Offset(constraints.maxWidth / 2, constraints.maxHeight * 0.3),
      width: width,
      height: width * 0.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final barcodeState = barcodeController.barcodeState;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scanWindow = _scanWindow(constraints);

          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: barcodeController.scannerController,
                onDetect: barcodeController.onDetect,
                scanWindow: scanWindow,
                fit: BoxFit.cover,
                errorBuilder: (context, exception) => ScannerErrorView(
                  exception: exception,
                  onEnterManually: _enterManually,
                ),
              ),
              IgnorePointer(
                child: ScanWindowOverlay(
                  controller: barcodeController.scannerController,
                  scanWindow: scanWindow,
                  borderRadius: BorderRadius.circular(12),
                  borderColor: colorScheme.surface,
                ),
              ),
              _TopControls(
                barcodeController: barcodeController,
                onClose: () => Navigator.of(context).pop(),
              ),
              ScanCartSheet(
                barcodeState: barcodeState,
                onIncrement: barcodeController.increment,
                onDecrement: barcodeController.decrement,
                onRemove: barcodeController.remove,
                onRename: _rename,
                onEnterManually: _enterManually,
                onDone: _done,
              ),
            ],
          );
        },
      ),
    );
  }
}

// close, torch and camera-flip buttons
class _TopControls extends StatelessWidget {
  final BarcodeController barcodeController;
  final VoidCallback onClose;

  const _TopControls({required this.barcodeController, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              _OverlayButton(
                icon: Icons.close,
                tooltip: 'Cancel',
                onPressed: onClose,
              ),
              const Spacer(),
              ValueListenableBuilder<MobileScannerState>(
                valueListenable: barcodeController.scannerController,
                builder: (context, state, child) {
                  return Row(
                    children: [
                      if (state.torchState != TorchState.unavailable)
                        _OverlayButton(
                          icon: state.torchState == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          tooltip: 'Toggle flash',
                          onPressed: barcodeController.toggleTorch,
                        ),
                      if ((state.availableCameras ?? 0) > 1)
                        _OverlayButton(
                          icon: Icons.cameraswitch_outlined,
                          tooltip: 'Switch camera',
                          onPressed: barcodeController.switchCamera,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverlayButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _OverlayButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.surface,
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}
