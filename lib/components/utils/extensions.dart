import 'package:denvin_stock/exports.dart';

extension ExtendedString on String{
  // (<member definition>)*
  bool get isValidName {
    return !contains(RegExp(r'[0–9]'));
  }

  String get prefixWith {
    return '$this $this';
  }

  String get formatPhoneNumber {
    if (length < 4) {
      return this;
    } else if (length < 7) {
      return '${substring(0, 3)}-${substring(3)}';
    } else {
      return '${substring(0, 3)}-${substring(3, 6)}-${substring(6)}';
    }
  }



  String get capsFirst{
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  int get toInt {
    return int.tryParse(this) ?? 0;
  }

}

extension ExtendedInt on int{

}


extension PaddingExtension on Widget {
  Widget withPadding({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }
}


// how to use
// Text('I am aligned at the start').alignAtStart(),
extension ExtendedAlign on Widget{

  alignAtTopRight() {
    return Align(
      alignment: Alignment.topRight,
      child: this,
    );
  }

  alignAtStart() {
    return Align(
      alignment: Alignment.centerLeft,
      child: this,
    );
  }

  alignAtCenter() {
    return Align(
      alignment: Alignment.center,
      child: this,
    );
  }

  alignAtEnd() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: this,
    );
  }
}

extension GestureDetectorExtension on Widget {
  GestureDetector onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: this,
    );
  }
}

