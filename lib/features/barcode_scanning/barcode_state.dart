import 'package:flutter/foundation.dart';
import 'package:local_fork/core/models/scanned_item.dart';

@immutable
class BarcodeState {
  final List<ScannedItem> items;
  final String? errorMessage;

  const BarcodeState({this.items = const [], this.errorMessage});

  // total units scanned
  int get totalCount => items.fold(0, (total, item) => total + item.quantity);

  bool get isEmpty => items.isEmpty;

  // return new state while keeping remaining values unchanged
  BarcodeState copyWith({
    List<ScannedItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BarcodeState(
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
