import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ask user to type barcode for unreadable barcodes

class ManualBarcodeDialog extends StatefulWidget {
  const ManualBarcodeDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ManualBarcodeDialog(),
    );
  }

  @override
  State<ManualBarcodeDialog> createState() => _ManualBarcodeDialogState();
}

class _ManualBarcodeDialogState extends State<ManualBarcodeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  String? _validateBarcode(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Barcode is required';
    }
    if (trimmed.length < 8 || trimmed.length > 14) {
      return 'Barcodes are 8 to 14 digits';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(_barcodeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter barcode'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _barcodeController,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14),
          ],
          decoration: const InputDecoration(
            hintText: 'e.g. 3017624010701',
            counterText: '',
          ),
          validator: _validateBarcode,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
