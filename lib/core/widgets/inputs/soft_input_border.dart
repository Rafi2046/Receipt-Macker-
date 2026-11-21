import 'package:flutter/material.dart';

/// A rounded outline that keeps the floating label inside the field,
/// instead of cutting it into the top edge like [OutlineInputBorder].
class SoftInputBorder extends OutlineInputBorder {
  const SoftInputBorder({super.borderSide, super.borderRadius});

  @override
  bool get isOutline => false;

  @override
  SoftInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) => SoftInputBorder(
    borderSide: borderSide ?? this.borderSide,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  @override
  SoftInputBorder scale(double t) => SoftInputBorder(
    borderSide: borderSide.scale(t),
    borderRadius: borderRadius * t,
  );
}
