import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_fork/core/models/product.dart';
import 'package:local_fork/core/models/scanned_item.dart';
import 'package:local_fork/features/barcode_scanning/barcode_state.dart';
import 'package:local_fork/features/barcode_scanning/product_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeController extends ChangeNotifier {
  // accepted retail formats
  static const List<BarcodeFormat> _retailFormats = [
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.upcA,
    BarcodeFormat.upcE,
    BarcodeFormat.code128,
  ];

  static const Duration _rescanCooldown = Duration(milliseconds: 1500);

  final ProductRepository _productRepository;

  final MobileScannerController scannerController;

  BarcodeState _barcodeState = const BarcodeState();

  final Map<String, DateTime> _lastAccepted = {};

  bool _disposed = false;

  BarcodeController({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ApiProductRepository(),
      scannerController = MobileScannerController(
        formats: _retailFormats,
        detectionSpeed: DetectionSpeed.normal,
        detectionTimeoutMs: 500,
        autoZoom: true,
      );

  // getter
  BarcodeState get barcodeState => _barcodeState;

  // setter
  void _setState(BarcodeState newBarcodeState) {
    if (_disposed) {
      return;
    }
    _barcodeState = newBarcodeState;
    notifyListeners();
  }

  int _indexOf(String barcode) =>
      _barcodeState.items.indexWhere((item) => item.barcode == barcode);

  void _replaceAt(int index, ScannedItem item) {
    final items = [..._barcodeState.items];
    items[index] = item;
    _setState(_barcodeState.copyWith(items: items));
  }

  // scanning

  // handle detection from camera
  void onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue == null || rawValue.isEmpty) {
        continue;
      }
      _accept(rawValue);
    }
  }

  // add barcode typed by hand
  void addManual(String barcode) {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _lastAccepted.remove(trimmed);
    _accept(trimmed);
  }

  void _accept(String barcode) {
    final now = DateTime.now();
    final lastSeen = _lastAccepted[barcode];
    if (lastSeen != null && now.difference(lastSeen) < _rescanCooldown) {
      return;
    }
    _lastAccepted[barcode] = now;

    _signalScan();

    final existing = _indexOf(barcode);
    if (existing >= 0) {
      // already in the cart aka another of the same item
      final item = _barcodeState.items[existing];
      _replaceAt(existing, item.copyWith(quantity: item.quantity + 1));
      return;
    }

    _setState(
      _barcodeState.copyWith(
        items: [
          ..._barcodeState.items,
          ScannedItem(product: Product.unknown(barcode), isLookingUp: true),
        ],
        clearError: true,
      ),
    );

    _resolve(barcode);
  }

  Future<void> _resolve(String barcode) async {
    try {
      final product = await _productRepository.lookup(barcode);

      final index = _indexOf(barcode);
      if (index < 0) {
        return;
      }

      _replaceAt(
        index,
        _barcodeState.items[index].copyWith(
          product: product,
          isLookingUp: false,
        ),
      );
    } on ProductLookupException catch (e) {
      final index = _indexOf(barcode);
      if (index < 0) {
        return;
      }

      final items = [..._barcodeState.items];
      items[index] = items[index].copyWith(isLookingUp: false);
      _setState(_barcodeState.copyWith(items: items, errorMessage: e.message));
    }
  }

  void _signalScan() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }

  // cart edits

  void increment(String barcode) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    final item = _barcodeState.items[index];
    _replaceAt(index, item.copyWith(quantity: item.quantity + 1));
  }

  // decrement row
  void decrement(String barcode) {
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    final item = _barcodeState.items[index];
    if (item.quantity <= 1) {
      remove(barcode);
      return;
    }
    _replaceAt(index, item.copyWith(quantity: item.quantity - 1));
  }

  void remove(String barcode) {
    final items = _barcodeState.items
        .where((item) => item.barcode != barcode)
        .toList();
    _lastAccepted.remove(barcode);
    _setState(_barcodeState.copyWith(items: items));
  }

  void rename(String barcode, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final index = _indexOf(barcode);
    if (index < 0) {
      return;
    }
    _replaceAt(index, _barcodeState.items[index].copyWith(customName: trimmed));
  }

  void clearAll() {
    _lastAccepted.clear();
    _setState(const BarcodeState());
  }

  void clearError() {
    if (_barcodeState.errorMessage == null) {
      return;
    }
    _setState(_barcodeState.copyWith(clearError: true));
  }

  // camera controls

  Future<void> toggleTorch() => scannerController.toggleTorch();

  Future<void> switchCamera() => scannerController.switchCamera();

  // when screen is removed, dispose of controllers
  @override
  void dispose() {
    _disposed = true;
    scannerController.dispose();
    super.dispose();
  }
}
