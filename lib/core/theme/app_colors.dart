import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;

  const AppColors({required this.success});

  @override
  AppColors copyWith({Color? success}) {
    return AppColors(success: success ?? this.success);
  }

  // so colors animate on theme switch
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(success: Color.lerp(success, other.success, t)!);
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
